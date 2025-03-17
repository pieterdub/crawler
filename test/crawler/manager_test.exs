defmodule Crawler.ManagerTest do
  use ExUnit.Case
  alias Crawler.Manager

  setup do
    {:ok, _pid} = Manager.start_link()
    :ok
  end

  test "Manager initializes and starts crawling" do
    assert GenServer.call(Manager, {:crawl, "https://example.com"}) == :ok
  end
end
