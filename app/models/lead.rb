class Lead < ApplicationRecord
  validates :from, presence: true
  validates :to, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
end
