# frozen_string_literal: true

class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :receiver, class_name: 'User'
  belongs_to :sender, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  enum read: { read: true, unread: false }

  enum kind: {
    created_event: 0,
    commented_to_event: 1,
    attended_to_event: 2,
    liked_event: 3,
    gender_limited_event_created: 4
  }, _prefix: true

  scope :with_avatar, -> { preload(sender: { avatar_attachment: :blob }) }

  def self.created_event(event, receiver)
    Notification.create!(
      kind: :created_event,
      receiver: receiver,
      sender: event.user,
      notifiable: event,
      read: false,
      message: "#{event.user.name}がイベントを作りました"
    )
  end

  def self.commented_to_event(comment, receiver)
    Notification.create!(
      kind: :commented_to_event,
      receiver: receiver,
      sender: comment.user,
      notifiable: comment,
      read: false,
      message: "#{comment.user.name}がイベント【#{comment.event.title}】にコメントしました"
    )
  end

  def self.attended_to_event(event_attendance, receiver)
    Notification.create!(
      kind: :attended_to_event,
      receiver: receiver,
      sender: event_attendance.user,
      notifiable: event_attendance,
      read: false,
      message: "#{event_attendance.user.name}がイベント【#{event_attendance.event.title}】に参加しました"
    )
  end

  def self.liked_event(bookmark, receiver)
    Notification.create!(
      kind: :liked_event,
      receiver: receiver,
      sender: bookmark.user,
      notifiable: bookmark,
      read: false,
      message: "#{bookmark.user.name}がイベント【#{bookmark.event.title}】をブックマークしました"
    )
  end

  def self.gender_limited_event_created(event, user)
    if event.male_only? || event.female_only?
      Notification.create!(
        kind: :gender_limited_event_created,
        receiver: user,
        sender: event.user,
        notifiable: event,
        read: false,
        message: "#{event.user.name}が性別限定イベントを作りました"
      )
    end
  end

  def path
    return '#' if notifiable.blank?

    case kind.to_sym
    when :created_event, :gender_limited_event_created
      event_path(notifiable)
    when :commented_to_event
      event_path(notifiable.event)
    when :attended_to_event
      event_path(notifiable.event)
    when :liked_event
      event_path(notifiable.event)
    else
      '#' # 未知の種類の通知の場合は '#' を返す（適宜修正してください）
    end
  end
end
