# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @q = Event.future.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(created_at: :desc).page(params[:page])
  end

  def future
    @q = Event.future.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(held_at: :asc).page(params[:page])
    @search_path = future_events_path
    render :index
  end

  def past
    @q = Event.past.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(held_at: :desc).page(params[:page])
    @search_path = past_events_path
    render :index
  end

  def new
    @event = Event.new
  end

  def create
      @event = current_user.events.build(event_params)
      @event.add_category_by_name(params[:category_name])
      @event.male_only = params[:event][:male_only] == "1"
      @event.female_only = params[:event][:female_only] == "1"
    
      if @event.male_only? && @event.female_only?
        flash.now[:alert] = '男性限定と女性限定は同時に選択できません'
        render :new
      elsif @event.male_only? && current_user.gender != "male"
        flash.now[:alert] = 'このイベントは男性のみ参加可能です'
        render :new
      elsif @event.female_only? && current_user.gender != "female"
        flash.now[:alert] = 'このイベントは女性のみ参加可能です'
        render :new
      elsif @event.save
        if @event.male_only? || @event.female_only?
          Notification.gender_limited_event_created(@event, current_user)
        else
          User.all.find_each do |user|
            NotificationFacade.created_event(@event, user)
          end
        end
        redirect_to @event, notice: 'イベントが作成されました'
      else
        flash.now[:alert] = 'イベントの作成に失敗しました。' + @event.errors.full_messages.join('. ')
        render :new
      end
    
  end



  def show
    @event = Event.find(params[:id])
    @categories = @event.categories
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    @event = current_user.events.find(params[:id])
  @event.add_category_by_name(params[:category_name])
  @event.male_only = params[:event][:male_only] == "1"
  @event.female_only = params[:event][:female_only] == "1"

  if @event.male_only? && @event.female_only?
    flash.now[:alert] = '男性限定と女性限定は同時に選択できません'
    render :edit
  elsif @event.male_only? && current_user.gender != "male"
    flash.now[:alert] = 'このイベントは男性のみ参加可能です'
    render :edit
  elsif @event.female_only? && current_user.gender != "female"
    flash.now[:alert] = 'このイベントは女性のみ参加可能です'
    render :edit
  elsif @event.update(event_params)
    redirect_to event_path(@event), notice: 'イベントが更新されました'
  else
    flash.now[:alert] = 'イベントの更新に失敗しました。' + @event.errors.full_messages.join('. ')
    render :edit
  end
end

  private

  def event_params
    params.require(:event).permit(:title, :content, :held_at, :prefecture_id, :thumbnail, :male_only, :female_only, category_ids: [])
  end
end
