require "wit"
require "pry"
require "fb_graph"

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
    access_token = "EAACEdEose0cBAJEAJXddevAXJnWgy8J3FUzERbUbFsmIT79GwJ9y5zKCQLOEHU1tT8ipZBeAMls951F76jePLZBFKzEOHvxfxa8h77qGJUPen8Ke2MLiitkkq1RfEkr4qPva5jFF2h3cZBgZCLOSukOn7Uvm6mO5OmnB1npJCZAq3wdbBEqKN8jNZBna6rZB2Pl17oZB49RRGMF1gHYnkxxl"
    me = FbGraph::User.me(access_token)
    me.feed!(
      message: status,
      link: link
    )
  end
end
