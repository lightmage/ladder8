require 'nokogiri'
require 'open-uri'
require 'replay'

namespace :replays do
  desc "Displays RBY replays from last week"
  task :rby => :environment do
    search_archive 'RBY_Side'
  end

  desc "Displays RMP replays from last week"
  task :rmp => :environment do
    search_archive 'RMPSide'
  end

  private

  def search_archive name
    games   = []
    version = Ladder8::Application.config.wesnoth_version

    0.upto 6 do |d|
      date = d.days.ago.strftime '%Y%m%d'
      doc  = Nokogiri.HTML open("http://replays.wesnoth.org/#{version}/#{date}") rescue break

      doc.css('tr').each do |row|
        link = row.css('td:nth-child(2) > a').first.text rescue nil

        if link and link =~ /gz$/ and row.css('td:last-child').first.text =~ /#{name}/
          games << "http://replays.wesnoth.org/#{version}/#{date}/#{link}"
        end
      end
    end

    games.each do |game|
      begin
        replay = Replay.load game
        puts [game, *replay.players].join(' ')
      rescue
        puts "#{game} ERROR"
      end
    end
  end
end
