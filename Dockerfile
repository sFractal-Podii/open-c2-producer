# heavily borrowed from https://elixirforum.com/t/cannot-find-libtinfo-so-6-when-launching-elixir-app/24101/11?u=sigu
FROM hexpm/elixir:1.17.3-erlang-27.1.3-debian-bullseye-20250520 AS app_builder

ARG env=prod

ARG CLIENT_ID=Openc2Producer2023
ARG MQTT_HOST="broker.emqx.io"
ARG MQTT_PORT=1883
ARG USER_NAME=plug
ARG PASSWORD=fest
ARG HIVEMQ_HOST="broker.hivemq.com"
ARG HIVEMQ_PORT=1883
ARG HIVEMQ_CLIENT_ID=hive_open_c2_producer

ENV LANG=C.UTF-8
ENV CLIENT_ID=$CLIENT_ID
ENV MQTT_HOST=$MQTT_HOST
ENV MQTT_PORT=$MQTT_PORT
ENV USER_NAME=$USER_NAME
ENV PASSWORD=$PASSWORD
ENV HIVEMQ_HOST=$HIVEMQ_HOST
ENV HIVEMQ_PORT=$HIVEMQ_PORT
ENV HIVEMQ_CLIENT_ID=$HIVEMQ_CLIENT_ID



ENV LANG=C.UTF-8 \
    TERM=xterm \
    MIX_ENV=$env

RUN mkdir /opt/release
WORKDIR /opt/release

RUN mix local.hex --force && mix local.rebar --force
RUN apt-get update && apt-get install curl git libicu-dev -y 

RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

COPY mix.exs .
COPY mix.lock .
RUN mix deps.get && mix deps.compile

COPY assets ./assets
COPY config ./config
COPY lib ./lib
COPY priv ./priv

RUN mix sbom.install && mix sbom.cyclonedx && mix sbom.convert

# make sbom for the production docker image
RUN syft debian:bullseye-slim -o spdx > debian.buster_slim-spdx-bom.spdx \
    && syft debian:bullseye-slim -o spdx-json > debian.buster_slim-spdx-bom.json \
    && syft debian:bullseye-slim -o cyclonedx-json > debian.buster_slim-cyclonedx-bom.json \
    && syft debian:bullseye-slim -o cyclonedx > debian.buster_slim-cyclonedx-bom.xml

RUN cp *bom* ./priv/static/.well-known/sbom/

RUN mix assets.deploy && mix release

FROM debian:bullseye-slim AS app

ENV LANG=C.UTF-8
ENV HOST 0.0.0.0

EXPOSE 8080

RUN useradd --create-home app
WORKDIR /home/app
COPY --from=app_builder /opt/release/_build/ .
RUN chown -R app: ./prod
USER app

CMD ["./prod/rel/open_c2_producer/bin/open_c2_producer", "start"]
