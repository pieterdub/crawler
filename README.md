# 🕷️ Elixir Web Crawler

This is a **concurrent, domain-specific web crawler** built with **Elixir** using `GenServer`, `Task.Supervisor`, and `Agent` for **parallel crawling with caching**. The crawler:
- Extracts and follows **only domain-specific links**.
- Uses **concurrent tasks** for faster crawling.
- **Caches crawled links** to avoid redundant requests.
- Ensures **no duplicate links are visited or printed**.
- Provides a way to **list all previously crawled domains**.

---

## 🚀 **Features**
✅ **Concurrent crawling** using `Task.Supervisor`.  
✅ **Domain-specific crawling** (ignores external links).  
✅ **Real-time caching** of crawled sites and links using `Agent`.  
✅ **Duplicate-free link tracking** using `MapSet`.  
✅ **List all cached sites** after crawling.  
✅ **Handles HTTP errors gracefully**.  

---

## 🛠️ **Installation**
### 1️⃣ **Clone the repository**
```sh
git clone https://github.com/your-username/crawler.git
cd crawler
```

### 2️⃣ **Install dependencies**
Ensure you have Elixir installed. Then, run:
```sh
mix deps.get
```

---

## 🚀 **Usage**
### 1️⃣ **Run the crawler**
```sh
iex -S mix
```
### 2️⃣ **Call Crawler to start crawling**
```
Crawler.crawl("https://example.com")
```

### 3️⃣ **Output**
During crawling, the program **prints unique, domain-specific links**:
```
https://example.com
https://example.com/about
https://example.com/contact
https://example.com/products
```

### 4️⃣ **List All Cached Domains**
To see previously crawled domains, run:
```elixir
Crawler.Manager.list_cached_sites()
```
Example output:
```
["example.com", "sedna.com"]
```

---

## 🗄 **Caching Mechanism**
The crawler **caches previously crawled links** to avoid redundant requests:
- **`Agent` is used to store `:crawl_cache`**, which maps **domains** to their visited links.
- **`:visited_links` tracks links during a crawl session**, preventing duplicates.
- **Before crawling a URL, the worker checks if it's already visited**.
- **On re-crawling, cached links are retrieved instead of making HTTP requests**.

---

## 📂 **Project Structure**
```
crawler/
│── lib/
│   ├── crawler/
│   │   ├── manager.ex    # Manages crawling & caching
│   │   ├── worker.ex     # Handles async crawling & updates cache
│   │   ├── parser.ex     # Extracts links from HTML
│   │   ├── utils.ex      # URL processing utilities
│   ├── crawler.ex        # Entry point (prompts for URL)
│── test/
│   ├── crawler/
│   │   ├── parser_test.exs   # Tests for Parser
│   │   ├── utils_test.exs    # Tests for Utils
│   │   ├── worker_test.exs   # Tests Worker behavior with caching
│   ├── crawler_manager_test.exs # Tests for caching & domain tracking
│── mix.exs                   # Project config
│── README.md                 # Documentation
```

---

## 🧪 **Testing**
Run the test suite using:
```sh
mix test
```
This ensures that:
- The **parser** extracts only domain-specific links.
- The **utils** correctly normalize and filter URLs.
- The **worker** processes links while updating the cache correctly.
- The **manager** properly stores and retrieves cached domains.

---

## 🔧 **Customization**

- **Enable more detailed logging**  
  Uncomment or add `IO.puts()` statements in **`worker.ex`** to see more verbose output.

---

## 🎯 **To-Do / Future Enhancements**
- ✅ Implement a **CLI flag to clear the cache**.  
- ✅ Improve **error handling for non-responsive sites**.  

---

## 📜 **License**
This project is licensed under the **MIT License**.

---

## ✨ **Contributing**
Pull requests are welcome! Feel free to open an issue for bug fixes or feature suggestions. 🚀

---