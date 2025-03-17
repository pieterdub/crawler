defmodule Crawler.WorkerTest do
  use ExUnit.Case, async: true
  import Mox
  alias Crawler.Worker

  setup do
    # Start the Task Supervisor
    {:ok, _} = Task.Supervisor.start_link(name: CrawlerSupervisor)

    # Start the Agent that tracks visited links
    {:ok, _} = Agent.start_link(fn -> MapSet.new() end, name: :visited_links)
    {:ok, _} = Agent.start_link(fn -> MapSet.new() end, name: :crawl_cache)

    Application.put_env(:crawler, :http_client, Crawler.MockHTTP)

    # Ensure mocks are verified after each test
    verify_on_exit!()

    :ok
  end

  test "worker crawls valid links" do
    # Expect HTTP requests to be mocked
    Crawler.MockHTTP
    |> expect(:get, fn "https://example.com" ->
      {:ok, %HTTPoison.Response{body: "<a href='/about'></a>", status_code: 200}}
    end)
    |> expect(:get, fn "https://example.com/about" ->
      {:ok, %HTTPoison.Response{body: "", status_code: 200}}
    end)

    # Call the worker
    Worker.crawl_url("https://example.com", "example.com")

    # Wait briefly to allow async crawling to complete
    Process.sleep(100)

    # Get visited links from the Agent
    visited_links = Agent.get(:visited_links, & &1)

    assert "https://example.com" in visited_links
    assert "https://example.com/about" in visited_links
  end
end
