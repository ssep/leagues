defmodule Leagues do
  use Application
  require Logger

  @application :leagues

  @moduledoc """
  Application behavior for leagues
  """

  @doc """
  Application start callback
  """
  def start(_type, _args) do
    Logger.info("Starting leagues application")
    Leagues.Sup.start_link()
  end

  @spec get_env(any()) :: any()
  def get_env(key), do: get_env(key, :undefined)

  @spec get_env(any(), any()) :: any()
  def get_env(key, default) do
    case :application.get_env(@application, key) do
      {:ok, value} -> value;
      _ -> default
    end
  end

  @spec priv_dir() :: String.t
  def priv_dir() do
    :code.priv_dir(@application)
  end

end
