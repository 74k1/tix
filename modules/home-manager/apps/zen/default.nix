{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.twilight ];
  programs.zen-browser = {
    enable = true;
    profiles.taki = {
      name = "taki";
      search.default = "Kagi";
      search.force = true;
      search.engines = {
        "bing".metaData.hidden = true;
        "ebay".metaData.hidden = true;
        "google" = {
          urls = [ { template = "https://www.google.com/search?q={searchTerms}"; } ];
          icon = "https://icons.duckduckgo.com/ip3/google.com.ico";
          definedAliases = [
            ":g"
            "@google"
          ];
        };
        "Perplexity" = {
          urls = [ { template = "https://www.perplexity.ai/search?focus=internet&q={searchTerms}"; } ];
          icon = "https://icons.duckduckgo.com/ip3/perplexity.ai.ico";
          definedAliases = [
            ":p"
            "@pp"
            "@perplexity"
          ];
        };
        "Kagi" = {
          urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
          icon = "https://kagi.com/favicon.ico";
          definedAliases = [
            ":k"
            "@kagi"
          ];
        };
        "ddg" = {
          urls = [ { template = "https://duckduckgo.com/?t=h_&q={searchTerms}&ia=web"; } ];
          icon = "https://icons.duckduckgo.com/ip3/duckduckgo.com.ico";
          definedAliases = [
            ":d"
            "@ddg"
            "@duckduckgo"
          ];
        };
        "Brave Search" = {
          urls = [ { template = "https://search.brave.com/search?q={searchTerms}&source=web"; } ];
          icon = "https://icons.duckduckgo.com/ip3/search.brave.com.ico";
          definedAliases = [
            ":b"
            "@brave"
          ];
        };
        "MyNixOS" = {
          urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [
            ":mn"
            "@mynixos"
          ];
        };
        "Nixplorer" = {
          urls = [ { template = "https://nixplorer.com/search?q={searchTerms}"; } ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [
            ":np"
            "@nixplorer"
          ];
        };
        "NixOS Wiki" = {
          urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nw" ];
        };
      };
      # userChrome == FF Interface
      userChrome = # css
        ''
          .toolbarbutton-icon[src^="page-icon:https://github.com"]{
            filter: invert(1) !important;
          }
          .tab-icon-image[src*="github.com"] {
            filter: invert(1) !important;
          }

          /**
           * Dynamic Horizontal Tabs Toolbar (with animations)
           * sidebar.verticalTabs: false (with native horizontal tabs)
           */
          #main-window #TabsToolbar > .toolbar-items {
            overflow: hidden;
            transition: height 0.3s 0.3s !important;
          }
          /* Default state: Set initial height to enable animation */
          #main-window #TabsToolbar > .toolbar-items { height: 3em !important; }
          #main-window[uidensity="touch"] #TabsToolbar > .toolbar-items { height: 3.35em !important; }
          #main-window[uidensity="compact"] #TabsToolbar > .toolbar-items { height: 2.7em !important; }
          /* Hidden state: Hide native tabs strip */
          #main-window[titlepreface*="​"] #TabsToolbar > .toolbar-items { height: 0 !important; }
          /* Hidden state: Fix z-index of active pinned tabs */
          #main-window[titlepreface*="​"] #tabbrowser-tabs { z-index: 0 !important; }
          /* Hidden state: Hide window buttons in tabs-toolbar */
          #main-window[titlepreface*="​"] #TabsToolbar .titlebar-spacer,
          #main-window[titlepreface*="​"] #TabsToolbar .titlebar-buttonbox-container {
            display: none !important;
          }
          /* [Optional] Uncomment block below to show window buttons in nav-bar (maybe, I didn't test it on non-linux-i3wm env) */
          /* #main-window[titlepreface*="XXX"] #nav-bar > .titlebar-buttonbox-container,
          #main-window[titlepreface*="XXX"] #nav-bar > .titlebar-buttonbox-container > .titlebar-buttonbox {
            display: flex !important;
          } */
          /* [Optional] Uncomment one of the line below if you need space near window buttons */
          /* #main-window[titlepreface*="XXX"] #nav-bar > .titlebar-spacer[type="pre-tabs"] { display: flex !important; } */
          /* #main-window[titlepreface*="XXX"] #nav-bar > .titlebar-spacer[type="post-tabs"] { display: flex !important; } */
        '';
      # userContent == web-pages and internal pages like about:newtab & about:home
      userContent = # css
        ''
          @media (-moz-bool-pref: "zen.view.compact") {
            #tabbrowser-tabpanels:not([zen-split-view]) {
              --zen-webview-border-radius: 0 0 0 0;
              --zen-element-separation: 0;
            }
            & .browserSidebarContainer {
              margin-left: 0 !important;
            }
          }
        '';
      settings = {
        # USER CONF
        "browser.download.panel.shown" = true;
        "media.videocontrols.picture-in-picture.enabled" = false;
        "sidebar.revamp" = true;
        "browser.tabs.insertAfterCurrent" = true;

        # Check SMOOTHFOX below
        # "general.smoothScroll.currentVelocityWeighting" = 0;
        # "general.smoothScroll.mouseWheel.durationMaxMS" = 250;
        # "general.smoothScroll.stopDecelerationWeighting" = 0.82;
        # "mousewheel.min_line_scroll_amount" = 25;

        # Main Config is based on BetterFox @
        # https://github.com/yokoffing/Betterfox
        ################# FAST FOX #################
        "nglayout.initialpaint.delay" = 0;
        "nglayout.initialpaint.delay_in_oopif" = 0;
        "content.notify.interval" = 100000;
        "browser.startup.preXulSkeletonUI" = false;

        # Experimental
        "layout.css.grid-template-masonry-value.enabled" = true;
        "layout.css.animation-composition.enabled" = true;
        "dom.enable_web_task_scheduling" = true;

        # GFX
        "gfx.webrender.all" = true;
        "gfx.webrender.precache-shaders" = true;
        "gfx.webrender.compositor" = true;
        "layers.gpu-process.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "gfx.canvas.accelerated" = true;
        "gfx.canvas.accelerated.cache-items" = 32768;
        "gfx.canvas.accelerated.cache-size" = 4096;
        "gfx.content.skia-font-cache-size" = 80;
        "image.cache.size" = 10485760;
        "image.mem.decode_bytes_at_a_time" = 131072;
        "image.mem.shared.unmap.min_expiration_ms" = 120000;
        "media.memory_cache_max_size" = 1048576;
        "media.memory_caches_combined_limit_kb" = 2560000;
        "media.cache_readahead_limit" = 9000;
        "media.cache_resume_threshold" = 6000;

        # Browser Cache
        "browser.cache.memory.max_entry_size" = 153600;

        # Network
        "network.buffer.cache.size" = 262144;
        "network.buffer.cache.count" = 128;
        "network.ssl_tokens_cache_capacity" = 32768;

        ################# SECUREFOX #################
        # Tracking Protection
        "browser.contentblocking.category" = "strict";
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
        "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";
        "privacy.query_stripping.strip_list" =
          "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid";
        "browser.uitour.enabled" = false;

        # OCSP & CERTS / HPKP
        "security.OCSP.enabled" = 0;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;
        "security.cert_pinning.enforcement_level" = 2;

        # SSL/TLS
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "browser.xul.error_pages.expert_bad_cert" = true;
        "security.tls.enable_0rtt_data" = false;

        # Disk Avoidance
        "browser.cache.disk.enable" = false;
        "browser.privatebrowsing.forceMediaMemoryCache" = true;
        "browser.sessionstore.privacy_level" = 2;

        # Shutdown and Sanitizing
        "privacy.history.custom" = true;

        # Speculative connections
        "network.http.speculative-parallel-limit" = 0;
        "network.dns.disablePrefetch" = true;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.places.speculativeConnect.enabled" = false;
        "network.prefetch-next" = false;
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false;

        # Search and URL bar
        "browser.search.separatePrivateDefault.ui.enabled" = true;
        "browser.urlbar.update2.engineAliasRefresh" = true;
        "browser.search.suggest.enabled" = true; # CHANGED
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "network.IDN_show_punycode" = true;

        # HTTPS-first mode
        "dom.security.https_first" = true;

        # Proxy/Socks/IPv6
        "network.proxy.socks_remote_dns" = true;
        "network.file.disable_unc_paths" = true;
        "network.gio.supported-protocols" = "";

        # Passwords and Autofill
        "signon.formlessCapture.enabled" = false;
        "signon.privateBrowsingCapture.enabled" = false;
        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;
        "editor.truncate_user_pastes" = false;
        "layout.forms.reveal-password-context-menu.enabled" = true;

        # Address + Credit Cards manager
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
        "browser.formfill.enable" = false;

        # Mixed content + Cross-site
        "network.auth.subresource-http-auth-allow" = 1;
        "pdfjs.enableScripting" = false;
        "extensions.postDownloadThirdPartyPrompt" = false;
        "permissions.delegation.enabled" = false;

        # Headers/Referers
        "network.http.referer.XOriginTrimmingPolicy" = 2;

        # Containers
        "privacy.userContext.ui.enabled" = true;

        # Webrtc
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        "media.peerconnection.ice.default_address_only" = true;

        # Safe Browsing
        "browser.safebrowsing.downloads.remote.enabled" = false;

        # Mozilla
        "accessibility.force_disabled" = 1;
        "browser.tabs.firefox-view" = false;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.geo" = 2;
        "geo.provider.network.url" =
          "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.provider.ms-windows-location" = false; # WINDOWS
        "geo.provider.use_corelocation" = false; # MAC
        "geo.provider.use_gpsd" = false; # LINUX
        "geo.provider.use_geoclue" = false; # LINUX
        "permissions.manager.defaultsUrl" = "";
        "webchannel.allowObject.urlWhitelist" = "";

        # Telemetry
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "captivedetect.canonicalURL" = "";
        "network.captive-portal-service.enabled" = false;
        "network.connectivity-service.enabled" = false;
        "default-browser-agent.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        ################# PESKYFOX #################
        # Mozilla UI
        "layout.css.prefers-color-scheme.content-override" = 2;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "app.update.suppressPrompts" = true;
        "browser.compactmode.show" = true;
        "browser.privatebrowsing.vpnpromourl" = "";
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.tabs.tabmanager.enabled" = false;
        "browser.aboutwelcome.enabled" = false;
        "findbar.highlightAll" = true;
        "middlemouse.contentLoadURL" = false;
        "browser.privatebrowsing.enable-new-indicator" = false;

        # Fullscreen
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.delay" = 0;
        "full-screen-api.warning.timeout" = 0;

        # URL Bar
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;

        # New tab page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

        # Pocket
        "extensions.pocket.enabled" = false;

        # Downloads
        "browser.download.useDownloadDir" = false;
        "browser.download.alwaysOpenPanel" = false;
        "browser.download.manager.addToRecentDocs" = false;
        "browser.download.always_ask_before_handling_new_types" = true;

        # PDF
        "browser.download.open_pdf_attachments_inline" = true;

        # Tab behavior
        "browser.link.open_newwindow.restriction" = 0;
        "dom.disable_window_move_resize" = true;
        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.bookmarks.openInTabClosesMenu" = false;
        "dom.popup_allowed_events" =
          "change click dblclick auxclick mousedown mouseup pointerdown pointerup notificationclick reset submit touchend contextmenu"; # reset pref; remove in v.111
        "layout.css.has-selector.enabled" = true;

        ################# SMOOTHFOX #################
        "apz.overscroll.enabled" = true;
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
        "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
        "general.smoothScroll.currentVelocityWeighting" = "1";
        "general.smoothScroll.stopDecelerationWeighting" = "1";
        "mousewheel.default.delta_multiplier_y" = 300;

        ################# OVERRIDES #################
        "browser.startup.homepage" = "";
        # Enable HTTPS-Only Mode
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        # Privacy settings
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        # Disable all sorts of telemetry
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;

        # As well as Firefox 'experiments'
        "experiments.activeExperiment" = false;
        "experiments.enabled" = false;
        "experiments.supported" = false;
        "network.allow-experiments" = false;
        # Disable Pocket Integration
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.showHome" = false;
        "extensions.pocket.site" = "";
        # Allow copy to clipboard
        "dom.events.asyncClipboard.clipboardItem" = true;
      };
    };
  };
}
