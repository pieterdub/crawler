defmodule Crawler.UtilsTest do
  use ExUnit.Case
  alias Crawler.Utils

  test "extract_domain/1 extracts domain from URL" do
    assert Utils.extract_domain("https://example.com/page") == "example.com"
  end

  test "normalize_url/2 correctly resolves relative URLs" do
    assert Utils.normalize_url("/about", "https://example.com") == "https://example.com/about"
  end

  test "valid_domain?/2 returns true for same domain" do
    assert Utils.valid_domain?("https://example.com/page", "example.com")
  end

  test "valid_domain?/2 returns false for different domain" do
    refute Utils.valid_domain?("https://external.com/page", "example.com")
  end
end
