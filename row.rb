require "nokogiri"
require "open-uri"
require "json"
class Row
  ATTRS = [
            :artist_name,
            :instagram_input,
            :instagram_handle,
            :instagram_url,
            :instagram_followers,
            :facebook_input,
            :facebook_handle,
            :facebook_url,
            :facebook_followers,
            :twitter_input,
            :twitter_handle,
            :twitter_url,
            :twitter_followers
          ]
  attr_accessor(*ATTRS) 

  def initialize(
                  artist_name_input,
                  instagram_input,
                  facebook_input,
                  twitter_input
                )
    @artist_name = artist_name_input
    @instagram_input = instagram_input
    @instagram_handle = get_handle(instagram_input)
    @instagram_url = normalized_instagram_url
    @instagram_followers = nil
    @facebook_input = facebook_input
    @facebook_handle = get_handle(facebook_input)
    @facebook_url = normalized_facebook_url
    @facebook_followers = nil
    @twitter_input = twitter_input
    @twitter_handle = get_handle(twitter_input)
    @twitter_url = normalized_twitter_url
    @twitter_followers = nil
  end

  def attrs
    instance_variables.map{|ivar| instance_variable_get ivar}
  end

  def get_handle(social_input)
    if social_input && !social_input[/ /]
      social_input.gsub(/\/$/, "").gsub(/.*\//, "").gsub(/@/,"")
    else
      ""
    end
  end

  def normalized_instagram_url
    handle = get_handle(instagram_input)
    handle.empty? ? "" : "http://www.instagram.com/#{handle}"
  end
  
  def normalized_facebook_url
    handle = get_handle(facebook_input)
    handle.empty? ? "" : "http://www.facebook.com/#{handle}"
  end

  def normalized_twitter_url
    handle = get_handle(twitter_input)
    handle.empty? ? "" : "http://www.twitter.com/#{handle}"
  end

  def get_instagram_followers
    begin
      doc = Nokogiri::HTML(open(instagram_url))
    rescue => error
      puts error
      error.message
    else
      content = doc.css("[type='application/ld+json']").text
      begin
        json = JSON.parse(content)
      rescue JSON::ParserError
        return "JSON failed to parse"
      else
        json.dig("mainEntityofPage","interactionStatistic","userInteractionCount").to_i
      end
    end
  end
  
  def get_twitter_followers
    begin
      doc = Nokogiri::HTML(open(twitter_url))
    rescue => error
      puts error
      error.message
    else
      doc.css("[data-nav='followers'] span.ProfileNav-value").text.to_i
    end
  end
  
  def get_facebook_followers
    begin
      doc = Nokogiri::HTML(open(facebook_url))
    rescue => error
      puts error
      error.message
    else
      begin
        doc.css("._6590 ._2pi2+ ._2pi2 div").first.text.gsub(/[^0-9]/,'').to_i
      rescue NoMethodError
        return "No elements matched"
      end
    end
  end

  def scrape_instagram?
    !self.instagram_url.empty? && self.instagram_followers.nil?
  end

  def scrape_twitter?
    !self.twitter_url.empty? && self.twitter_followers.nil?
  end

  def scrape_facebook?
    !self.facebook_url.empty? && self.facebook_followers.nil?
  end
end
