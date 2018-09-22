defmodule Leagues.Api do
  require Logger

  @moduledoc """
  API module to get data from the storage and
  pre-format it
  """

  @doc """
  Get all avaialable leagues in the storage
  """
  @spec get_leagues() :: {:ok, map}
  def get_leagues() do
    leagues = %{"leagues" => ["sp1", "d1", "o0"]}
    {:ok, leagues}
  end

  @doc """
  Get all avaialable seasons for league
  """
  @spec get_seasons(String.t) :: {:ok, map}
  def get_seasons(league) do
    seasons = %{
      "league" => league,
      "seasons" => ["201516", "201617"]
    }
    {:ok, seasons}
  end

  @doc """
  Get all avaialable scores for league and season
  """
  @spec get_scores(String.t, String.t) :: {:ok, map}
  def get_scores(league, season) do
    scores = [
      %{"date" => "19/08/16",
        "home_team" => "La Coruna",
        "away_team" => "Eibar",
        "fthg" => 2,
        "ftag" => 1,
        "ftr" => "H",
        "hthg" => 0,
        "htag" => 0,
        "htr" => "D"
       }
    ]
    reply = %{"league" => league,
              "season" => season,
              "scores" => scores,
              "count" => length(scores)
             }
    {:ok, reply}
  end

end
