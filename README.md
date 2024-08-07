# OpencC2Test

OpenC2 is a standardized language for controlling cyber defense technologies. It allows different systems and components to communicate and coordinate with each other, regardless of the specific products or technologies they use. This enables automated and efficient management of cyber defenses.

## Setup Guide

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Source the environment variables by running `source .env`. This contains environment specific settings and keys.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

## How to use the project

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. Follow the following steps to run your project.

1. Select the type of device you wish to test eg. TwinklyMaha.

2. Select broker to use, eg emqx_broker; HiveMQ and EMQX are MQTT brokers designed to facilitate efficient and secure communication between IoT devices and applications.

3. Choose the command to run, eg. Turn_led_on/off

4. Click Run.

We designed this user interface (UI) to be quick and simple to use without requiring the user to input commands on the terminal, making it convenient for both technical and non-technical users.

## Expected results

At this point, the selected broker is initiated which connects to the client device. The command selected in step 3 is executed, which turns the LED on/off.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
