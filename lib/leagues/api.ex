defmodule Leagues.Api do
  require Logger

  @moduledoc """
  API module to get data from the storage and
  pre-format it
  """

  @doc """
  Get all avaialable leagues in the storage
  """
  @spec get_leagues() :: {:ok, map()}
  def get_leagues() do
    case Leagues.Storage.get_leagues() do
      {:ok, league_list} ->
        leagues = %{"leagues" => league_list};
        {:ok, leagues};
      {:error, reason} ->
        Logger.error("Failed to get leagues with error '#{reason}'")
        {:error, reason}
    end
  end

  @doc """
  Get all avaialable seasons for league
  """
  @spec get_seasons(String.t) :: {:ok, map()}
  def get_seasons(league) do
    case Leagues.Storage.get_seasons(league) do
      {:ok, season_list} ->
        seasons = %{"league" => league,
                    "seasons" => season_list}
        {:ok, seasons}
      {:error, reason} ->
        Logger.error("Failed to get seasons for league '#{league}' with error '#{reason}'")
        {:error, reason}
    end
  end

  @doc """
  Get all avaialable scores for league and season
  """
  @spec get_scores(String.t, String.t) :: {:ok, map()}
  def get_scores(league, season) do
    case Leagues.Storage.get_scores(league, season) do
      {:ok, scores} ->
        data = %{"league" => league,
                 "season" => season,
                 "scores" => scores,
                 "count" => length(scores)
                }
        {:ok, data};
      {:error, reason} ->
        Logger.error("Failed to get scores for " <>
          "league '#{league}', season #{season} with error '#{reason}'")
        {:error, reason}
    end
  end

end
