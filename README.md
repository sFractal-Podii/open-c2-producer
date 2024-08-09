# OpencC2Test

Openc2Test is a dashboard for testing connection between a publisher(Openc2Test) and subscriber(TwinklyMaha) over a broker. In this case, openc2test publishes a topic subscribed to by TwinklyMaha.
This dashboard provides a convinient way for choosing a desired broker and the command you
wish to test with.

## Setup Guide

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Create a file `.env` in the project root and add the following environment variables:
    * export CLIENT_ID=:add your client_id
    * export MQTT_HOST=test.mosquitto.org
    * export MQTT_PORT=1883
    * export USER_NAME=plug
    * export PASSWORD=fest
  * Source the environment variables by running `source .env`. This contains environment specific settings and keys.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

## How to use the project

We are currently only testing one device [TwinklyMaha](https://github.com/sFractal-Podii/TwinklyMaHa). Make sure to have it set up and running to begin the test.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. Follow the following steps to run this project.

1. Select the type of device you wish to test eg. TwinklyMaha.

2. Select broker to use, eg emqx_broker; HiveMQ and EMQX are MQTT brokers designed to facilitate efficient and secure communication between IoT devices and applications.

3. Choose the command to run, eg. Turn_led_on/off

4. Click Run.

![UI screenshot](docs/Screenshot%20from%20openc2.png)

We designed this user interface (UI) to be quick and simple to use without requiring the user to input commands on the terminal, making it convenient for both technical and non-technical users.

## Expected results

At this point, the TwinklyMaha is connected to the broker and it's subscribed to the topic published by Openc2test. You can just head over to TwinklyMaha to see your changes.

![UI screenshot](docs/Screenshot%20from%20TwinklyMaha.png)

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
