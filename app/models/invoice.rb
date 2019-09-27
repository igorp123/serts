require 'json'

class Invoice < ApplicationRecord
  before_create :generate_token

  has_and_belongs_to_many :drugs

  validates :number, presence: true, format: { with: /\A[MМPР0-9][0-9]+\z/ }
  validates :date,  presence: true
  validates :inn,  presence: true, length: { is: 10 }, format: { with: /\A[0-9]+\z/}

  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.hex(4)
  end
end
