namespace :db do
  desc 'Puts a lot of crap into database'
  task :litter => :environment do
    1.upto(1e3) do |index|
      Player.create! sample_player_hash(index)
    end

    1.upto(3e3) do |index|
      Game.transaction do
        game = Game.new sample_game_hash(index)
        game.teams.build game_teams

        game.teams.each_with_index do |team, i|
          team.sides.build sample_side_hash(i + 1)
        end

        if game.save!
          game.winner = game.players.first
          game.sides.each {|s| s.confirm}
        end
      end
    end
  end

  desc 'Recalculates ratings of sides attached to confirmed games'
  task :recalculate => :environment do
    Game.find_in_batches do |games|
      games.each {|g| g.update_ratings if g.confirmed_cache}
    end
  end

  private

  def game_teams
    [{:name => 'north'}, {:name => 'south'}]
  end

  def players
    @players ||= Player.all
  end

  def random_map
    @maps ||= Map.where(:slots => 2).all
    @maps.shuffle.first
  end

  def sample_game_hash index
    {
      :rby     => [true, false].shuffle.first,
      :turns   => rand(30) + 10,
      :map     => random_map,
      :era     => ['Default', 'RBY No Mirror'].shuffle.first,
      :replay  => "http://replays.wesnoth.org/#{wesnoth_version}/19700101/Game#{index}.gz",
      :title   => "Game#{index}",
      :version => wesnoth_version,
      :chat    => []
    }
  end

  def sample_player_hash index
    {
      :nick                  => "Player#{index}",
      :password              => 'pass11',
      :password_confirmation => 'pass11',
      :avatar                => 'zombie',
      :country               => 'au',
      :timezone              => 'Sydney'
    }
  end

  def sample_side_hash index
    {
      :color   => Color.all.shuffle.first,
      :faction => "Faction#{to_ten}",
      :leader  => "Leader#{to_ten}",
      :number  => index,
      :player  => players.shuffle.first
    }
  end

  def to_ten
    (rand 10) + 1
  end

  def wesnoth_version
    Ladder8::Application.config.wesnoth_version
  end
end
