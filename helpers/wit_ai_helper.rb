require "wit"
require "pry"
require "koala"

module WitAiHelper
  def actions
    {
      send: -> (request, response) {
        puts("sending... #{response["text"]}")
      },
      rememberLink: -> (request) {
        context = request["context"]
        entities = request["entities"]
        @link = entities["url"].first["value"]
        context["link"] = @link
        return context
      },
      saveStatus: -> (request) {
        @status = request["text"]
        return {}
      },
      postFacebook: -> (request) {
        context = request["context"]
        status = request["entities"]["message_body"].first["value"]
        postFacebook(nil, @link)

        context["answer"] = "Do you want to post to facebook with that status?"
        return request["context"]
      }
    }
  end

  def wit_ai_client access_token
    @client ||= Wit.new(access_token: access_token, actions: actions)
  end

  def postFacebook status, link
    status ||= @status


    graph = Koala::Facebook::API.new facebook_access_token
    # getting groups of interest
    groups = graph.get_connections("me", "groups").select do |group|
      group_names.include? group["name"]
    end

    groups.each_with_index do |group, index|
      puts "[#{index}/#{groups.size}] Posting to group #{group["name"]}."
      graph.put_picture(default_image, {message: generate_message(status, link)},
        group["id"])
    end
  end

  def default_image
    "https://u-rara.jp/wp-content/uploads/2016/09/ThinkstockPhotos-75627078-e1474849735266.jpg"
  end

  def generate_message status, link
    <<-EOS
#{status}

#{link}
    EOS
  end

  def facebook_access_token
    "EAACEdEose0cBAFNVrarPyRu9tFcxNzMSCAoBRZCE2kZB3nP6H2JLZBuPEKtqbSOgQ9r5xZATtUwzzZBlwTvgGuYrI2tdP5Bu6mhvAwvmdB87P1SPc4oIZBVxeNbvorUZCCE1jI4q95vdxnRGPB9gLv6ZB1mBswBfdwV2eviGxj1SBZAhvf4koahSC66ZBvGfWSOVZBwkB6dZC3MBisTZCM43iRZA1h"
  end

  def wit_ai_access_token
    "WLICQUYCU3SWUJJX4BEX6MU5KYRBQAHV"
  end

  def group_names
    ["Test Demo"]
  end
end
