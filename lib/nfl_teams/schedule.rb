require_relative './Concerns/Fillable.rb'
class NflTeams::Schedule
  extend Concerns::Fillable
  attr_accessor :week, :day, :team, :network, :ticketPrice, :ticketSite
  @@all = []
  def self.load_all(team)
    @@all = []
    url = "https://www.espn.com/nfl/team/schedule/_/name/#{team.abbreviation}"
    doc = Nokogiri::HTML(open(url))
    cssSched = doc.css(".Table2__td")
    cnt = 0
    week = 0
    sched = nil
    cssSched.each do |schedule|
      cnt = cnt + 1
      if cnt > 8
          if (schedule.attributes["class"].value == "Table2__td") &&
             !(schedule.children == nil) && !(schedule.children.size < 1) && !(schedule.children[0].attributes == nil)
              (schedule.children[0].respond_to?('text'))
            day = schedule.children[0].text
            if day.match? /Sun|Mon|Thu|Fri|Sat/
              sched = NflTeams::Schedule.new
              week = week + 1
              sched.week = week
              sched.day = day
            end
          end
          if (schedule.css(".pr2").size > 0)
            sched.team = schedule.css(".pr2").children[1].children[0]["title"]
          end
          if (schedule.css(".network-container").size > 0)
            sched.network = schedule.css(".network-container").children[0].children.text
          end
          if (schedule.css(".Schedule__ticket").size > 0)
            sched.ticketPrice = schedule.css(".Schedule__ticket").children[0]
            sched.ticketSite = schedule.children[0].attributes["href"].value
          end
      end
    end
  end
  def initialize
    @@all << self
  end
  def self.display_schedule
    @@all.each_with_index do |schedule, index|
      if index < 16
        if schedule.week
          puts "Week: #{schedule.week + 1}"
        end
      elsif 
        if schedule.week
          puts "Preseason Week: #{index - 15} "
        end
      end  

      if schedule.day
        puts "   Day: #{schedule.day}"
      end
      if schedule.team
        puts "   Team: #{schedule.team}"
      end
      if schedule.network
        puts "   Network: #{schedule.network}"
      end
      if schedule.ticketPrice
        puts "   Ticket Price: #{schedule.ticketPrice}"
      end
      if schedule.ticketSite
        puts "   Ticket Site: #{schedule.ticketSite}"
      end
    end
  end
end