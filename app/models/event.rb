# frozen_string_literal: true

class Event < ApplicationRecord
  include Notifiable
  belongs_to :prefecture
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :commented_users, through: :comments, class_name: 'User', source: :user
  has_many :attendances, dependent: :destroy, class_name: 'EventAttendance'
  has_many :attendees, through: :attendances, class_name: 'User', source: :user
  has_many :bookmarks, dependent: :destroy
  has_one_attached :thumbnail
  has_many :categorizations
  has_many :categories, through: :categorizations

  scope :future, -> { where('held_at > ?', Time.current) }
  scope :past, -> { where('held_at <= ?', Time.current) }

  with_options presence: true do
    validates :title
    validates :content
    validates :held_at
  end

  


  def past?
    held_at < Time.current
  end

  def future?
    !past?
  end

  def add_category_by_name(category_name)
    category_name = category_name.strip
    return if category_name.blank?

    category = Category.find_or_create_by(name: category_name)
    categories << category
  end


end
