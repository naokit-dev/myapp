require 'addressable/uri'

module TweetHelper
  def TweetUriEncord(text:, url: "", hashtags: "")
    twi_uri = 'https://twitter.com/intent/tweet'
    uri = Addressable::URI.parse(twi_uri)
    uri.query_values = {text: text, url: url, hashtags: hashtags}
    uri.normalize.to_s
  end
end
