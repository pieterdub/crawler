defmodule Crawler do
  def crawl(url) do
    # Ensure the Crawler Manager is started
    if GenServer.whereis(Crawler.Manager) == nil do
      {:ok, _pid} = Crawler.Manager.start_link()
    end

    # Start the crawl
    IO.puts("Starting crawl for: #{url}")
    Crawler.Manager.crawl(url)
  end

  def get_crawled do
    case GenServer.whereis(Crawler.Manager) do
      nil ->
        IO.puts("Crawler manager has not started")
        :ok
      _valid ->
        Crawler.Manager.list_cached_sites()
    end
  end
end
