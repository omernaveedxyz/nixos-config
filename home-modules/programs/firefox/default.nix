{
  config,
  lib,
  nur,
  ...
}:
let
  inherit (lib) mkIf mkOptionDefault getExe;
in
{
  imports = [ nur.hmModules.nur ];
}
// mkIf (config._module.args.browser == "firefox") {
  programs.firefox = {
    # Whether to enable Firefox
    enable = true;

    # Attribute set of Firefox profiles
    profiles."Default" = {
      # List of Firefox add-on packages to install for this profile
      extensions = with config.nur.repos.rycee.firefox-addons; [ ublock-origin ];

      # The default search engine used in the address bar and search bar
      search.default = "DuckDuckGo";

      # The default search engine used in the Private Browsing
      search.privateDefault = "DuckDuckGo";

      # Attribute set of Firefox preferences
      settings = {
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # START: internal custom pref to test for syntax error
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable about:config warning
        "browser.aboutConfig.showWarning" = false;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # STARTUP
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable default browser check
        "browser.shell.checkDefaultBrowser" = false;
        # -------------------------------------
        # Set startup page
        # 0=blank = 1=home, 2=last visited page, 3=resume previous session
        "browser.startup.page" = 0;
        # -------------------------------------
        # Set HOME+NEWWINDOW page
        "browser.startup.homepage" = "about:blank";
        # -------------------------------------
        # Set NEWTAB page
        # true=Activity Stream (default) = false=blank page
        "browser.newtabpage.enabled" = false;
        # -------------------------------------
        # Disable sponsored content on Firefox Home (Activity Stream)
        "browser.newtabpage.activity-stream.showSponsored" = false; # [FF58+]
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false; # [FF83+] Shortcuts>Sponsored shortcuts
        # -------------------------------------
        # Clear default topsites
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.topsites.contile.enabled" = false;
        "browser.topsites.useRemoteSetting" = false;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # GEOLOCATION
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Use Mozilla geolocation service instead of Google if permission is granted [FF74+]
        "geo.provider.network.url" = "";
        # "geo.provider.network.logging.enabled" = true; // [HIDDEN PREF]
        # -------------------------------------
        # Disable using the OS's geolocation service
        "geo.provider.ms-windows-location" = false; # [WINDOWS]
        "geo.provider.use_corelocation" = false; # [MAC]
        "geo.provider.use_gpsd" = false; # [LINUX] [HIDDEN PREF]
        "geo.provider.geoclue.always_high_accuracy" = false; # [LINUX]
        "geo.provider.use_geoclue" = false; # [FF102+] [LINUX]
        # -------------------------------------
        # Disable region updates
        "browser.region.network.url" = ""; # [FF78+] Defense-in-depth
        "browser.region.update.enabled" = false; # [FF79+]
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # QUIETER FOX
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # RECOMMENDATIONS
        #
        # Disable recommendation pane in about:addons (uses Google Analytics)
        "extensions.getAddons.showPane" = false; # [HIDDEN PREF]
        # -------------------------------------
        # Disable recommendations in about:addons' Extensions and Themes panes [FF68+]
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        # -------------------------------------
        # Disable personalized Extension Recommendations in about:addons and AMO [FF65+]
        "browser.discovery.enabled" = false;
        # -------------------------------------
        # Disable shopping experience [FF116+]
        "browser.shopping.experience2023.enabled" = false; # [DEFAULT: false]
        "browser.shopping.experience2023.opted" = 2;
        "browser.shopping.experience2023.active" = false;
        #
        # TELEMETRY
        #
        # Disable new data submission [FF41+]
        "datareporting.policy.dataSubmissionEnabled" = false;
        # -------------------------------------
        # Disable Health Reports
        "datareporting.healthreport.uploadEnabled" = false;
        # -------------------------------------
        # Disable telemetry
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false; # see [NOTE]
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false; # [FF55+]
        "toolkit.telemetry.shutdownPingSender.enabled" = false; # [FF55+]
        "toolkit.telemetry.updatePing.enabled" = false; # [FF56+]
        "toolkit.telemetry.bhrPing.enabled" = false; # [FF57+] Background Hang Reporter
        "toolkit.telemetry.firstShutdownPing.enabled" = false; # [FF57+]
        "browser.search.serpEventTelemetry.enabled" = false;
        # -------------------------------------
        # Skip checking omni.ja and other files
        "corroborator.enabled" = false;
        # -------------------------------------
        # Disable Telemetry Coverage
        "toolkit.telemetry.coverage.opt-out" = true; # [HIDDEN PREF]
        "toolkit.coverage.opt-out" = true; # [FF64+] [HIDDEN PREF]
        "toolkit.coverage.endpoint.base" = "";
        # -------------------------------------
        # Disable Firefox Home (Activity Stream) telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        # -------------------------------------
        # Disable WebVTT logging and test events
        "media.webvtt.debug.logging" = false;
        "media.webvtt.testing.events" = false;
        # -------------------------------------
        # Disable send content blocking log to about:protections
        "browser.contentblocking.database.enabled" = false;
        # -------------------------------------
        # Disable celebrating milestone toast when certain numbers of trackers are blocked
        "browser.contentblocking.cfr-milestone.enabled" = false;
        # -------------------------------------
        # Disable Default Browser Agent
        "default-browser-agent.enabled" = false; # [WINDOWS]
        #
        # STUDIES
        #
        # Disable Studies
        "app.shield.optoutstudies.enabled" = false;
        # -------------------------------------
        # Disable Normandy/Shield [FF60+]
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        #
        # CRASH REPORTS
        #
        # Disable Crash Reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false; # [FF44+]
        # "browser.crashReports.unsubmittedCheck.enabled" = false; // [FF51+] [DEFAULT: false]
        # -------------------------------------
        # Enforce no submission of backlogged Crash Reports [FF58+]
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # [DEFAULT: false]
        #
        # OTHER
        #
        # Disable Captive Portal detection
        "captivedetect.canonicalURL" = "";
        "network.captive-portal-service.enabled" = false; # [FF52+]
        # -------------------------------------
        # Disable Network Connectivity checks [FF65+]
        "network.connectivity-service.enabled" = false;
        # -------------------------------------
        # Disable contentblocking reports
        "browser.contentblocking.reportBreakage.url" = "";
        "browser.contentblocking.report.cookie.url" = "";
        "browser.contentblocking.report.cryptominer.url" = "";
        "browser.contentblocking.report.fingerprinter.url" = "";
        "browser.contentblocking.report.lockwise.enabled" = false;
        "browser.contentblocking.report.lockwise.how_it_works.url" = "";
        "browser.contentblocking.report.manage_devices.url" = "";
        "browser.contentblocking.report.monitor.enabled" = false;
        "browser.contentblocking.report.monitor.how_it_works.url" = "";
        "browser.contentblocking.report.monitor.sign_in_url" = "";
        "browser.contentblocking.report.monitor.url" = "";
        "browser.contentblocking.report.proxy.enabled" = false;
        "browser.contentblocking.report.proxy_extension.url" = "";
        "browser.contentblocking.report.social.url" = "";
        "browser.contentblocking.report.tracker.url" = "";
        "browser.contentblocking.report.endpoint_url" = "";
        "browser.contentblocking.report.monitor.home_page_url" = "";
        "browser.contentblocking.report.monitor.preferences_url" = "";
        "browser.contentblocking.report.vpn.enabled" = false;
        "browser.contentblocking.report.hide_vpn_banner" = true;
        "browser.contentblocking.report.show_mobile_app" = false;
        "browser.vpn_promo.enabled" = false;
        "browser.promo.focus.enabled" = false;
        # -------------------------------------
        # Block unwanted connections
        "app.feedback.baseURL" = "";
        "app.support.baseURL" = "";
        "app.releaseNotesURL" = "";
        "app.update.url.details" = "";
        "app.update.url.manual" = "";
        "app.update.staging.enabled" = false;
        # -------------------------------------
        # Remove default handlers and translation engine
        "gecko.handlerService.schemes.mailto.0.uriTemplate" = "";
        "gecko.handlerService.schemes.mailto.0.name" = "";
        "gecko.handlerService.schemes.mailto.1.uriTemplate" = "";
        "gecko.handlerService.schemes.mailto.1.name" = "";
        "gecko.handlerService.schemes.irc.0.uriTemplate" = "";
        "gecko.handlerService.schemes.irc.0.name" = "";
        "gecko.handlerService.schemes.ircs.0.uriTemplate" = "";
        "gecko.handlerService.schemes.ircs.0.name" = "";
        "browser.translation.engine" = "";
        # -------------------------------------
        # Disable connections to Mozilla servers
        "services.settings.server" = "";
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # SAFE BROWSING (SB)
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable SB (Safe Browsing)
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.passwords.enabled" = false;
        "browser.safebrowsing.allowOverride" = false;
        # -------------------------------------
        # Disable SB checks for downloads (both local lookups + remote)
        "browser.safebrowsing.downloads.enabled" = false;
        # -------------------------------------
        # Disable SB checks for downloads (remote)
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        # -------------------------------------
        # Disable SB checks for unwanted software
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        # -------------------------------------
        # Disable "ignore this warning" on SB warnings [FF45+]
        # "browser.safebrowsing.allowOverride" = false;
        # -------------------------------------
        # Google connections
        "browser.safebrowsing.downloads.remote.block_dangerous" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
        "browser.safebrowsing.provider.google.updateURL" = "";
        "browser.safebrowsing.provider.google.gethashURL" = "";
        "browser.safebrowsing.provider.google4.updateURL" = "";
        "browser.safebrowsing.provider.google4.gethashURL" = "";
        "browser.safebrowsing.provider.google.reportURL" = "";
        "browser.safebrowsing.reportPhishURL" = "";
        "browser.safebrowsing.provider.google4.reportURL" = "";
        "browser.safebrowsing.provider.google.reportMalwareMistakeURL" = "";
        "browser.safebrowsing.provider.google.reportPhishMistakeURL" = "";
        "browser.safebrowsing.provider.google4.reportMalwareMistakeURL" = "";
        "browser.safebrowsing.provider.google4.reportPhishMistakeURL" = "";
        "browser.safebrowsing.provider.google4.dataSharing.enabled" = false;
        "browser.safebrowsing.provider.google4.dataSharingURL" = "";
        "browser.safebrowsing.provider.google.advisory" = "";
        "browser.safebrowsing.provider.google.advisoryURL" = "";
        "browser.safebrowsing.provider.google4.advisoryURL" = "";
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.provider.mozilla.gethashURL" = "";
        "browser.safebrowsing.provider.mozilla.updateURL" = "";
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # BLOCK IMPLICIT OUTBOUND
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable link prefetching
        "network.prefetch-next" = false;
        # -------------------------------------
        # Disable DNS prefetching
        "network.dns.disablePrefetch" = true;
        # "network.dns.disablePrefetchFromHTTPS" = true; // [DEFAULT: true]
        # -------------------------------------
        # Disable predictor / prefetching
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false; # [FF48+] [DEFAULT: false]
        # -------------------------------------
        # Disable link-mouseover opening connection to linked server
        "network.http.speculative-parallel-limit" = 0;
        # -------------------------------------
        # Disable mousedown speculative connections on bookmarks and history [FF98+]
        "browser.places.speculativeConnect.enabled" = false;
        # -------------------------------------
        # Enforce no "Hyperlink Auditing" (click tracking)
        # "browser.send_pings" = false; // [DEFAULT: false]
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # DNS / DoH / PROXY / SOCKS
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Set the proxy server to do any DNS lookups when using SOCKS
        "network.proxy.socks_remote_dns" = true;
        # -------------------------------------
        # Disable using UNC (Uniform Naming Convention) paths [FF61+]
        "network.file.disable_unc_paths" = true; # [HIDDEN PREF]
        # -------------------------------------
        # Disable GIO as a potential proxy bypass vector
        "network.gio.supported-protocols" = ""; # [HIDDEN PREF] [DEFAULT: "" FF118+]
        # -------------------------------------
        # Disable proxy direct failover for system requests [FF91+]
        # "network.proxy.failover_direct" = false;
        # -------------------------------------
        # Disable proxy bypass for system request failures [FF95+]
        # "network.proxy.allow_bypass" = false;
        # -------------------------------------
        # Disable DNS-over-HTTPS (DoH)[FF60+]
        "network.trr.mode" = 5;
        "network.trr.confirmationNS" = "";
        # -------------------------------------
        # Disable skipping DoH when parental controls are enabled
        "network.trr.uri" = "";
        "network.trr.custom_uri" = "";
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable location bar making speculative connections [FF56+]
        "browser.urlbar.speculativeConnect.enabled" = false;
        # -------------------------------------
        # Disable location bar contextual suggestions
        # "browser.urlbar.quicksuggest.enabled" = false; // [FF92+] [DEFAULT: false]
        # "browser.urlbar.suggest.quicksuggest.nonsponsored" = false; // [FF95+] [DEFAULT: false]
        # "browser.urlbar.suggest.quicksuggest.sponsored" = false; // [FF92+] [DEFAULT: false]
        # -------------------------------------
        # Disable live search suggestions
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        # -------------------------------------
        # Disable urlbar trending search suggestions [FF118+]
        "browser.urlbar.trending.featureGate" = false;
        # -------------------------------------
        # Disable urlbar suggestions
        "browser.urlbar.addons.featureGate" = false; # [FF115+]
        "browser.urlbar.mdn.featureGate" = false; # [FF117+] [HIDDEN PREF]
        "browser.urlbar.pocket.featureGate" = false; # [FF116+] [DEFAULT: false]
        "browser.urlbar.weather.featureGate" = false; # [FF108+] [DEFAULT: false]
        "browser.urlbar.yelp.featureGate" = false; # [FF124+] [DEFAULT: false]
        # -------------------------------------
        # Disable urlbar clipboard suggestions [FF118+]
        "browser.urlbar.clipboard.featureGate" = false;
        # -------------------------------------
        # Disable search and form history
        "browser.formfill.enable" = false;
        # -------------------------------------
        # Disable tab-to-search [FF85+]
        "browser.urlbar.suggest.engines" = false;
        # -------------------------------------
        # Disable coloring of visited links
        "layout.css.visited_links_enabled" = false;
        # -------------------------------------
        # Enable separate default search engine in Private Windows and its UI setting
        "browser.search.separatePrivateDefault" = true; # [FF70+]
        "browser.search.separatePrivateDefault.ui.enabled" = true; # [FF71+]
        # -------------------------------------
        # Disable merino
        "browser.urlbar.merino.enabled" = false;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # PASSWORDS
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable saving passwords and password alerts.
        "signon.rememberSignons" = false;
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.management.page.breachAlertUrl" = "";
        # -------------------------------------
        # Set when Firefox should prompt for the primary password
        # 0=once per session (default) = 1=every time it's needed, 2=after n minutes
        "security.ask_for_password" = 2;
        # -------------------------------------
        # Set how long in minutes Firefox should remember the primary password (0901)
        "security.password_lifetime" = 5; # [DEFAULT: 30]
        # -------------------------------------
        # Disable auto-filling username & password form fields
        "signon.autofillForms" = false;
        # -------------------------------------
        # Disable formless login capture for Password Manager [FF51+]
        "signon.formlessCapture.enabled" = false;
        # -------------------------------------
        # Limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources [FF41+]
        # 0 = don't allow sub-resources to open HTTP authentication credentials dialogs
        # 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
        # 2 = allow sub-resources to open HTTP authentication credentials dialogs (default)
        "network.auth.subresource-http-auth-allow" = 1;
        # -------------------------------------
        # Enforce no automatic authentication on Microsoft sites [FF91+] [WINDOWS 10+]
        # "network.http.windows-sso.enabled" = false; // [DEFAULT: false]
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # DISK AVOIDANCE
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable disk cache
        "browser.cache.disk.enable" = false;
        # -------------------------------------
        # Disable media cache from writing to disk in Private Browsing
        "browser.privatebrowsing.forceMediaMemoryCache" = true; # [FF75+]
        "media.memory_cache_max_size" = 65536;
        # -------------------------------------
        # Disable storing extra session data
        # 0=everywhere = 1=unencrypted sites, 2=nowhere
        "browser.sessionstore.privacy_level" = 2;
        # -------------------------------------
        # Disable automatic Firefox start and session restore after reboot [FF62+] [WINDOWS]
        "toolkit.winRegisterApplicationRestart" = false;
        # -------------------------------------
        # Disable favicons in shortcuts [WINDOWS]
        "browser.shell.shortcutFavicons" = false;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Require safe negotiation
        "security.ssl.require_safe_negotiation" = true;
        # -------------------------------------
        # Disable TLS1.3 0-RTT (round-trip time) [FF51+]
        "security.tls.enable_0rtt_data" = false;
        #
        # OCSP (Online Certificate Status Protocol)
        #
        # Enforce OCSP fetching to confirm current validity of certificates
        # 0=disabled = 1=enabled (default), 2=enabled for EV certificates only
        "security.OCSP.enabled" = 0; # [DEFAULT: 1]
        # -------------------------------------
        # Set OCSP fetch failures (non-stapled) to hard-fail [SETUP-WEB]
        "security.OCSP.require" = false;
        #
        # CERTS / HPKP (HTTP Public Key Pinning)
        #
        # Enable strict PKP (Public Key Pinning)
        # 0=disabled = 1=allow user MiTM (default; such as your antivirus), 2=strict
        "security.cert_pinning.enforcement_level" = 2;
        # -------------------------------------
        # Disable CRLite [FF73+]
        # 0 = disabled
        # 1 = consult CRLite but only collect telemetry (default)
        # 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
        # 3 = consult CRLite and enforce "Not Revoked" results = but defer to OCSP for "Revoked" (default)
        "security.remote_settings.intermediates.enabled" = false;
        "security.remote_settings.intermediates.bucket" = "";
        "security.remote_settings.intermediates.collection" = "";
        "security.remote_settings.intermediates.signer" = "";
        "security.remote_settings.crlite_filters.enabled" = false;
        "security.remote_settings.crlite_filters.bucket" = "";
        "security.remote_settings.crlite_filters.collection" = "";
        "security.remote_settings.crlite_filters.signer" = "";
        "security.pki.crlite_mode" = 0;
        #
        # MIXED CONTENT
        #
        # Disable insecure passive content (such as images) on https pages [SETUP-WEB]
        # "security.mixed_content.block_display_content" = true; // Defense-in-depth
        # -------------------------------------
        # Enable HTTPS-Only mode in all windows
        "dom.security.https_only_mode" = true; # [FF76+]
        # "dom.security.https_only_mode_pbm" = true; // [FF80+]
        # -------------------------------------
        # Enable HTTPS-Only mode for local resources [FF77+]
        # "dom.security.https_only_mode.upgrade_local" = true;
        # -------------------------------------
        # Disable HTTP background requests [FF82+]
        "dom.security.https_only_mode_send_http_background_request" = false;
        # -------------------------------------
        # Disable ping to Mozilla for Man-in-the-Middle detection
        "security.certerrors.mitm.priming.enabled" = false;
        "security.certerrors.mitm.priming.endpoint" = "";
        "security.pki.mitm_canary_issuer" = "";
        "security.pki.mitm_canary_issuer.enabled" = false;
        "security.pki.mitm_detected" = false;
        #
        # UI (User Interface)
        #
        # Display warning on the padlock for "broken security"
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        # -------------------------------------
        # Display advanced information on Insecure Connection warning pages
        "browser.xul.error_pages.expert_bad_cert" = true;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # REFERERS
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Control the amount of cross-origin information to send [FF52+]
        # 0=send full URI (default) = 1=scheme+host+port+path, 2=scheme+host+port
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # CONTAINERS
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Enable Container Tabs and its UI setting [FF50+]
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        # -------------------------------------
        # Set behavior on "+ Tab" button to display container menu on left click [FF74+]
        # "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;
        # -------------------------------------
        # Set external links to open in site-specific containers [FF123+]
        # "browser.link.force_default_user_context_id_for_external_opens" = true;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # PLUGINS / MEDIA / WEBRTC
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Force WebRTC inside the proxy [FF70+]
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        # -------------------------------------
        # Force a single network interface for ICE candidates generation [FF42+]
        "media.peerconnection.ice.default_address_only" = true;
        # -------------------------------------
        # Force exclusion of private IPs from ICE candidates [FF51+]
        # "media.peerconnection.ice.no_host" = true;
        # -------------------------------------
        # Disable GMP (Gecko Media Plugins)
        "media.gmp-provider.enabled" = false;
        "media.gmp-manager.url" = "";
        "media.gmp-gmpopenh264.enabled" = false;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # DOM (DOCUMENT OBJECT MODEL)
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Prevent scripts from moving and resizing open windows
        "dom.disable_window_move_resize" = true;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # MISCELLANEOUS
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Remove temp files opened from non-PB windows with an external application
        "browser.download.start_downloads_in_tmp_dir" = true; # [FF102+]
        # -------------------------------------
        # Disable sending additional analytics to web servers
        "beacon.enabled" = false;
        # -------------------------------------
        # Remove temp files opened with an external application
        "browser.helperApps.deleteTempFileOnExit" = true;
        # -------------------------------------
        # Disable UITour backend so there is no chance that a remote page can use it
        "browser.uitour.enabled" = false;
        "browser.uitour.url" = ""; # Defense-in-depth
        # -------------------------------------
        # Reset remote debugging to disabled
        "devtools.debugger.remote-enabled" = false; # [DEFAULT: false]
        # -------------------------------------
        # Disable websites overriding Firefox's keyboard shortcuts [FF58+]
        # 0 (default) or 1=allow = 2=block
        # "permissions.default.shortcuts" = 2;
        # -------------------------------------
        # Remove special permissions for certain mozilla domains [FF35+]
        "permissions.manager.defaultsUrl" = "";
        # -------------------------------------
        # Remove webchannel whitelist
        "webchannel.allowObject.urlWhitelist" = "";
        # -------------------------------------
        # Use Punycode in Internationalized Domain Names to eliminate possible spoofing
        "network.IDN_show_punycode" = true;
        # -------------------------------------
        # Enforce PDFJS = disable PDFJS scripting
        "pdfjs.disabled" = false; # [DEFAULT: false]
        "pdfjs.enableScripting" = false; # [FF86+]
        # -------------------------------------
        # Disable middle click on new tab button opening URLs or searches using clipboard [FF115+]
        "browser.tabs.searchclipboardfor.middleclick" = false; # [DEFAULT: false NON-LINUX]
        # -------------------------------------
        # Disable content analysis by DLP (Data Loss Prevention) agents
        "browser.contentanalysis.default_allow" = false; # [FF124+] [DEFAULT: false]
        # -------------------------------------
        # Disable the default checkedness for "Save card and address to Firefox" checkboxes
        "dom.payments.defaults.saveAddress" = false;
        "dom.payments.defaults.saveCreditCard" = false;
        # -------------------------------------
        # Disable Displaying Javascript in History URLs
        "browser.urlbar.filter.javascript" = true;
        #
        # DOWNLOADS
        #
        # Enable user interaction for security by always asking where to download
        "browser.download.useDownloadDir" = false;
        # -------------------------------------
        # Disable downloads panel opening on every download [FF96+]
        "browser.download.alwaysOpenPanel" = false;
        # -------------------------------------
        # Disable adding downloads to the system's "recent documents" list
        "browser.download.manager.addToRecentDocs" = false;
        # -------------------------------------
        # Enable user interaction for security by always asking how to handle new mimetypes [FF101+]
        "browser.download.always_ask_before_handling_new_types" = true;
        #
        # EXTENSIONS
        #
        # Limit allowed extension directories
        "extensions.enabledScopes" = 5; # [HIDDEN PREF]
        "extensions.autoDisableScopes" = 0;
        # -------------------------------------
        # Disable bypassing 3rd party extension install prompts [FF82+]
        "extensions.postDownloadThirdPartyPrompt" = false;
        # -------------------------------------
        # Disable webextension restrictions on certain mozilla domains [FF60+]
        # "extensions.webextensions.restrictedDomains" = "";
        # -------------------------------------
        # Disable extensions suggestions
        "extensions.webservice.discoverURL" = "";
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # ETP (ENHANCED TRACKING PROTECTION)
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Enable ETP Strict Mode [FF86+]
        "browser.contentblocking.category" = "strict"; # [HIDDEN PREF]
        # -------------------------------------
        # Disable ETP web compat features [FF93+]
        # "privacy.antitracking.enableWebcompat" = false;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # SHUTDOWN & SANITIZING
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Enable Firefox to clear items on shutdown
        "privacy.sanitize.sanitizeOnShutdown" = true;
        #
        # SANITIZE ON SHUTDOWN: IGNORES "ALLOW" SITE EXCEPTIONS | v2 migration is FF128+
        #
        # Set/enforce what items to clear on shutdown
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown_v2.cache" = true; # [FF128+] [DEFAULT: true]
        "privacy.clearOnShutdown.downloads" = true; # [DEFAULT: true]
        "privacy.clearOnShutdown.formdata" = true; # [DEFAULT: true]
        "privacy.clearOnShutdown.history" = true; # [DEFAULT: true]
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true; # [FF128+] [DEFAULT: true]
        "privacy.clearOnShutdown.siteSettings" = true; # [DEFAULT: false]
        "privacy.clearOnShutdown_v2.siteSettings" = true; # [FF128+] [DEFAULT: false]
        # -------------------------------------
        # Set Session Restore to clear on shutdown [FF34+]
        # "privacy.clearOnShutdown.openWindows" = true;
        #
        # SANITIZE ON SHUTDOWN: RESPECTS "ALLOW" SITE EXCEPTIONS FF103+ | v2 migration is FF128+
        #
        # Set "Cookies" and "Site Data" to clear on shutdown
        "privacy.clearOnShutdown.cookies" = true; # Cookies
        "privacy.clearOnShutdown.offlineApps" = true; # Site Data
        "privacy.clearOnShutdown.sessions" = true; # Active Logins [DEFAULT: true]
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = true; # Cookies, Site Data, Active Logins [FF128+]
        #
        # SANITIZE SITE DATA: IGNORES "ALLOW" SITE EXCEPTIONS
        #
        # Set manual "Clear Data" items [FF128+]
        "privacy.clearSiteData.cache" = true;
        "privacy.clearSiteData.cookiesAndStorage" = false; # keep false until it respects "allow" site exceptions
        "privacy.clearSiteData.historyFormDataAndDownloads" = true;
        # "privacy.clearSiteData.siteSettings" = false;
        #
        # SANITIZE HISTORY: IGNORES "ALLOW" SITE EXCEPTIONS | clearHistory migration is FF128+
        #
        # Set manual "Clear History" items = also via Ctrl-Shift-Del
        "privacy.cpd.cache" = true; # [DEFAULT: true]
        "privacy.clearHistory.cache" = true;
        "privacy.cpd.formdata" = true; # Form & Search History
        "privacy.cpd.history" = true; # Browsing & Download History
        # "privacy.cpd.downloads" = true; // not used, see note above
        "privacy.clearHistory.historyFormDataAndDownloads" = true;
        "privacy.cpd.cookies" = false;
        "privacy.cpd.sessions" = true; # [DEFAULT: true]
        "privacy.cpd.offlineApps" = true; # [DEFAULT: false]
        "privacy.clearHistory.cookiesAndStorage" = false;
        # "privacy.cpd.openWindows" = false; // Session Restore
        # "privacy.cpd.passwords" = false;
        # "privacy.cpd.siteSettings" = false;
        # "privacy.clearHistory.siteSettings" = false;
        # -------------------------------------
        #
        # SANITIZE MANUAL: TIMERANGE
        #
        # set "Time range to clear" for "Clear Data" and "Clear History"
        # 0=everything = 1=last hour, 2=last two hours, 3=last four hours, 4=today
        "privacy.sanitize.timeSpan" = 0;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # FPP (fingerprintingProtection)
        # >>>>>>>>>>>>>>>>>>>>>
        # Enable FPP in PB mode [FF114+]
        # "privacy.fingerprintingProtection.pbmode" = true; // [DEFAULT: true FF118+]
        # -------------------------------------
        # Set global FPP overrides [FF114+]
        # "privacy.fingerprintingProtection.overrides" = "";
        # -------------------------------------
        # Disable remote FPP overrides [FF127+]
        # "privacy.fingerprintingProtection.remoteOverrides.enabled" = false;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # RFP (resistFingerprinting)
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Enable RFP
        "privacy.resistFingerprinting" = false; # [FF41+]
        # "privacy.resistFingerprinting.pbmode" = true; // [FF114+]
        # -------------------------------------
        # Set new window size rounding max values [FF55+]
        "privacy.window.maxInnerWidth" = 1400;
        "privacy.window.maxInnerHeight" = 900;
        # -------------------------------------
        # Disable mozAddonManager Web API [FF57+]
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
        # -------------------------------------
        # Enable RFP letterboxing [FF67+]
        # "privacy.resistFingerprinting.letterboxing" = true; // [HIDDEN PREF]
        # "privacy.resistFingerprinting.letterboxing.dimensions" = ""; // [HIDDEN PREF]
        # -------------------------------------
        # Experimental RFP [FF91+]
        # "privacy.resistFingerprinting.exemptedDomains" = "*.example.invalid";
        # -------------------------------------
        # Enable RFP spoof english prompt [FF59+]
        # 0=prompt = 1=disabled, 2=enabled (requires RFP)
        "privacy.spoof_english" = 2;
        # -------------------------------------
        # Disable using system colors
        "browser.display.use_system_colors" = false; # [DEFAULT: false NON-WINDOWS]
        # -------------------------------------
        # Enforce non-native widget theme
        "widget.non-native-theme.enabled" = true; # [DEFAULT: true]
        # -------------------------------------
        # Enforce links targeting new windows to open in a new tab instead
        # 1=most recent window or tab = 2=new window, 3=new tab
        "browser.link.open_newwindow" = 3; # [DEFAULT: 3]
        # -------------------------------------
        # Set all open window methods to abide by "browser.link.open_newwindow"
        "browser.link.open_newwindow.restriction" = 0;
        # -------------------------------------
        # Disable WebGL (Web Graphics Library)
        "webgl.disabled" = true;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # OPTIONAL OPSEC
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Start Firefox in PB (Private Browsing) mode
        # "browser.privatebrowsing.autostart" = true;
        # -------------------------------------
        # Disable memory cache
        # capacity: -1=determine dynamically (default) = 0=none, n=memory capacity in kibibytes
        # "browser.cache.memory.enable" = false;
        # "browser.cache.memory.capacity" = 0;
        # -------------------------------------
        # Disable saving passwords
        # "signon.rememberSignons" = false;
        # -------------------------------------
        # Disable permissions manager from writing to disk [FF41+] [RESTART]
        # "permissions.memory_only" = true; // [HIDDEN PREF]
        # -------------------------------------
        # Disable intermediate certificate caching [FF41+] [RESTART]
        # "security.nocertdb" = true; //
        # -------------------------------------
        # Disable favicons in history and bookmarks
        "browser.chrome.site_icons" = true;
        # -------------------------------------
        # Exclude "Undo Closed Tabs" in Session Restore
        # "browser.sessionstore.max_tabs_undo" = 0;
        # -------------------------------------
        # Disable resuming session from crash
        # "browser.sessionstore.resume_from_crash" = false;
        # -------------------------------------
        # Disable "open with" in download dialog [FF50+]
        # "browser.download.forbid_open_with" = true;
        # -------------------------------------
        # Disable location bar suggestion types
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false; # [FF78+]
        "browser.urlbar.suggest.weather" = false;
        # -------------------------------------
        # Disable location bar dropdown
        # "browser.urlbar.maxRichResults" = 0;
        # -------------------------------------
        # Disable location bar autofill
        "browser.urlbar.autoFill" = false;
        # -------------------------------------
        # Disable browsing and download history
        "places.history.enabled" = false;
        # -------------------------------------
        # Disable Windows jumplist [WINDOWS]
        # "browser.taskbar.lists.enabled" = false;
        # "browser.taskbar.lists.frequent.enabled" = false;
        # "browser.taskbar.lists.recent.enabled" = false;
        # "browser.taskbar.lists.tasks.enabled" = false;
        # -------------------------------------
        # Discourage downloading to desktop
        # 0=desktop = 1=downloads (default), 2=custom
        # "browser.download.folderList" = 2;
        # -------------------------------------
        # Disable Form Autofill
        "extensions.formautofill.addresses.enabled" = false; # [FF55+]
        "extensions.formautofill.creditCards.enabled" = false; # [FF56+]
        # -------------------------------------
        # Limit events that can cause a pop-up
        # "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
        # -------------------------------------
        # Disable page thumbnail collection
        # "browser.pagethumbnails.capturing_disabled" = true; // [HIDDEN PREF]
        # -------------------------------------
        # Disable Windows native notifications and use app notications instead [FF111+] [WINDOWS]
        # "alerts.useSystemBackend.windows.notificationserver.enabled" = false;
        # -------------------------------------
        # Disable location bar using search
        "keyword.enabled" = true;
        # -------------------------------------
        # Force GPU sandboxing (Linux = default on Windows)
        "security.sandbox.gpu.level" = 1;
        # -------------------------------------
        # Enable Site Isolation
        "fission.autostart" = true;
        "gfx.webrender.all" = true;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # OPTIONAL HARDENING
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable MathML (Mathematical Markup Language) [FF51+]
        "mathml.disabled" = true;
        # -------------------------------------
        # Disable in-content SVG (Scalable Vector Graphics) [FF53+]
        # "svg.disabled" = true;
        # -------------------------------------
        # Disable graphite
        "gfx.font_rendering.graphite.enabled" = false;
        # -------------------------------------
        # Disable asm.js [FF22+]
        "javascript.options.asmjs" = false;
        # -------------------------------------
        # Disable Ion and baseline JIT to harden against JS exploits
        "javascript.options.ion" = false;
        "javascript.options.baselinejit" = false;
        "javascript.options.jit_trustedprincipals" = true; # [FF75+] [HIDDEN PREF]
        # -------------------------------------
        # Disable WebAssembly [FF52+]
        "javascript.options.wasm" = false;
        # -------------------------------------
        # Disable rendering of SVG OpenType fonts
        "gfx.font_rendering.opentype_svg.enabled" = false;
        # -------------------------------------
        # Disable widevine CDM (Content Decryption Module)
        "media.gmp-widevinecdm.enabled" = false;
        # -------------------------------------
        # Disable all DRM content (EME: Encryption Media Extension)
        "media.eme.enabled" = false;
        "browser.eme.ui.enabled" = false;
        # -------------------------------------
        # Disable IPv6 if using a VPN
        # "network.dns.disableIPv6" = true;
        # -------------------------------------
        # Control when to send a cross-origin referer
        # * 0=always (default) = 1=only if base domains match, 2=only if hosts match
        # "network.http.referer.XOriginPolicy" = 2;
        # -------------------------------------
        # Set DoH bootstrap address [FF89+]
        # "network.trr.bootstrapAddr" = "10.0.0.1"; // [HIDDEN PREF]
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # DON'T TOUCH
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable Firefox blocklist
        "extensions.blocklist.enabled" = false; # [DEFAULT: true]
        "extensions.blocklist.addonItemURL" = "";
        "extensions.blocklist.detailsURL" = "";
        "extensions.blocklist.itemURL" = "";
        "services.blocklist.addons.collection" = "";
        "services.blocklist.addons.signer" = "";
        "services.blocklist.plugins.collection" = "";
        "services.blocklist.plugins.signer" = "";
        "services.blocklist.gfx.collection" = "";
        "services.blocklist.gfx.signer" = "";
        # -------------------------------------
        # Enforce no referer spoofing
        "network.http.referer.spoofSource" = true; # [DEFAULT: false]
        # -------------------------------------
        # Enforce a security delay on some confirmation dialogs such as install = open/save
        "security.dialog_enable_delay" = 1000; # [DEFAULT: 1000]
        # -------------------------------------
        # Enforce no First Party Isolation [FF51+]
        "privacy.firstparty.isolate" = false; # [DEFAULT: false]
        # -------------------------------------
        # Enforce SmartBlock shims (about:compat) [FF81+]
        "extensions.webcompat.enable_shims" = true; # [HIDDEN PREF] [DEFAULT: true]
        # -------------------------------------
        # Enforce no TLS 1.0/1.1 downgrades
        "security.tls.version.enable-deprecated" = false; # [DEFAULT: false]
        # -------------------------------------
        # Enforce disabling of Web Compatibility Reporter [FF56+]
        "extensions.webcompat-reporter.enabled" = false; # [DEFAULT: false]
        # -------------------------------------
        # Disable Quarantined Domains [FF115+]
        "extensions.quarantinedDomains.enabled" = false; # [DEFAULT: true]
        # -------------------------------------
        # prefsCleaner: previously active items removed from arkenfox 115-117
        # "accessibility.force_disabled" = "";
        # "browser.urlbar.dnsResolveSingleWordsAfterSearch" = "";
        # "network.protocol-handler.external.ms-windows-store" = "";
        # "privacy.partition.always_partition_third_party_non_cookie_storage" = "";
        # "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = "";
        # "privacy.partition.serviceWorkers" = "";
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # DON'T BOTHER
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # Disable APIs
        "geo.enabled" = false;
        # "full-screen-api.enabled" = false;
        # -------------------------------------
        # Set default permissions
        # 0=always ask (default) = 1=allow, 2=block
        "permissions.default.geo" = 2;
        "permissions.default.camera" = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.xr" = 2; # Virtual Reality
        # -------------------------------------
        # Disable canvas capture stream
        "canvas.capturestream.enabled" = false;
        # -------------------------------------
        # Disable offscreen canvas
        "gfx.offscreencanvas.enabled" = false;
        # -------------------------------------
        # Disable non-modern cipher suites
        # "security.ssl3.ecdhe_ecdsa_aes_128_sha" = false;
        # "security.ssl3.ecdhe_ecdsa_aes_256_sha" = false;
        # "security.ssl3.ecdhe_rsa_aes_128_sha" = false;
        # "security.ssl3.ecdhe_rsa_aes_256_sha" = false;
        # "security.ssl3.rsa_aes_128_gcm_sha256" = false; // no PFS
        # "security.ssl3.rsa_aes_256_gcm_sha384" = false; // no PFS
        # "security.ssl3.rsa_aes_128_sha" = false; // no PFS
        # "security.ssl3.rsa_aes_256_sha" = false; // no PFS
        # -------------------------------------
        # Control TLS versions
        # "security.tls.version.min" = 3; // [DEFAULT: 3]
        # "security.tls.version.max" = 4;
        # -------------------------------------
        # Disable SSL session IDs [FF36+]
        # "security.ssl.disable_session_identifiers" = true;
        # -------------------------------------
        # Onions
        # "dom.securecontext.allowlist_onions" = true;
        # "network.http.referer.hideOnionSource" = true;
        # -------------------------------------
        # Referers
        # "network.http.sendRefererHeader" = 2;
        # "network.http.referer.trimmingPolicy" = 0;
        # -------------------------------------
        # Set the default Referrer Policy [FF59+]
        # 0=no-referer = 1=same-origin, 2=strict-origin-when-cross-origin, 3=no-referrer-when-downgrade
        # "network.http.referer.defaultPolicy" = 2; // [DEFAULT: 2]
        # "network.http.referer.defaultPolicy.pbmode" = 2; // [DEFAULT: 2]
        # -------------------------------------
        # Disable HTTP Alternative Services [FF37+]
        # "network.http.altsvc.enabled" = false;
        # -------------------------------------
        # Disable website control over browser right-click context menu
        # "dom.event.contextmenu.enabled" = false;
        # -------------------------------------
        # Disable icon fonts (glyphs) and local fallback rendering
        # "gfx.downloadable_fonts.enabled" = false; // [FF41+]
        # "gfx.downloadable_fonts.fallback_delay" = -1;
        # -------------------------------------
        # Disable Clipboard API
        # "dom.event.clipboardevents.enabled" = false;
        # -------------------------------------
        # Disable System Add-on updates
        "extensions.systemAddon.update.enabled" = false; # [FF62+]
        "extensions.systemAddon.update.url" = ""; # [FF44+]
        # -------------------------------------
        # Enable the DNT (Do Not Track) HTTP header
        "privacy.donottrackheader.enabled" = false;
        # -------------------------------------
        # Customize ETP settings
        # "network.cookie.cookieBehavior" = 5; // [DEFAULT: 5]
        # "privacy.fingerprintingProtection" = true; // [FF114+] [ETP FF119+]
        # "privacy.partition.network_state.ocsp_cache" = true; // [DEFAULT: true FF123+]
        # "privacy.query_stripping.enabled" = true; // [FF101+]
        "privacy.query_stripping.strip_list" = "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid";
        # "network.http.referer.disallowCrossSiteRelaxingDefault" = true;
        # "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true; // [FF100+]
        # "privacy.trackingprotection.enabled" = true;
        # "privacy.trackingprotection.socialtracking.enabled" = true;
        # "privacy.trackingprotection.cryptomining.enabled" = true; // [DEFAULT: true]
        # "privacy.trackingprotection.fingerprinting.enabled" = true; // [DEFAULT: true]
        # -------------------------------------
        # Allow embedded tweets and Reddit posts. Don't do it!
        # "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com"; // [HIDDEN PREF]
        # "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com"; // [HIDDEN PREF]
        # -------------------------------------
        # Disable service workers
        # "dom.serviceWorkers.enabled" = false;
        # -------------------------------------
        # Disable Web Notifications [FF22+]
        # "dom.webnotifications.enabled" = false;
        # -------------------------------------
        # Disable Push Notifications [FF44+]
        "dom.push.enabled" = false;
        "dom.push.connection.enabled" = false;
        "dom.push.serverURL" = "";
        "dom.push.userAgentID" = "";
        # -------------------------------------
        # Disable WebRTC (Web Real-Time Communication)
        "media.peerconnection.enabled" = true;
        # -------------------------------------
        # Enable GPC (Global Privacy Control) in non-PB windows
        # "privacy.globalprivacycontrol.enabled" = true;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # DON'T BOTHER: FINGERPRINTING
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # prefsCleaner: reset items useless for anti-fingerprinting
        # "browser.zoom.siteSpecific" = false;
        # "dom.enable_performance" = false;
        # "dom.enable_resource_timing" = false;
        # "dom.maxHardwareConcurrency" = 2;
        # "font.system.whitelist" = ""; // [HIDDEN PREF]
        # "general.appname.override" = ""; // [HIDDEN PREF]
        # "general.appversion.override" = ""; // [HIDDEN PREF]
        # "general.buildID.override" = "20181001000000"; // [HIDDEN PREF]
        # "general.oscpu.override" = ""; // [HIDDEN PREF]
        # "general.platform.override" = ""; // [HIDDEN PREF]
        # "general.useragent.override" = "Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0"; // [HIDDEN PREF]
        # "media.ondevicechange.enabled" = false;
        # "media.video_stats.enabled" = false;
        # "webgl.enable-debug-renderer-info" = false;
        "ui.use_standins_for_native_colors" = true;
        # "browser.display.use_document_fonts" = 0;
        "device.sensors.enabled" = false;
        "dom.gamepad.enabled" = false;
        "dom.netinfo.enabled" = false;
        "dom.vibrator.enabled" = false;
        "dom.w3c_touch_events.enabled" = 0;
        "dom.webaudio.enabled" = false;
        "media.navigator.enabled" = false;
        "media.webspeech.synth.enabled" = false;
        # -------------------------------------
        # Disable API for measuring text width and height.
        "dom.textMetrics.actualBoundingBox.enabled" = false;
        "dom.textMetrics.baselines.enabled" = false;
        "dom.textMetrics.emHeight.enabled" = false;
        "dom.textMetrics.fontBoundingBox.enabled" = false;
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # NON-PROJECT RELATED
        # >>>>>>>>>>>>>>>>>>>>>
        #
        # WELCOME & WHAT'S NEW NOTICES
        #
        "browser.startup.homepage_override.mstone" = "ignore"; # [HIDDEN PREF]
        "startup.homepage_welcome_url" = "";
        "startup.homepage_welcome_url.additional" = "";
        "startup.homepage_override_url" = ""; # What's New page after updates
        #
        # WARNINGS
        #
        "browser.tabs.warnOnClose" = true; # [DEFAULT: false FF94+]
        "browser.tabs.warnOnCloseOtherTabs" = true;
        "browser.tabs.warnOnOpen" = false;
        "browser.warnOnQuitShortcut" = true; # [FF94+]
        "full-screen-api.warning.delay" = 0;
        "full-screen-api.warning.timeout" = 0;
        "browser.warnOnQuit" = true;
        #
        # UPDATES
        #
        # Disable auto-INSTALLING Firefox updates [NON-WINDOWS]
        "app.update.auto" = false;
        # -------------------------------------
        # Disable auto-CHECKING for extension and theme updates
        "extensions.update.enabled" = false;
        # -------------------------------------
        # Disable auto-INSTALLING extension and theme updates
        "extensions.update.autoUpdateDefault" = false;
        # -------------------------------------
        # Disable extension metadata
        "extensions.getAddons.cache.enabled" = false;
        # -------------------------------------
        # Disable search engine updates (e.g. OpenSearch)
        "browser.search.update" = false;
        #
        # CONTENT BEHAVIOR
        #
        "accessibility.typeaheadfind" = false; # enable "Find As You Type"
        "clipboard.autocopy" = false; # disable autocopy default [LINUX]
        "layout.spellcheckDefault" = 0; # 0=none, 1-multi-line, 2=multi-line & single-line
        #
        # FIREFOX HOME CONTENT
        #
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # Recommended by Pocket
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        #
        # UX FEATURES
        #
        "extensions.pocket.enabled" = false; # Pocket Account [FF46+]
        "extensions.screenshots.disabled" = true; # [FF55+]
        "identity.fxaccounts.enabled" = false; # Firefox Accounts & Sync [FF60+] [RESTART]
        "reader.parse-on-load.enabled" = false; # Reader View
        "browser.tabs.firefox-view" = false; # Firefox-view
        #
        # OTHER
        #
        # "browser.bookmarks.max_backups" = 2;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # disable CFR [FF67+]
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # disable CFR [FF67+]
        "browser.urlbar.showSearchTerms.enabled" = false;
        "browser.sessionstore.interval" = 30000; # minimum interval between session save operations
        "network.manage-offline-status" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.disableResetPrompt" = true; # [HIDDEN PREF]
        # "xpinstall.signatures.required" = false; // enforced extension signing (Nightly/ESR)
        #
        # MORE
        #
        # "security.insecure_connection_icon.enabled" = ""; // [DEFAULT: true FF70+]
        # "security.mixed_content.block_active_content" = ""; // [DEFAULT: true since at least FF60]
        "security.ssl.enable_ocsp_stapling" = false; # [DEFAULT: true FF26+]
        # "webgl.disable-fail-if-major-performance-caveat" = ""; // [DEFAULT: true FF86+]
        "webgl.enable-webgl2" = false;
        # "webgl.min_capability_mode" = "";
        #
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # OTHER
        # >>>>>>>>>>>>>>>>>>>>>
        "general.smoothScroll" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "ui.key.menuAccessKeyFocuses" = false;
        "devtools.toolbox.host" = "right";
      };
    };
  };

  # Path of the source file or directory
  home.file.".mozilla/firefox/Default/extension-preferences.json".source = ./extension-preferences.json;

  # The Firefox profile names to apply styling on
  stylix.targets.firefox.profileNames = [ "Default" ];

  # Environment variables to always set at login
  home.sessionVariables = {
    BROWSER = "${getExe config.programs.firefox.package}";
    PRIVATE_BROWSER = "${getExe config.programs.firefox.package} --private-window";
  };
}
