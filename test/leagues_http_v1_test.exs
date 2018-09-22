require Logger

defmodule LeaguesHttpV1Test do
  use ExUnit.Case
  use Maru.Test

  test "/v1/leagues [Json]" do
    {:ok, leagues} = Leagues.Api.get_leagues()

    Logger.debug(inspect(leagues))

    {:ok, expected} = Jason.encode(leagues)
    assert expected == get("/v1/leagues") |> text_response
  end
  
  test "/v1/leagues/sp1/seasons [Json]" do
    {:ok, seasons} = Leagues.Api.get_seasons("sp1")

    Logger.debug(inspect(seasons))

    {:ok, expected} = seasons |> Jason.encode
    assert expected == get("/v1/leagues/sp1/seasons") |> text_response
  end

  test "/v1/leagues/sp1/seasons/201617/scores [Json]" do
    {:ok, scores} = Leagues.Api.get_scores("sp1", "201617")

    Logger.debug(inspect(scores))

    {:ok, expected} = scores |> Jason.encode
    assert expected == get("/v1/leagues/sp1/seasons/201617/scores") |> text_response
  end

end
