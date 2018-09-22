defmodule Leagues.Http do
  use Leagues.Http.Server
  require Logger

  @moduledoc """
  Entry point for HTTP requests for the leagues application
  """

  plug Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Jason,
    parsers: [:json]

  defimpl Jason.Encoder, for: [MapSet, Range, Stream] do
    def encode(struct, opts) do
      Jason.Encode.list(Enum.to_list(struct), opts)
    end
  end

  @doc """
  Not implemented paths
  """
  rescue_from Maru.Exceptions.NotFound, as: e do
    Logger.debug "400: Invalid URL at path /#{e.path_info}"
    conn
    |> put_status(400)
    |> json(%{message: "Not implemented"})
  end

  rescue_from :all, as: e do
    IO.inspect e
    conn
    |> put_status(500)
    |> json(%{message: "Server Error"})
  end

  mount Leagues.Http.Leagues.V1

  def response(conn, {:ok, data}) do
    conn
    |> put_status(200)
    |> json(data)
  end

  def response(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> json(%{message: "Data not found"})
  end
  
end
