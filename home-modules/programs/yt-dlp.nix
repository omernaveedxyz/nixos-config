{
  programs.yt-dlp = {
    # Whether to enable yt-dlp
    enable = true;

    # Configuration written to $XDG_CONFIG_HOME/yt-dlp/config
    settings = {
      # Abort downloading of further videos if an error occurs
      abort-on-error = true;

      # Download the playlist, if the URL refers to a video and a playlist
      yes-playlist = true;

      # Number of fragments of a dash/hlsnative video that should be downloaded
      concurrent-fragments = 8;

      # Number of retries (default is 10), or "infinite"
      retries = "infinite";

      # Number of times to retry on file access error
      file-access-retries = "infinite";

      # Number of retries for a fragment
      fragment-retries = "infinite";

      # Output filename template; see "OUTPUT TEMPLATE" for details
      output = "~/Videos/%(title)s.%(ext)s";

      # Do not overwrite any files
      no-overwrites = true;

      # Video format code, see "FORMAT SELECTION" for more details
      format-sort = "+hdr,fps:30,res:1080";

      # Languages of the subtitles to download
      sub-langs = "all,-live_chat";

      # Embed subtitles in the video
      embed-subs = true;

      # Embed  metadata  to the video file
      embed-metadata = true;

      # Number of retries for known extractor errors
      extractor-retries = "infinite";
    };
  };
}
