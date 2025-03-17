defmodule Crawler.Worker do
  alias Crawler.Parser

  def crawl_url(url, domain) do
    http_client = Application.get_env(:crawler, :http_client, HTTPoison)

    if already_crawled?(url) do
      :ok
    else
      mark_as_crawled(url)
      IO.puts(url)

      Task.Supervisor.async_nolink(CrawlerSupervisor, fn ->
        case http_client.get(url) do
          {:ok, %HTTPoison.Response{body: body}} ->
            links = Parser.extract_links(body, url, domain)

            Enum.each(links, fn link ->
              Task.Supervisor.async_nolink(CrawlerSupervisor, fn ->
                crawl_url(link, domain)
              end)
            end)

          {:error, reason} ->
            IO.puts("Error fetching #{url}: #{inspect(reason)}")
        end
      end)
    end
  end

  # Check if URL was already crawled using :visited_links
  defp already_crawled?(url) do
    Agent.get(:visited_links, &MapSet.member?(&1, url))
  end

  # Update visited links and cache in real-time
  defp mark_as_crawled(url) do
    Agent.update(:visited_links, &MapSet.put(&1, url))

    domain = URI.parse(url).host
    Agent.update(:crawl_cache, fn cache ->
      Map.update(cache, domain, MapSet.new([url]), fn existing ->
        MapSet.put(existing, url)
      end)
    end)
  end
end
