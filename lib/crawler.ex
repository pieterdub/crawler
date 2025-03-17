defmodule Crawler do
  def start do
    IO.puts("Enter the URL to crawl:")
    url = IO.gets("> ") |> String.trim()

    {:ok, _pid} = Crawler.Manager.start_link()
    Crawler.Manager.crawl(url)
  end
end
