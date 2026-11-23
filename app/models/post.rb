class Post < ApplicationRecord
  belongs_to :comedian
  belongs_to :user

  validates :content, presence: { message: "おすすめ理由を入力してください"}
  validates :comedian_id, uniqueness: { 
    scope: :user_id,
    message: "既にこの芸人の投稿はされています" 
  }
end
