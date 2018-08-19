class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]
  before_action :require_loggin, only: [:new, :edit, :show, :destroy]

  def index
    @feeds = Feed.all
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    if params[:back]
      @feed = Feed.new(feed_params)
    else
      @feed = Feed.new
    end
  end

  def edit
  end

  def create
    @feed = Feed.new(feed_params)
    @feed.user_id = current_user.id

    if @feed.save
      FeedMailer.feed_mail(@feed).deliver
      redirect_to feeds_path, notice: "投稿しました！"
    else
      render 'new'
    end
  end
  
  def confirm
    @feed = Feed.new(feed_params)
    @feed.user_id = current_user.id
    render :new if @feed.invalid?
  end 

  def update
      if @feed.update(feed_params)
        redirect_to feeds_path, notice: "編集しました！"
      else
        render 'edit'
      end
  end

  def destroy
    @feed.destroy
    redirect_to feeds_url, notice: "削除しました！"
  end

  private

    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:image, :image_cache, :content)
    end
    
    def require_loggin
      unless logged_in? then
        render new_session_path
      end
    end
    
end
