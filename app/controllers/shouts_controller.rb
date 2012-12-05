class ShoutsController < ApplicationController
  before_filter :require_user

  def new
    @shout = Shout.new
  end

  def create
    @shout = Shout.new(params[:shout])
    @shout.user = current_user
    if @shout.save
      logger.info "#{@shout.user.username} just posted a shout: #{@shout.content}"
      redirect_to shouts_path
    else
      logger.fatal "#{@shout.errors.inspect}"
      render :new
    end
  end

  def index
    if params[:from].to_s.downcase.strip == 'all'
      @shouts = Shout.order('created_at DESC').paginate(:per_page => 20, :page => params[:page])
    else
      user_ids = [current_user.id] + current_user.follows.collect(&:id)
      @shouts = Shout.where('user_id IN (?)', user_ids.uniq).paginate(:per_page => 20, :page => params[:page])
    end
  end
end
