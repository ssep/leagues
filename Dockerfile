FROM ubuntu

# External args
ARG VERSION=0.1.0
ARG APP_NAME=leagues

# System requirements
RUN apt-get update && apt-get install -y libssl1.0.0 locales

# Get the packaged release
RUN mkdir -p /opt/${APP_NAME}/
COPY ./_build/prod/rel/${APP_NAME}/releases/${VERSION}/${APP_NAME}.tar.gz \
     /opt/${APP_NAME}/${APP_NAME}.tar.gz
WORKDIR /opt/${APP_NAME}
RUN tar xvzf ${APP_NAME}.tar.gz

# Configure locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

EXPOSE 8080
ENTRYPOINT ["/opt/leagues/bin/leagues"]
CMD ["foreground"]