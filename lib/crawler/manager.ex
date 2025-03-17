defmodule Crawler.Manager do
  use GenServer
  alias Crawler.Worker
  alias Crawler.Utils

  @max_concurrency 5

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def crawl(url) do
    GenServer.call(__MODULE__, {:crawl, url}, 30_000)
  end

  # GenServer Callbacks
  def init(_opts) do
    {:ok, _} = Task.Supervisor.start_link(name: CrawlerSupervisor)
    {:ok, _} = Agent.start_link(fn -> MapSet.new() end, name: :visited_links)

    {:ok, %{visited: MapSet.new()}}
  end

  def handle_call({:crawl, url}, _from, state) do
    domain = Utils.extract_domain(url)
    Worker.crawl_url(url, domain)

    {:reply, :ok, state}  # Immediately reply since crawling is async
  end

  # Ignore task results (to prevent unknown messages in logs)
  def handle_info({ref, _result}, state) when is_reference(ref) do
    Process.demonitor(ref, [:flush])  # Remove task reference safely
    {:noreply, state}
  end

  # Ignore DOWN messages from async tasks
  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    {:noreply, state}
  end

    # Final step: Sort and print the visited links
  def handle_info(:print_visited_links, state) do
    unique_links = Agent.get(:visited_links, & &1) |> Enum.sort()

    IO.puts("\nCrawled #{Enum.count(unique_links)} unique domain-specific links:")
    Enum.each(unique_links, &IO.puts(&1))

    {:noreply, state}
  end

  # Handle unknown messages gracefully
  def handle_info(msg, state) do
    IO.puts("Ignoring unknown message: #{inspect(msg)}")
    {:noreply, state}
  end
end
