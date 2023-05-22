# frozen_string_literal: true

class Events::AttendancesController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    
    if @event.female_only? && current_user.gender != "female"
      flash[:alert] = 'このイベントは女性のみ参加可能です'
      redirect_back(fallback_location: root_path)
    else
      event_attendance = current_user.attend(@event)
      (@event.attendees - [current_user] + [@event.user]).uniq.each do |user|
        NotificationFacade.attended_to_event(event_attendance, user)
      end
      flash[:success] = '参加の申込をしました'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    current_user.cancel_attend(@event)
    flash[:success] = '申込をキャンセルしました'
    redirect_back(fallback_location: root_path)
  end
end
