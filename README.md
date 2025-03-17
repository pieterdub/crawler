Here's your **`README.md`** in one code block:  

```md
# 🕷️ Elixir Web Crawler

This is a **concurrent, domain-specific web crawler** built with **Elixir** using `GenServer` and `Task.Supervisor` for parallel crawling. The crawler:
- Extracts and follows **only domain-specific links**.
- Uses **concurrent tasks** for faster crawling.
- Ensures **no duplicate links** are visited.
- Asks the user for a **starting URL** and crawls indefinitely within that domain.
- **Automatically sorts and prints visited links**.

---

## 🚀 **Features**
✅ **Concurrent crawling** with `Task.Supervisor`  
✅ **Domain-specific crawling** (doesn't follow external links)  
✅ **Unique link tracking** using `Agent`  
✅ **Sorted output of visited links**  
✅ **Handles timeouts and errors gracefully**  

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
### 2️⃣ **Enter a URL to start crawling**
```
Enter the URL to crawl:
> https://example.com
```

### 3️⃣ **Output**
After crawling, the program **prints the unique links** (sorted alphabetically):
```
Crawled 5 unique domain-specific links:
https://example.com
https://example.com/about
https://example.com/contact
https://example.com/products
https://example.com/blog
```

---

## 📂 **Project Structure**
```
crawler/
│── lib/
│   ├── crawler/
│   │   ├── manager.ex    # Main GenServer (controls crawling)
│   │   ├── worker.ex     # Handles async crawling tasks
│   │   ├── parser.ex     # Extracts links from HTML
│   │   ├── utils.ex      # URL