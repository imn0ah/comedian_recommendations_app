require "net/http"
require "json"

class YoutubeService
  def search
    uri = URI("https://www.googleapis.com/youtube/v3/search")

    uri.query = URI.encode_www_form(
      part: "snippet",
      q: "漫才",
      type: "video",
      maxResults: 5,
      key: ENV["YOUTUBE_API_KEY"]
    )

    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
    else
        nil
    end
  end
end
