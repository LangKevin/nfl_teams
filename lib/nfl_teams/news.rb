require_relative './Concerns/Fillable.rb'
class NflTeams::News
  extend Concerns::Fillable
  @@all = []
  attr_reader :team, :author, :note
  def self.all
    @@all
  end
  def self.load_all(team)
    self.clear_all
    doc = Nokogiri::HTML(open(team.website))
    news = doc.css(".news-feed-shortstop").css(".bloom-content")
    newsItem = nil
    news.each do |newsItem|
      nw = NflTeams::News.new(team, newsItem.children[1].text, newsItem.children[2].text)
    end
  end
  def self.clear_all
    all = []
  end
  # def self.create_and_fill(team)
  #   self.load_all(team)
  # end
  def initialize(team, author, note)
    @team = team
    @author = author
    @note = note
    @@all << self
  end
  def self.display_news
    cnt = 1
    all.each do |news|
      puts "#{cnt}. #{news.author}"
      puts "   #{news.note}"
      cnt = cnt + 1
    end
  end
end
