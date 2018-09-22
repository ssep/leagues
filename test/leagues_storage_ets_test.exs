defmodule LeaguesStorageEtsTest do
  use ExUnit.Case

  test "Ets storage testing ..." do
    table = :table
    score = %{"home_team" => "t2"}
    entry = %{
      "league" => "l1",
      "season" => "s1",
      "score" => score
    }


    assert table = Leagues.Storage.Ets.new(table)
    assert :true = Leagues.Storage.Ets.store(table, entry)

    assert {:ok, scores} = Leagues.Storage.Ets.get_scores(table, "l1", "s1")
    assert [score] == scores

    assert {:error, :not_found} == Leagues.Storage.Ets.get_scores(table, :invalid, :invalid)
  end

end
