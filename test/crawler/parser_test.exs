defmodule Crawler.ParserTest do
  use ExUnit.Case
  alias Crawler.Parser

  test "extracts only domain-specific links" do
    body = """
    <a href='https://example.com/page1'></a>
    <a href='https://example.com/page2'></a>
    <a href='https://external.com/page'></a>
    """

    base_url = "https://example.com"
    domain = "example.com"

    links = Parser.extract_links(body, base_url, domain)

    assert links == [
      "https://example.com/page1",
      "https://example.com/page2"
    ]
  end
end
