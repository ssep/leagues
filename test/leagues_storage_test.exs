defmodule LeaguesStorageTest do
  use ExUnit.Case

  setup context do
    _ = start_supervised(
      %{
        id: Leagues.Storage,
        start: {Leagues.Storage, :start_link, []}
      })
    %{storage: context.test}
  end

  test "Storage testing ...", %{storage: storage} do

    ## There are leagues available
    assert {:ok, leagues} = Leagues.Storage.get_leagues()
    assert length(leagues) > 0

    ## There are seasons available
    [league | _] = leagues
    assert {:ok, seasons} = Leagues.Storage.get_seasons(league)
    assert length(seasons) > 0

    ## There are scores for the league / season found
    [season | _] = seasons
    assert {:ok, scores} = Leagues.Storage.get_scores(league, season)
    assert length(scores) > 0
  end

  test "Storage testing - not found ...", %{storage: storage} do
    assert {:error, :not_found} == Leagues.Storage.get_seasons(:invalid_league)
    assert {:error, :not_found} == Leagues.Storage.get_scores(:invalid_league,:invalid_season)
  end

end
