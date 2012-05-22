class NewsController < ApplicationController
  before_filter :authorize, :only => [:new, :edit, :create, :update, :destroy]

  def index
    @news = News.paginate :page => params[:page], :per_page => 5
  end

  def show
    @news = News.find params[:id]
  end

  def new
    @news = News.new
  end

  def edit
    @news = News.find params[:id]
  end

  def create
    @news = News.new params[:news]
    @news.player = current_player

    if @news.save
      redirect_to @news, :notice => 'News was successfully created.'
    else
      render :action => :new
    end
  end

  def update
    @news = News.find params[:id]

    if @news.update_attributes params[:news]
      redirect_to @news, :notice => 'News was successfully updated.'
    else
      render :action => :edit
    end
  end

  def destroy
    @news = News.find params[:id]
    @news.destroy

    redirect_to news_index_url, :notice => 'News was successfully deleted.'
  end

  private

  def authorized?
    current_player.try :admin?
  end
end
