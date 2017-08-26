defmodule WebScript.HTTP do
  use Plug.Router

  plug Plug.Static, at: "static", from: "../frontend/static"
  plug :match
  plug :dispatch

  get "/", do: send_file(conn, 200, "../frontend/index.html")

  post "/call-script" do
    case WebScript.Pool.call_script(:pool, "sh", ["../script.sh"], 12_000) do
      {:ok, {stdout, _status}} ->
        resp(conn, 200, stdout)
      {:error, :full} ->
        resp(conn, 503, "server overloaded!")
    end
  end

  match _, do: send_resp(conn, 404, "oops")
end
