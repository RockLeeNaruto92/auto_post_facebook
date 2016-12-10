require "./helpers/wit_ai_helper"
require "pry"

include WitAiHelper

access_token = "WLICQUYCU3SWUJJX4BEX6MU5KYRBQAHV"
wit_ai_client(access_token).interactive
