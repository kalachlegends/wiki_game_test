defmodule WikiGameTestWeb.FormTest do
  use WikiGameTestWeb.ConnCase

  import Phoenix.LiveViewTest
  @endpoint WikiGameTestWeb.Endpoint

  test "check validate form", %{conn: conn} do
    conn = get(conn, "/")

    {:ok, view, _html} = live(conn)

    assert view
           |> element("form")
           |> render_change(%{wiki_path: "https://github.com/remix-run/react-router/issues/8254"}) =~
             "This link isn&#39;t valid"
  end

  test "check get link", %{conn: conn} do
    WikiGameTest.GitlerTest.preparation()
    conn = get(conn, "/")

    {:ok, view, _html} = live(conn)

    assert view
           |> element("form")
           |> render_submit(%{
             "wiki_path" => "/wiki/Dog"
           }) =~ "/wiki/Adolf"
  end
end
