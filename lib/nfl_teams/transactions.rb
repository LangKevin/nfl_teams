require_relative './Concerns/Fillable.rb'

class NflTeams::Transactions
  extend Concerns::Fillable
  @@all = []
  attr_accessor :note
  attr_reader :team, :date
  def self.all
    @@all
  end
  def initialize(team, date, note)
    @team = team
    @date = date
    @note = note
    @@all << self
  end
  def self.load_all(team)
    all = []
    url = "https://www.espn.com/nfl/team/transactions/_/name/#{team.abbreviation}"
    doc = Nokogiri::HTML(open(url))
    trans = doc.css(".transactions-table").css(".Table2__table__wrapper").css(".Table2__td")
    cnt = 1
    transaction = nil
    trans.each do |tran|
      cnt = cnt + 1
      if cnt%2 == 0
        transaction = NflTeams::Transactions.new(team, tran.search("span").children.text, "a")
      elsif (transaction != nil)
        transaction.note = tran.search("span").children.text
      end
    end
  end
  def self.display_transactions
    all.each_with_index do |transaction, index|
      puts "#{index + 1}. #{transaction.date}"
      puts "   #{transaction.note}"
    end
  end
end
