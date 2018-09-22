defmodule Leagues.Storage.Ets do
  require Logger
  
  @moduledoc"""
  Module providing ETS based storage
  """

  @doc"""
  Initialize ETS table

  NOTE: The table is set to be a 'bag' so that keys can be duplicated
        so that league and season can be used as key
  """
  def new(table) do
    :ets.new(table, [:named_table, :bag, :protected, read_concurrency: true])
  end

  @doc"""
  Stores score in the provided table
  """
  def store(table, entry) do
    %{
      "league" => league,
      "season" => season,
      "score" => score
    } = entry
    Logger.debug("Storing score #{inspect score}")
    entry = {{league, season}, score}
    :ets.insert(table, entry)
  end

  @doc"""
  Attempts to find BBox(s) that contains the provided coordinate
  """
  def get_scores(table, league, season) do
    key = {league, season}
    case :ets.lookup(table, key) do
      [] -> {:error, :not_found}
      scores -> {:ok, parse_scores(scores, [])}
    end
  end

  defp parse_scores([], parsed), do: parsed
  defp parse_scores([{_, s} | scores], parsed), do: parse_scores(scores, [s | parsed])
    
end
