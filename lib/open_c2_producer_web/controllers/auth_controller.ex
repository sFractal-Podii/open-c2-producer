defmodule OpenC2ProducerWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """
  use OpenC2ProducerWeb, :controller

  plug Ueberauth

  alias OpenC2Producer.UserFromAuth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    find_or_create_user(conn, auth)
  end

  defp find_or_create_user(conn, auth) do
    case UserFromAuth.find_or_create_user(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/run_script")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/")
    end
  end
end
