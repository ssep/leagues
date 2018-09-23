require Logger

defmodule LeaguesHttpV1Test do
  use ExUnit.Case
  use Maru.Test

  ## Just any of the supported headers
  @protobuf_hdr "application/x-protobuf"

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

  test "/v1/leagues [Protobuf]" do
    {:ok, leagues} = Leagues.Api.get_leagues()
    Logger.debug(inspect(leagues))

    expected = Leagues.Http.Protobuf.encode(leagues)
    response =
      build_conn()
      |> put_req_header("accept", @protobuf_hdr)
      |> get("/v1/leagues")
      |> text_response
    assert expected == response
  end

  test "/v1/leagues/sp1/seasons [Protobuf]" do
    {:ok, seasons} = Leagues.Api.get_seasons("sp1")
    Logger.debug(inspect(seasons))

    expected = Leagues.Http.Protobuf.encode(seasons)
    response =
      build_conn()
      |> put_req_header("accept", @protobuf_hdr)
      |> get("/v1/leagues/sp1/seasons")
      |> text_response
    assert expected == response
  end

  test "/v1/leagues/sp1/seasons/201617/scores [Protobuf]" do
    {:ok, scores} = Leagues.Api.get_scores("sp1", "201617")
    Logger.debug(inspect(scores))

    expected = Leagues.Http.Protobuf.encode(scores)
    response =
      build_conn()
      |> put_req_header("accept", @protobuf_hdr)
      |> get("/v1/leagues/sp1/seasons/201617/scores")
      |> text_response
    assert expected == response
  end

end
