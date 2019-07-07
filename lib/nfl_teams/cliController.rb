require_relative './team.rb'

class NflTeams::CLIController
  def initialize
    display_intro
  end
  def display_options(idx)
    puts "**********************************************"
    puts "1. To see the lastest transactions type 1"
    puts "2. To see the lastest news blurbs type 2"
    puts "3. To see the schedule and lowest ticket prices please type 3"
    puts "4. To see the full team list again type 4"
    puts "5. To quit type 5."
    puts "**********************************************"
    input = gets.chomp.to_i
    team = NflTeams::Team.team_by_index(idx)
    case input
      when 1
        team.display_transactions
        display_options(idx)
      when 2
        team.display_news
        display_options(idx)
      when 3
        team.display_schedule
        display_options(idx)
      when 4
        Team.display_teams
        display_options(idx)
      when 5
      else
        team.display_news
    end

  end
  def display_intro
    puts "Welcome.  Please select which team you want to select.  Once the team is selected you can choose what you want to see."
    NflTeams::Team.create_and_fill
    NflTeams::Team.display_teams
    idx = gets.chomp.to_i
    display_options(idx-1)
  end
end