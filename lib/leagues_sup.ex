defmodule Leagues.Sup do
  use Supervisor

  @moduledoc """
  Main supervisor for Leagues application
  """

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      Leagues.Storage,
      Leagues.Http.Server,
      Leagues.Metrics
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
