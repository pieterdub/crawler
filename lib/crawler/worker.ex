defmodule Crawler.Worker do
  alias Crawler.Parser

  def crawl_url(url, domain) do
    if Agent.get(:visited_links, &MapSet.member?(&1, url)) do
      :ok
    else
      Agent.update(:visited_links, &MapSet.put(&1, url))
      IO.puts("Crawling: #{url}")

      Task.Supervisor.async_nolink(CrawlerSupervisor, fn ->
        case HTTPoison.get(url) do
          {:ok, %HTTPoison.Response{body: body}} ->
            links = Parser.extract_links(body, url, domain)

            links
            |> Enum.chunk_every(5)
            |> Enum.each(fn batch ->
              tasks = Enum.map(batch, fn link ->
                Task.Supervisor.async_nolink(CrawlerSupervisor, fn ->
                  crawl_url(link, domain)
                end)
              end)

              Enum.each(tasks, &Task.await(&1, 10_000))
            end)

          {:error, reason} ->
            IO.puts("Error fetching #{url}: #{inspect(reason)}")
        end
      end)
    end
  end
end
