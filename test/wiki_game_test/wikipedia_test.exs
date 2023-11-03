defmodule WikiGameTest.WikipediaTest do
  use WikiGameTest.DataCase

  test "TEST WIKIPEDIA GET RESPONSE" do
    assert {:ok, _} = WikiGameTest.Wikipedia.get("wiki/Dog")
    assert {:error, _} = WikiGameTest.Wikipedia.get("wiki/Dasdasdog")
  end
end
