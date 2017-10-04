defmodule ElixirFeedParser.Test.YoutubeAtomTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.YoutubeAtom

  setup do
    example1_file = File.read!("test/fixtures/atom/YoutubeChannel.xml")
    example1 = with {:ok, xml} <- XmlNode.parse_string(example1_file), do: YoutubeAtom.parse(xml)
    {:ok, [example1: example1]}
  end

  test "can_parse?" do
    sample_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://www.youtube.com/xml/schemas/2015">
      <title>Example Feed</title>
    </feed>
    """
    {:ok, xml} = XmlNode.parse_string(sample_xml)
    assert YoutubeAtom.can_parse?(xml)
  end

  test "parse channel ID", %{example1: feed} do
    assert feed.channel_id == "UCKrD_GYN3iDpG_uMmADPzJQ"
  end
end
