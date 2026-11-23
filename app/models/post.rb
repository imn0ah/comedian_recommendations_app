class Post < ApplicationRecord
  belongs_to :comedian
  belongs_to :user

  validates :content, presence: true
  validates :comedian_id, uniqueness: { scope: :user_id }
end
