defmodule Leagues.Http do
  use Leagues.Http.Server
  require Logger

  ## There is not protobuf standand header
  ## This is the one accepted as such here
  @protobuf_headers ["application/x-protobuf",
                     "application/vnd.google.protobuf",
                     "application/octet-stream"]

  @accept_hdr "accept"
  @content_type_hdr "content-type"

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
    Leagues.Metrics.count("request.count", [status: 400])
    conn
    |> put_status(400)
    |> json(%{error: "Not implemented"})
  end

  rescue_from :all, as: e do
    Leagues.Metrics.count("request.count", [status: 500])
    IO.inspect e
    conn
    |> put_status(500)
    |> json(%{error: "Server Error"})
  end

  mount Leagues.Http.Leagues.V1

  ##
  ## Utility functions to build replies
  ##
  def response(conn, reply) do
    type = get_data_type(conn)
    response(conn, reply, type)
  end


  def response(conn, {:ok, data}, :protobuf) do
    Logger.debug("Processing protobuf with data #{inspect data}")
    Leagues.Metrics.count("request.count", [status: 200, type: "protobuf"])
    conn
    |> put_resp_header(@content_type_hdr, accept_header(conn))
    |> send_resp(200, Leagues.Http.Protobuf.encode(data))
    |> halt()
  end

  def response(conn, {:error, :not_found}, :protobuf) do
    Leagues.Metrics.count("request.count", [status: 404, type: "protobuf"])
    conn
    |> put_resp_header(@content_type_hdr, accept_header(conn))
    |> send_resp(404, "")
    |> halt()
  end

  def response(conn, {:ok, data}, :json) do
    Leagues.Metrics.count("request.count", [status: 200, type: "json"])
    conn
    |> put_status(200)
    |> json(data)
  end

  def response(conn, {:error, :not_found}, :json) do
    Leagues.Metrics.count("request.count", [status: 404, type: "json"])
    conn
    |> put_status(404)
    |> json(%{error: "Not Found"})
  end

  def response(conn, data, type) do
    Leagues.Metrics.count("request.count", [status: 503,type: "#{type}"])
    Logger.error("Failed to process reply with data #{inspect data} and type #{type}")
    conn
    |> put_status(503)
    |> json(%{error: "Internal Server Error"})
  end

  ##
  ## Internal functions
  ##
  defp accept_header(conn) do
    conn |> get_req_header(@accept_hdr) |> List.first
  end

  defp get_data_type(conn) do
    accept_hdr = accept_header(conn)
    case Enum.member?(@protobuf_headers, accept_hdr) do
      :true  -> :protobuf
      :false -> :json
    end
  end

end
