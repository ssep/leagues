defmodule Leagues do
  use Application
  @moduledoc """
  Application behavior for leagues
  """

  @doc """
  Application start callback
  """  
  def start(_type, _args) do
    Leagues.Sup.start_link()
  end

end
