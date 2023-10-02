defmodule StocksWeb.UserSettingsTwoFactorController do
  use StocksWeb, :controller

  alias Stocks.Contexts.Accounts.TwoFactorSetup

  def new(conn, _params) do
    secret = NimbleTOTP.secret()

    uri =
      NimbleTOTP.otpauth_uri("Stocks:#{conn.assigns.current_user.email}", secret,
        issuer: "Stocks"
      )

    conn
    |> put_session(:totp_secret, secret)
    |> render(:new, uri: uri)
  end

  def create(conn, %{"user" => %{"otp" => otp}}) do
    secret = get_session(conn, :totp_secret)

    case TwoFactorSetup.setup(conn.assigns.current_user, secret, otp) do
      {:ok, :success} ->
        conn
        |> delete_session(:totp_secret)
        |> put_flash(:info, "2FA activated successfully.")
        |> redirect(to: ~p"/users/settings")

      {:error, :invalid_otp} ->
        conn
        |> delete_session(:totp_secret)
        |> put_flash(:error, "OTP code is invalid")
        |> redirect(to: ~p"/users/settings/two_factor_auth/new")
    end
  end

  def delete(conn, _params) do
    case TwoFactorSetup.deactivate(conn.assigns.current_user) do
      {:ok, _user} ->
        conn
        |> delete_session(:totp_secret)
        |> put_flash(:info, "2FA activated successfully.")
        |> redirect(to: ~p"/users/settings")
    end
  end
end
