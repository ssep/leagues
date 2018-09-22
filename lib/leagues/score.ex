defmodule Leagues.Score do

  @spec new(map) :: {:ok, map} | {:error, any}
  def new(%{"" => _index,
           "AwayTeam" => away_team,
           "Date" => date,
           "Div" => league,
           "FTAG" => ftag,
           "FTHG" => fthg,
           "FTR" => ftr,
           "HTAG" => htag,
           "HTHG" => hthg,
           "HTR" => htr,
           "HomeTeam" => home_team,
           "Season" => season
          }) do
    parsed = %{"league" => String.downcase(league),
               "season" => season,
               "score" => %{
                 "away_team" => away_team,
                 "date" => date,
                 "ftag" => String.to_integer(ftag),
                 "fthg" => String.to_integer(fthg),
                 "ftr" => ftr,
                 "htag" => String.to_integer(htag),
                 "hthg" => String.to_integer(hthg),
                 "htr" => htr,
                 "home_team" => home_team
               }
              }
    {:ok, parsed}
  end

  def new(_), do: {:error, :invalid_score}

end
