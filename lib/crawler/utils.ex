defmodule Crawler.Utils do
  def extract_domain(url) do
    URI.parse(url).host
  end

  def normalize_url(url, base_url) do
    normalized =
      if String.starts_with?(url, "http") do
        url
      else
        URI.merge(base_url, url) |> to_string()
      end

    String.trim_trailing(normalized, "/")  # Remove trailing slashes
  end

  def valid_domain?(url, domain) do
    uri = URI.parse(url)
    uri.host == domain
  end
end
