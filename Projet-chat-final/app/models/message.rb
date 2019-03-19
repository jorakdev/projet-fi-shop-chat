class Message < ApplicationRecord
	validates :contenu, presence: true
	belongs_to :user
end
