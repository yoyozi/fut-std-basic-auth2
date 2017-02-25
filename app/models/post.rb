# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

class Post < ActiveRecord::Base

  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :user_id, presence: true

  def to_s
    title
  end

end
