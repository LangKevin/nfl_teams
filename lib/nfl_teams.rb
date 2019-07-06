require "nfl_teams/version"
require 'nokogiri'
require_relative "nfl_teams/cliController"
require_relative "nfl_teams/schedule"
require_relative "nfl_teams/news"
require_relative "nfl_teams/transactions"
require_relative "nfl_teams/team"

# require 'open-uri'


module NflTeams
  class Error < StandardError; end
  # Your code goes here...
end
