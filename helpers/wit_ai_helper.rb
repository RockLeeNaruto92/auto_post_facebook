require "wit"
require "pry"

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
        postFacebook(status, @link)

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
    puts "post status: #{status} and link"
  end
end
