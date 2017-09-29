defmodule ElixirFeedParser.Test.YoutubeAtomEntryTest do
  use ExUnit.Case

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.YoutubeAtom

  setup do
    example1_file = File.read!("test/fixtures/atom/YoutubeChannel.xml")
    example1 = with {:ok, xml} <- XmlNode.parse_string(example1_file), do: YoutubeAtom.parse(xml)
    {:ok, [example1: List.first(example1.entries)]}
  end

  test "parse authors", %{example1: entry} do
    assert entry.authors == ["Erlang Solutions"]
  end

  test "parse title", %{example1: entry} do
    assert entry.title == "RefactorErl by Melinda Tóth/ELTE-Soft Nonprofit Ltd"
  end

  test "parse video ID", %{example1: entry} do
    assert entry.video_id == "nUa_aF7dyWk"
  end

  test "parse channel ID", %{example1: entry} do
    assert entry.channel_id == "UCKrD_GYN3iDpG_uMmADPzJQ"
  end

  test "parse media video title", %{example1: entry} do
    assert entry.media.title == "RefactorErl by Melinda Tóth/ELTE-Soft Nonprofit Ltd"
  end

  test "parse media content URL", %{example1: entry} do
    assert entry.media.content_url == "https://www.youtube.com/v/nUa_aF7dyWk?version=3"
  end

  test "parse media description", %{example1: entry} do
    assert entry.media.description == "Erlang meet-up, 19 September 2017, Klarna, Stockholm"
  end

  test "parse media thumbnail url", %{example1: entry} do
    assert entry.media.thumbnail_url == "https://i3.ytimg.com/vi/nUa_aF7dyWk/hqdefault.jpg"
  end

  test "parse media community rating", %{example1: entry} do
    assert entry.media.community.rating == 5.00
  end

  test "parse media community views", %{example1: entry} do
    assert entry.media.community.views == 120
  end
end
