{ config, lib, pkgs, ... }:
{
  # Glance (https://github.com/glanceapp/glance)
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "0.0.0.0";
        port = 8808;
      };
      pages = [
        {
          name = "Home";
          slug = "home"; # the url at the end: /home
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  autofocus = true;
                }
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Services";
                  sites = [
                    {
                      title = "taki.moe";
                      url = "https://taki.moe/"; # TODO
                    }
                  ];
                }
                {
                  type = "calendar";
                }
                {
                  location = "Gossau, St. Gallen, Switzerland";
                  type = "weather";
                }
              ];
            }
          ];
        }
        {
          name = "Markets";
          slug = "markets";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "markets";
                  title = "Indices";
                  markets = [
                    {
                      symbol = "SPY";
                      name = "S&P 500";
                    }
                    {
                      symbol = "DX-Y.NYB";
                      name = "Dollar Index";
                    }
                  ];
                }
                {
                  type = "markets";
                  title = "Crypto";
                  markets = [
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "ETH-USD";
                      name = "Ethereum";
                    }
                    {
                      symbol = "XMR-USD";
                      name = "Monero";
                    }
                  ];
                }
                {
                  type = "markets";
                  title = "Stocks";
                  sort-by = "absolute-change";
                  markets = [
                    {
                      symbol = "NVDA";
                      name = "NVIDIA";
                    }
                    {
                      symbol = "AAPL";
                      name = "Apple";
                    }
                    {
                      symbol = "MSFT";
                      name = "Microsoft";
                    }
                    {
                      symbol = "GOOGL";
                      name = "Google";
                    }
                    {
                      symbol = "AMD";
                      name = "AMD";
                    }
                    {
                      symbol = "RDDT";
                      name = "Reddit";
                    }
                    {
                      symbol = "AMZN";
                      name = "Amazon";
                    }
                    {
                      symbol = "TSLA";
                      name = "Tesla";
                    }
                    {
                      symbol = "INTC";
                      name = "Intel";
                    }
                    {
                      symbol = "META";
                      name = "Meta";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "rss";
                  title = "News";
                  style = "horizontal-cards";
                  feeds = [
                    {
                      url = "https://feeds.bloomberg.com/markets/news.rss";
                      title = "Bloomberg";
                    }
                    {
                      url = "https://moxie.foxbusiness.com/google-publisher/markets.xml";
                      title = "Fox Business";
                    }
                    {
                      url = "https://moxie.foxbusiness.com/google-publisher/technology.xml";
                      title = "Fox Business";
                    }
                  ];
                }
                {
                  type = "group";
                  widgets = [
                    {
                      type = "reddit";
                      show-thumbnails = true;
                      subreddit = "technology";
                    }
                    {
                      type = "reddit";
                      show-thumbnails = true;
                      subreddit = "wallstreetbets";
                    }
                  ];
                }
                {
                  type = "videos";
                  style = "grid-cards";
                  collapse-after-rows = 3;
                  channels = [
                    "UCvSXMi2LebwJEM1s4bz5IBA"
                    "UCV6KDgJskWaEckne5aPA0aQ"
                    "UCAzhpt9DmG6PnHXjmJTvRGQ"
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "rss";
                  title = "News";
                  limit = 30;
                  collapse-after = 13;
                  feeds = [
                    {
                      url = "https://www.ft.com/technology?format=rss";
                      title = "Financial Times";
                    }
                    {
                      url = "https://feeds.a.dj.com/rss/RSSMarketsMain.xml";
                      title = "Wall Street Journal";
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
