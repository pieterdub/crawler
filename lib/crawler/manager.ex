defmodule Crawler.Manager do
  use GenServer
  alias Crawler.Worker
  alias Crawler.Utils

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def crawl(url) do
    IO.puts("Received request to crawl: #{url}")
    GenServer.call(__MODULE__, {:crawl, url}, 30_000)
  end

  def list_cached_sites do
    GenServer.call(__MODULE__, :list_cached_sites)
  end

  def init(_opts) do
    {:ok, _} = Task.Supervisor.start_link(name: CrawlerSupervisor)
    {:ok, _} = Agent.start_link(fn -> %{} end, name: :crawl_cache)
    {:ok, _} = Agent.start_link(fn -> MapSet.new() end, name: :visited_links)
    IO.puts("Crawler.Manager started")
    {:ok, %{visited: MapSet.new()}}
  end

  def handle_call({:crawl, url}, _from, state) do
    case Utils.valid_uri?(url) do
       true -> initiate_worker(url, state)
       _res ->
        IO.puts("\"#{url}\" is not a valid url")
        {:reply, :error, state}
    end
  end

  def handle_call(:list_cached_sites, _from, state) do
    cached_sites = Agent.get(:crawl_cache, &Map.keys(&1)) |> Enum.sort()
    {:reply, cached_sites, state}
  end

  def handle_info({ref, :ok}, state) when is_reference(ref) do
    Process.demonitor(ref, [:flush])  # Remove reference safely
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    {:noreply, state}
  end

  def handle_info({:print_cached_links, cached_links}, state) do
    sorted_links = Enum.sort(cached_links)

    IO.puts("\nCrawled (Cached) #{Enum.count(sorted_links)} unique domain-specific links:")
    Enum.each(sorted_links, &IO.puts(&1))

    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts("Ignoring unknown message: #{inspect(msg)}")
    {:noreply, state}
  end

  def initiate_worker(url, state) do
    domain = Utils.extract_domain(url)

    case Agent.get(:crawl_cache, &Map.get(&1, domain)) do
      nil ->
        IO.puts("Resetting state before new crawl...")
        Agent.update(:visited_links, fn _ -> MapSet.new() end)
        Worker.crawl_url(url, domain)

      cached_links ->
        IO.puts("Cache hit for #{domain}, returning cached links...")
        send(self(), {:print_cached_links, cached_links})
    end

    {:reply, :ok, state}
  end
end
