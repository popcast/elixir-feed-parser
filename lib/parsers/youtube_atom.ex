defmodule ElixirFeedParser.Parsers.YoutubeAtom do
  import ElixirFeedParser.Parsers.Helper

  alias ElixirFeedParser.XmlNode
  alias ElixirFeedParser.Parsers.Atom

  def can_parse?(xml) do
    Atom.can_parse?(xml) && youtube_namespace?(xml)
  end

  def parse(xml) do
    feed = XmlNode.find(xml, "/feed")

    xml |> Atom.parse |> Map.merge(%{
      channel_id: feed |> element("yt:channelId"),

      entries:    parse_entries(feed)
    })
  end

  def parse_entry(feed, entry) do
    feed |> Atom.parse_entry(entry) |> Map.merge(%{
      channel_id: entry |> element("yt:channelId"),
      video_id:   entry |> element("yt:videoId"),

      media:      parse_youtube_media(entry)
    })
  end

  defp parse_entries(feed) do
    XmlNode.map_children(feed, "entry", fn(e) -> parse_entry(feed, e) end)
  end

  defp parse_youtube_media(entry) do
    media = XmlNode.find(entry, "media:group")
    community = XmlNode.find(media, "media:community")

    %{
      title:         media |> element("media:title"),
      content_url:   media |> element("media:content", [attr: "url"]),
      description:   media |> element("media:description"),
      thumbnail_url: media |> element("media:thumbnail", [attr: "url"]),
      community: %{
        rating: community |> element("media:starRating", [attr: "average"]) |> String.to_float(),
        views:  community |> element("media:statistics", [attr: "views"]) |> String.to_integer
      }
    }
  end

  defp youtube_namespace?(xml) do
    namespaces = xml |> XmlNode.find("/feed") |> XmlNode.namespaces
    namespaces["yt"] == "http://www.youtube.com/xml/schemas/2015"
  end

end
