defmodule Leagues.Storage do
  use GenServer
  require Logger

  @moduledoc"""
  This module provides the entry point to do get information
  for leagues

  NOTE: Only a read interfaces are exposed
  """

  @storage_tbl :leagues_db

  @doc"""
  Starts the storage.
  """
  def start_link(_) do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc"""
  Get available leagues
  """
  @spec get_leagues() :: list(String)
  def get_leagues() do
    GenServer.call(__MODULE__, :get_leagues)
  end

  @doc"""
  Get available seasons for league
  """
  @spec get_seasons(String) :: list(String)
  def get_seasons(league) do
    GenServer.call(__MODULE__, {:get_seasons, league})
  end

  @doc"""
  Get available scores for league and season
  """
  @spec get_scores(String, String) :: list(map())
  def get_scores(league, season) do
    Leagues.Storage.Ets.get_scores(@storage_tbl, league, season)
  end

  ##
  ## Gen Server Callbacks
  ##
  def init(:ok) do
    Leagues.Storage.Ets.new(@storage_tbl)
    file = get_csv_file_path()
    GenServer.cast(self(), {:load_csv, file})

    ## Init leagues in state
    state = %{"leagues" => %{}}
    {:ok, state}
  end

  def handle_call(:get_leagues, _from, %{"leagues" => leagues} = state) do
    league_list = Map.keys(leagues)
    {:reply, {:ok, league_list}, state}
  end

  def handle_call({:get_seasons, league}, _from, %{"leagues" => leagues} = state) do
    reply =
      case Map.get(leagues, league) do
        nil -> {:error, :not_found};
        seasons -> {:ok, MapSet.to_list(seasons)}
      end
    {:reply, reply, state}
  end

  def handle_call(msg, from, state) do
    Logger.warn("Received unsupported call with msg #{msg} from #{from}")
    {:reply, :ok, state}
  end

  def handle_cast({:load_csv, file}, %{"leagues" => leagues} = state) do
    new_leagues = parse_csv(file, leagues)
    {:noreply, Map.put(state, "leagues", new_leagues)}
  end

  def handle_cast(msg, state) do
    Logger.warn("Received unsupported cast with msg #{msg}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.warn("Received unsupported info with msg #{msg}")
    {:noreply, state}
  end

  ##
  ## Internal functions
  ##
  defp parse_csv(file, leagues) do
    Logger.info("Parsing CSV file '#{file}'")

    updated_leagues =
      File.stream!(file)
      ## Parse data
      |> CSV.decode!(headers: true)
      ## Create scores
      |> Stream.map(&Leagues.Score.new/1)
      ## Store scores
      |> Stream.each(&store_score/1)
      ## Update map for leagues and seasons
      |> Enum.reduce(leagues, &parse_league/2)

    Logger.info("Completed parsing CSV file '#{file}'")

    updated_leagues
  end

  defp store_score({:error, _reason}), do: :ok

  defp store_score({:ok, score}) do
    :true = Leagues.Storage.Ets.store(@storage_tbl, score)
  end

  defp get_csv_file_path() do
    file = Leagues.get_env(:scores_filename_csv)
    priv_dir = Leagues.priv_dir()
    Path.join(priv_dir, file)
  end

  defp parse_league({:error, _reason}, leagues), do: leagues

  defp parse_league({:ok, scope}, leagues) do
    %{"league" => league, "season" => season} = scope
    case leagues do
      %{^league => seasons} ->
        Map.put(leagues, league, MapSet.put(seasons, season));
      _ ->
        Map.put(leagues, league, MapSet.new([season]))
    end
  end
end
