defmodule Crawler.Utils do

  def valid_uri?(uri) do
    case URI.parse(uri) do
      %URI{scheme: nil} -> false  # Invalid if no scheme
      %URI{host: nil} -> false    # Invalid if no host
      _ -> true
    end
  end

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

    normalized
    |> String.trim_trailing("/")  # Remove trailing slashes
    |> String.trim_trailing("#")  # Remove trailing hash
  end

  def valid_domain?(url, domain) do
    uri = URI.parse(url)
    uri.host == domain
  end
end
