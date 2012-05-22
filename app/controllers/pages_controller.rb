class PagesController < ApplicationController
  def constraints
    @maps = Map.all
  end

  def faq
    @admins = Player.admins
  end
end
