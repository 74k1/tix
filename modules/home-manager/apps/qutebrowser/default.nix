{lib, ...}:
{
  programs.qutebrowser = {
    enable = true;
    loadAutoconfig = true;
    settings = {
      auto_save.session = true;
      # fonts = rec {
      #   default_family = "PP Supply Mono";
      #   default_size = "14pt";
      #   web.family.fixed = default_family;
      # };
      tabs.background = true;
      completion = {
        height = "30%";
        open_categories = [ "history" ];
        scrollbar = {
          padding = 0;
          width = 2;
        };
        show = "always";
        shrink = "true";
        timestamp_format = "";
        web_history.max_items = 10;
      };
      content = {
        blocking = {
          enabled = true;
          method = "both";
          adblock.lists = [
            "https://easylist.to/easylist/easylist.txt"
            "https://easylist.to/easylist/easyprivacy.txt"
            "https://easylist.to/easylist/fanboy-annoyance.txt"
            "https://www.i-dont-care-about-cookies.eu/abp/"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt"
            "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
            "https://raw.githubusercontent.com/Ewpratten/youtube_ad_blocklist/master/blocklist.txt"
          ];
        };
        canvas_reading = false;
        autoplay = false;
      };
      downloads = {
        position = "bottom";
        remove_finished = 0;
      };
      scrolling.smooth = true;
    };
    searchEngines = {
      "DEFAULT" = "https://kagi.com/search?q={}";
      ":b" = "https://search.brave.com/search?q={}&source=web";
      ":g" = "https://www.google.com/search?hl=en&q={}";
      ":gs" = "https://github.com/search?o=desc&q={}&s=stars";
      ":mn" = "https://mynixos.com/search?q={}";
      ":nw" = "https://wiki.nixos.org/w/index.php?search={}";
      ":p" = "https://www.perplexity.ai/search?focus=internet&q={}";
    };
  };
}
