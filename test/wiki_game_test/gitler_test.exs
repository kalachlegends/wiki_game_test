defmodule WikiGameTest.GitlerTest do
  use WikiGameTest.DataCase

  test "SEARCH TEST CASE ADOLF_GITLER WIKI" do
    preparation()

    {:ok, path_adolf} =
      WikiGameTest.Gitler.search_gitler(WikiGameTest.Config.Main.get_adolf_gilter_link())

    assert path_adolf |> hd() == WikiGameTest.Config.Main.get_adolf_gilter_link()
  end

  test "SEARCH TEST CASE wiki/Kazahstan find gitler" do
    preparation()
    {:ok, path_adolf} = WikiGameTest.Gitler.search_gitler("/wiki/Kazakhstan")
    assert path_adolf |> hd() == WikiGameTest.Config.Main.get_adolf_gilter_link()
  end

  test "SEARCH TEST CASE wiki/Dog find gitler" do
    preparation()
    {:ok, path_adolf} = WikiGameTest.Gitler.search_gitler("/wiki/Dog")

    assert path_adolf |> hd() == WikiGameTest.Config.Main.get_adolf_gilter_link()
  end

  def preparation() do
    Enum.each(
      [
        "/wiki/Equatorial_Guinea",
        "/wiki/Lithuania",
        "/wiki/Bosnia_and_Herzegovina",
        "/wiki/Croatia",
        "/wiki/Slovakia",
        "/wiki/Austria",
        "/wiki/Guatemala",
        "/wiki/Romania",
        "/wiki/Poland",
        "/wiki/Spain",
        "/wiki/Tenzing_Norgay",
        "/wiki/Diana,_Princess_of_Wales",
        "/wiki/James_Watson",
        "/wiki/Bruce_Lee",
        "/wiki/Che_Guevara",
        "/wiki/Muhammad_Ali",
        "/wiki/Alan_Turing",
        "/wiki/Goebbels_children",
        "/wiki/Johann_Rattenhuber",
        "/wiki/Willy_Johannmeyer",
        "/wiki/Bernd_Freytag_von_Loringhoven",
        "/wiki/G%C3%BCnther_Korten",
        "/wiki/Karl_Bodenschatz",
        "/wiki/Helen_Keller",
        "/wiki/Anne_Frank",
        "/wiki/Ludwig_Wittgenstein",
        "/wiki/Margaret_Thatcher",
        "/wiki/Mao_Zedong",
        "/wiki/Franz_Sch%C3%A4dle",
        "/wiki/Walther_Hewel",
        "/wiki/Wilhelm_Zander",
        "/wiki/Herbert_B%C3%BCchs",
        "/wiki/List_of_people_killed_or_wounded_in_the_20_July_plot",
        "/wiki/Willi_Stoph",
        "/wiki/Joachim_Gauck",
        "/wiki/Richard_von_Weizs%C3%A4cker",
        "/wiki/Theodor_Heuss",
        "/wiki/Konstantin_Hierl",
        "/wiki/Edmund_Hillary",
        "/wiki/G.I.",
        "/wiki/Francis_Crick",
        "/wiki/Theodore_Roosevelt",
        "/wiki/Alwin-Broder_Albrecht",
        "/wiki/Georg_Betz",
        "/wiki/Peter_H%C3%B6gl",
        "/wiki/Walter_Wagner_(notary)"
      ],
      fn x ->
        WikiGameTest.Ets.Cache.push_lvl_to_gitler(0, x)
      end
    )

    Enum.each(
      [
        "/wiki/Luxembourg",
        "/wiki/Macau",
        "/wiki/Trinidad_and_Tobago",
        "/wiki/Libya",
        "/wiki/United_Arab_Emirates",
        "/wiki/Honduras",
        "/wiki/Burkina_Faso",
        "/wiki/Angola",
        "/wiki/Uzbekistan",
        "/wiki/Uganda",
        "/wiki/South_Korea",
        "/wiki/Kenya",
        "/wiki/Saint_Pierre_and_Miquelon",
        "/wiki/United_States_Virgin_Islands",
        "/wiki/Jersey",
        "/wiki/Guam",
        "/wiki/Latvia",
        "/wiki/Slovenia",
        "/wiki/Singapore",
        "/wiki/Togo",
        "/wiki/Ecuador",
        "/wiki/Ivory_Coast",
        "/wiki/Morocco",
        "/wiki/Algeria",
        "/wiki/France",
        "/wiki/Wallis_and_Futuna",
        "/wiki/Faroe_Islands",
        "/wiki/Guernsey",
        "/wiki/Denmark",
        "/wiki/Hong_Kong",
        "/wiki/Tajikistan",
        "/wiki/Belgium",
        "/wiki/Papua_New_Guinea",
        "/wiki/Chad",
        "/wiki/Senegal",
        "/wiki/North_Korea",
        "/wiki/Mexico",
        "/wiki/Russia",
        "/wiki/Christmas_Island"
      ],
      fn x -> WikiGameTest.Ets.Cache.push_lvl_to_gitler(1, x) end
    )
  end
end
