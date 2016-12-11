require "./helpers/wit_ai_helper"
require "pry"

include WitAiHelper

wit_ai_client(wit_ai_access_token).interactive
