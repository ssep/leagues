# Leagues

Application to provide available information for Football leagues.

Information currently available:

- League list
- Season list for a league
- Scores for a league and season

## API documentation

API documentation can be generated running

```
make doc
```

And the opening the provided path in the browser of your preference

__NOTE__: Documentation is written using [apidoc](https://www.google.com/search?client=ubuntu&channel=fs&q=apidoc&ie=utf-8&oe=utf-8) utility and it requires `npm` to be installed as well as API doc application.

To install `apidoc` (once `npm` is installed), run:

```
npm install apidoc -g
```

### Basic requests

These are the basic requests supported:

- Get available leagues

```
curl -s http://127.0.0.1/v1/leagues/
```

- Get seasons for league `sp1`

```
curl -s http://127.0.0.1/v1/leagues/sp1/seasons
```

- Get scores for league `sp1` and season `201516`

```
curl -s http://127.0.0.1/v1/leagues/sp1/seasons/201516/scores
```

__NOTE__: For more details see the API doc

## How to use

### Creating a release

To create a release execute

```
make release
```

__NOTE__: The release uses [distillery](https://github.com/bitwalker/distillery) library to generate all the required files for the application packaging

### How to run

There are two option to run the application: locally or as a release using `docker`

### Running locally

To run it locally execute

```
make shell
```

It will get all dependencies, compile and run the application

### Running with docker

To build it run:

```
make deploy
```

To take it down run

```
make undeploy
```

#### What is included

```
        HA Proxy
       /        \
      /          \
     v            v
 Leagues  ...  Leagues
     \           /
      \         /
       v       v
       Influx DB   <--- Grafana
```

To do this deploy, a docker compose file is used to create:

- Three instances running the application
- An HA proxy instance listerning on port 80 balancing the request to the application instances

To be noted in HA proxy configuration:

- It uses round robin to balance requests
- It also has port `1936` open in the localhost to have access to the statistics page (use `stats:stats` to access)

Also, two extra containers are created in order to provide metrics functionality:

- InfluxDb
- Grafana

Metrics included are:

- Request count by status reply
- Request count by endpoint
- `vmstats` application reported metrics

##### InfluxDB

This is an influxDB container where all metric will be pushed by the instance applications.

In provides the following functionality:

- Exposes port `8083` for administration (no credentials)
- Exposes port `8086` for for HTTP interface (no credentials)
- Exposes UDP port `4444` to receive metrics
- Containers linked to it can find it using `influxdb` as hostname

All application containers are linked to it in order to be able to send the metrics. Configuration is set in `config/prod.exs`. This means that applications will report data only if production environment is used

__NOTE__: No external volumes are used. This means that all data is inside the container and will be lost if the container is recreated.

##### Grafana

A `grafana` container is created linked to `influxdb`. To see and create metrics follow these steps:

- Access the container on `http://localhost:3000`
- Credentials to access are `admin:admin`
- Create a data source:
  - Type should be InfluxDb
  - URL should be set to `http://influxdb:8086`
  - Database should be set to `metrics`

## Application structure

`leagues` is a simple OTP application. It has a main supervisor with three children:

- HTTP API
- Storage
- Metrics

```
        Supervisor
       /     |    \
      /      |     \
     v       v      v
HTTP API  Storage  Metrics
```

High level modules are:

- __Leagues__: Implements OTP application behavior and provides application level utilies
- __Leagues.Sup__: Implements OTP supervisor behavior and starts up the HTTP server and the storage
- __Leagues.Api__: Module to provide a fixed interface between the HTTP API and the Storage

### HTTP API

The HTTP API functionality is implemented on top of [maru](https://github.com/elixir-maru/maru) Framework. Application is started by default using port `8080`

Two formats are supported for the data:

- JSON is supported using [jason](https://github.com/michalmuskala/jason) for encoding / decoding.
- Protocol Buffers is provided usin [exprotobuf](https://github.com/bitwalker/exprotobuf) for encoding / decoding.

Implemented modules are:

- __Leagues.Http__: Implements general functionality for the HTTP API: error handling and reply formatting
- __Leagues.Http.Server__: `maru` HTTP server
- __Leagues.Http.Leagues.V1__: Version 1 implemenetation of the `leagues` endpoint. It declares all the routes and request the required data to fullfill the request (see API doc section for detils of the routes)
- __Leagues.Http.Protobuf__: Protocol Buffers data encoding / decoding implementation

### Storage

The storage of the application is implemented as a simple `GenServer` that encapsulates all the requests for data. Two data structures are maintained:

- A leagues `map` in the `GenServer` state to efficiently provide leagues and seasons imformation.
- ETS based storage to have all scores indexed by league / season

It also self initilializes by loading a default [data.csv](priv/data.csv) file using [csv](https://github.com/beatrichartz/csv) library.

Functionality is implemented in the modules:

- __Leagues.Storage__: `GenServer` that exposes API to get requires data: leagues, seasons and scores.
- __Leagues.Storage.Ets__: ETS based implementation of the storage. Table is configured as a `bag` to simplify querying scores for league / season
- __Leagues.Score__: Utility module to parse the data from the CSV file into a formated map to be returned to the client.

### Metrics

Metrics are implemented using application [fluxter](https://github.com/lexmag/fluxter). 

Functionality is implemented in module:

- __Leagues.Metrics__: It implements functions `count/1` and `count/2` to send metrics with and without tags. Also, it implements the `vmstats` behavior and `vmstats` dependency is included to send metrics.

__NOTE__: It is configured to send metrics only when using production environment. For other environments, default configuration is used, which points to `8092` and `127.0.0.1`
