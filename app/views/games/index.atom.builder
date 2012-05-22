atom_feed :root_url => games_path do |feed|
  feed.title 'Recent Games'
  feed.updated(@games.first.created_at) unless @games.empty?

  @games.each do |game|
    feed.entry(game) do |entry|
      entry.title game.feed_title
      entry.content game.feed_body, :type => :text
    end
  end
end
