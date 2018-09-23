require Logger

defmodule LeaguesHttpProtobufTest do
  use ExUnit.Case

  test "Leagues encondig / decoding" do
    leagues = %{"leagues" => ["sp1", "sp2"]}
    proto_leagues = Leagues.Http.Protobuf.from_map(leagues)
    encoded_leagues = Leagues.Http.Protobuf.Leagues.encode(proto_leagues)

    assert encoded_leagues == Leagues.Http.Protobuf.encode(leagues)
  end

  test "Seasons encondig / decoding" do
    seasons = %{"league" => "sp1",
                "seasons" => ["201516"]}
    proto_seasons = Leagues.Http.Protobuf.from_map(seasons)
    encoded_seasons = Leagues.Http.Protobuf.Seasons.encode(proto_seasons)

    assert encoded_seasons == Leagues.Http.Protobuf.encode(seasons)
  end

  test "Scores encondig / decoding" do
    scores = %{"league" => "sp1",
               "season" => "201617",
               "scores" => [
                 %{"away_team" => "Barcelona",
                   "date" => "12/03/17",
                   "ftag" => 1,
                   "fthg" => 2,
                   "ftr" => "H",
                   "home_team" => "La Coruna",
                   "htag" => 0,
                   "hthg" => 1,
                   "htr" => "H"
                  }
               ]
              }
    proto_scores = Leagues.Http.Protobuf.from_map(scores)
    encoded_scores = Leagues.Http.Protobuf.Scores.encode(proto_scores)

    assert encoded_scores == Leagues.Http.Protobuf.encode(scores)
  end
end
