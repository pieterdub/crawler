ExUnit.start()

# Define Mox Mock for HTTP Client
Mox.defmock(Crawler.MockHTTP, for: HTTPoison.Base)

# Configure the application to use the mock HTTP client in tests
Application.put_env(:crawler, :http_client, Crawler.MockHTTP)

# Ensure Mox and HTTPoison are started before tests
Application.ensure_all_started(:httpoison)
Application.ensure_all_started(:mox)
