defmodule Leagues.Http.Protobuf do
  use Protobuf, from: Path.join(Leagues.priv_dir(), "proto/leagues.proto")

  def encode(%{"leagues" => _} = entry) do
    leagues = from_map(entry)
    Leagues.Http.Protobuf.Leagues.encode(leagues)
  end

  def encode(%{"seasons" => _} = entry) do
    seasons = from_map(entry)
    Leagues.Http.Protobuf.Seasons.encode(seasons)
  end

  def encode(%{"scores" => _} = entry) do
    scores = from_map(entry)
    Leagues.Http.Protobuf.Scores.encode(scores)
  end
  
  def from_map(%{"leagues" => league_list}) do
    leagues =
      Enum.map(league_list,
        fn(l) ->
          Leagues.Http.Protobuf.Leagues.League.new(league: l)
        end)
    Leagues.Http.Protobuf.Leagues.new(
      version: :V1,
      leagues: leagues
    )
  end

  def from_map(%{"league" => league,
                 "seasons" => season_list}) do
    seasons =
      Enum.map(season_list,
        fn(s) ->
          Leagues.Http.Protobuf.Seasons.Season.new(season: s)
        end)
    Leagues.Http.Protobuf.Seasons.new(
      version: :V1,
      league: league,
      seasons: seasons
    )
  end

  def from_map(%{"league" => league,
                 "season" => season,
                 "scores" => score_list}) do
    scores = scores_from_map(score_list, [])
    Leagues.Http.Protobuf.Scores.new(
      version: :V1,
      league: league,
      season: season,
      scores: scores
    )
  end


  defp scores_from_map([], parsed), do: parsed

  defp scores_from_map([s | scores], parsed) do
    %{
      "home_team" => home_team,
      "away_team" => away_team,
      "date" => date,
      "ftag" => ftag,
      "fthg" => fthg,
      "ftr" => ftr,
      "htag" => htag,
      "hthg" => hthg,
      "htr" => htr
    } = s
    proto_s = Leagues.Http.Protobuf.Scores.Score.new(
      home_team: home_team,
      away_team: away_team,
      date: date,
      ftag: ftag,
      fthg: fthg,
      ftr: String.to_atom(ftr),
      htag: htag,
      hthg: hthg,
      htr: String.to_atom(htr)
    )
    scores_from_map(scores, [proto_s | parsed])
  end
end
