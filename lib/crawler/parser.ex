defmodule Crawler.Parser do
  alias Crawler.Utils

  def extract_links(body, base_url, domain) do
    body
    |> Floki.parse_document!()
    |> Floki.find("a[href]")
    |> Floki.attribute("href")
    |> Enum.map(&Utils.normalize_url(&1, base_url))
    |> Enum.filter(&Utils.valid_domain?(&1, domain))
  end
end
