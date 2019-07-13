class NflTeams::Team
  @@all = []
  attr_accessor :name, :website, :abbreviation
  attr_reader :schedule, :transactions, :news

  def initialize(name, website, abbreviation)
    @name = name
    @website = website
    @abbreviation = abbreviation
    @@all << self
  end
  def self.sort
    @@all.sort! do |a, b|
      a.name <=> b.name
    end
  end

  def self.fill_teams
    doc = Nokogiri::HTML(open("https://www.espn.com/nfl/teams"))
    teams = doc.css(".mt7").css(".ContentList__Item").css(".pl3")
    teams.each_with_index do |team, index|
      str = "https://www.espn.com" + team.children[0].attributes["href"].value
      idx = str.index("/name/") + 6
      str = str.slice(idx..idx+2).sub("/", "")
      url = "https://www.espn.com" + team.children[0].attributes["href"].value
      NflTeams::Team.new(team.search("h2").children.text, url, str)
    end
    self.sort
  end

  def self.create_and_fill
    self.load_all
  end

  def self.team_by_index(idx)
    @@all[idx]
  end

  def self.load_all
    #load all teams
    @@all = []
    self.fill_teams
  end

  def self.display_teams
    # self.load_all
    @@all.each_with_index do |team, index|
      puts "#{index + 1}. #{team.name} "
      puts "    #{team.website}"
    end
  end

  def schedule
    #lazy load
    if @schedule == nil
      @schedule = NflTeams::Schedule.create_and_fill(self)
    end
    @schedule
  end

  def transactions
    #lazy load
    if @transactions == nil
      @transactions = NflTeams::Transactions.create_and_fill(self)
    end
    @transactions
  end

  def display_transactions
    if transactions != nil
      NflTeams::Transactions.display_transactions
    end
  end

  def news
    #lazy load
    if @news == nil
      @news = NflTeams::News.create_and_fill(self)
    end
    @news
  end

  def display_news
    if news != nil
      NflTeams::News.display_news
    end
  end

  def display_schedule
    if schedule != nil
      NflTeams::Schedule.display_schedule
    end
  end
  #
end
