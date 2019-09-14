# To set a default Zoom for all pages
# (https://bugzilla.mozilla.org/show_bug.cgi?id=332275#c52):
#   1. Open the browser console with CTRL+SHIFT+J
#   2. Enter the following command:
#     FullZoom._cps2.setGlobal(
#       FullZoom.name,
#       {zoom level here (0 < x <= 1},
#       gBrowser.selectedBrowser.loadContext
#     );

{ config, pkgs, ... }:

with pkgs;

{
  programs.firefox = {
    enable = true;
    extensions = [];
    profiles = {
      default = {
        settings = {
          "browser.newtabpage.enabled" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "app.normandy.first_run" = false;
          # No warning when navigating to about:about
          "general.warnOnAboutConfig" = false;
          # Minimize suggested list dropdown
          "browser.urlbar.oneOffSearches" = false;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.history" = true;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.searchSuggestionsChoice" = false;
          # Search engine
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "general.smoothScroll" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.contentblocking.category" = "strict";
          "privacy.trackingprotection.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          # Related to privacy settings
          "network.cookie.cookieBehavior" = 4;
          # Do not ask to store site passwords
          "signon.rememberSignons" = false;
          # Do not show the contentblocking intro
          "browser.contentblocking.introCount" = 20;
          "browser.tabs.drawInTitlebar" = false;
          # Disable annoying animations like fullscreen animation
          "toolkit.cosmeticAnimations.enabled" = false;
          # Dense
          "browser.uidensity" = 1;
          # CTRL+TAB can now be used to switch to next/previous tab
          "browser.ctrlTab.recentlyUsedOrder" = false;
          "browser.download.panel.shown" = true;
          "browser.bookmarks.showMobileBookmarks" = false;
        };
        # https://github.com/Aris-t2/CustomCSSforFx/
        userChrome = ''
          #sidebar-header {
            display: none;
          }

          #sidebar-box + #sidebar-splitter {
            width: 1px !important;
          }
          '';
      };
    };
  };
}
