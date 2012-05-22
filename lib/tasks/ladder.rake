require 'date'
require 'nokogiri'
require 'open-uri'

namespace :ladder do
  desc 'Displays results of ladder games'
  task :results => :environment do
    games = retrieved = retrieve_games

    while not retrieved.empty?
      oldest_date = retrieved.last.first

      if parameterize oldest_date
        retrieved = retrieve_games oldest_date
        retrieved.reject! {|game| games[-10,10].include? game}

        games += retrieved
      else
        retrieved = []
      end
    end

    games.reverse.each do |game|
      date, winner, loser = game
      puts "#{winner};#{loser}"
    end
  end

  private

  def parameterize date
    return nil unless date

    limit  = DateTime.civil 2007, 9, 20
    before = DateTime.strptime("#{date}", '%Y-%m-%d %H:%M:%S') rescue (return nil)

    before > limit ? before.strftime('%Y-%m-%d+%H%%3A%M%%3A%S') : nil
  end

  def prepare_url date
    url  = 'http://wesnoth.gamingladder.info/gamehistory.php'
    date ? "#{url}?reporteddirection=%3C%3D&reportdate=#{date}" : url
  end

  def process_games url
    games = Nokogiri.HTML(open url).css('#games tbody tr').collect do |game|
      game.children.collect{|td| td.content}[0,3]
    end

    games.reject do |game|
      "#{game[1]} #{game[2]}".include? '*'
    end
  end

  def retrieve_games before = nil
    before    = parameterize before
    games_url = prepare_url before

    process_games games_url
  end
end
