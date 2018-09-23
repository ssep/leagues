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


## Application structure

`leagues` is a simple OTP application. It has a main supervisor with two children:

- HTTP API
- Storage

High level modules are:

- __Leagues__: Implements OTP application behavior and provides application level utilies
- __Leagues.Sup__: Implements OTP supervisor behavior and starts up the HTTP server and the storage
- __Leagues.Api__: Module to provide a fixed interface between the HTTP API and the Storage

### HTTP API

The HTTP API functionality is implemented on top of [maru](https://github.com/elixir-maru/maru) Framework.

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
