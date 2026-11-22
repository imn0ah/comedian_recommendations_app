class Comedian < ApplicationRecord
    validates :name, presence: true, uniqueness: true
end
