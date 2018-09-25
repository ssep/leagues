defmodule Leagues.Http.Leagues.V1 do
  use Leagues.Http.Server
  require Logger

  
  @moduledoc """
  HTTP module for leagues V1

  Three paths are implemented

  - GET v1/leagues
  - GET v1/leagues/:league/seasons
  - GET v1/leagues/:league/seasons/:season/scores

  Results are returned as a JSON if found
  """
  namespace :leagues do
    version "v1" do

      desc "Get all available leagues"
      get do
        Logger.info("Get request for all available leagues")
        Leagues.Metrics.count("request.leagues.count")
        reply = Leagues.Api.get_leagues()
        Leagues.Http.response(conn, reply)
      end

      route_param :league, type: String, regexp: ~r/^[a-z0-9A-Z]+$/ do

        namespace :seasons do

          route_param :season, type: String, regexp: ~r/^[0-9]{6}$/  do

            desc "Get all available scores for league and season"
            get :scores do
              league = params[:league]
              season = params[:season]
              Leagues.Metrics.count("request.scores.count", [league: league, season: season])
              Logger.info("Get scores for league '#{league}' and season '#{season}'")
              reply = Leagues.Api.get_scores(league, season)
              Leagues.Http.response(conn, reply)
            end
          end

          desc "Get all available seasons for league"
          get do
            league = params[:league]
            Leagues.Metrics.count("request.seasons.count", [league: league])
            Logger.info("Get seasons for league '#{league}'")
            reply = Leagues.Api.get_seasons(league)
            Leagues.Http.response(conn, reply)
          end
          
        end # namespace :seasons end
      end # route_param :league end
    end # version "V1" end
  end # namespace :leagues end
  
end
