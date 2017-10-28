defmodule ElixirFeedParser.Test.RSS2Test do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.RSS2

  setup do
    my_dad_wrote_a_porno_file = File.read!("test/fixtures/rss2/MyDadWroteAPorno.xml")
    my_dad_wrote_a_porno = with {:ok, xml} <- XmlNode.parse_string(my_dad_wrote_a_porno_file), do: RSS2.parse(xml)
    {:ok, [my_dad_wrote_a_porno: my_dad_wrote_a_porno]}
  end

  test "parse updated", %{my_dad_wrote_a_porno: feed} do
    assert feed.updated == %DateTime{day: 4, hour: 3, minute: 0, month: 9, second: 0, year: 2017, time_zone: "Etc/UTC", zone_abbr: "UTC", utc_offset: 0, std_offset: 0}
  end
end
