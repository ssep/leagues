defmodule Leagues.Metrics do
  use Fluxter
  require Logger

  ## Implet VM stats sink to send VM data
  @behaviour :vmstats_sink

  @prefix "leagues."

  def collect(_type, name, value) do
    write(name, value: value)
  end
  
  def count(metric) do
    count(metric, [])
  end

  def count(metric, tags) do
    write("#{@prefix}#{metric}", tags, 1)
  end
end
