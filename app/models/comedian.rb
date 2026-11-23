class Comedian < ApplicationRecord
    has_many :posts
    validates :name, presence: { message: "芸人名を入力してください" }, uniqueness: true
end
