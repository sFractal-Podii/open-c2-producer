defmodule OpenC2ProducerWeb.PageController do
  use OpenC2ProducerWeb, :controller
  import Phoenix.LiveView.Controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    github_auth_url = Routes.auth_path(OpenC2ProducerWeb.Endpoint, :request, "github")
    render(conn, :home, layout: false, github_auth_url: github_auth_url)
  end

  def sbom(conn, _params) do
    live_render(conn, OpenC2ProducerWeb.SbomLive)
  end
  
end
