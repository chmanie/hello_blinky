defmodule HelloBlinky.Application do
  # use Application

  @moduledoc """
  
  Simple example to blink a list of LEDs forever.

  The list of LEDs is platform-dependent, and defined in the config directory
  (see config.exs). See README.md for build instructions.
  """

  @on_duration  200 # ms
  @off_duration 200 # ms

  alias Nerves.Leds
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    #children = [
      # worker(HelloBlinky.Worker, [arg1, arg2, arg3]),
    # ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    # opts = [strategy: :one_for_one, name: HelloBlinky.Supervisor]
    # Supervisor.start_link(children, opts)

    
    led_list = Application.get_env(:hello_blinky, :led_list)
    Logger.debug "list of leds to blink is #{inspect led_list}"
    spawn fn -> blink_list_forever(led_list) end
    {:ok, self()}
  end

  # call blink_led on each led in the list sequence, repeating forever
  defp blink_list_forever(led_list) do
    Enum.each(led_list, &blink(&1))
    blink_list_forever(led_list)
  end

  # given an led key, turn it on for @on_duration then back off
  defp blink(led_key) do
    #Logger.debug "blinking led #{inspect led_key}"
    Leds.set [{led_key, true}]
    :timer.sleep @on_duration
    Leds.set [{led_key, false}]
    :timer.sleep @off_duration
  end

end
