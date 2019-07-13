class NflTeams::News
  extend Concerns::Fillable
  @@all = []
  attr_reader :team, :author, :note
  def self.load_all(team)
    @@all = []
    doc = Nokogiri::HTML(open(team.website))
    news = doc.css(".news-feed-shortstop").css(".bloom-content")
    newsItem = nil
    news.each do |newsItem|
      nw = NflTeams::News.new(team, newsItem.children[1].text, newsItem.children[2].text)
    end
  end
  def initialize(team, author, note)
    @team = team
    @author = author
    @note = note
    @@all << self
  end
  def self.display_news
    @@all.each_with_index do |news, index|
      puts "#{index + 1}. #{news.author}"
      puts "   #{news.note}"
    end
  end
end
