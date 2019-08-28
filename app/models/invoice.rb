require 'json'

class Invoice < ApplicationRecord
  before_create :generate_token

  has_and_belongs_to_many :drugs

  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.hex(4)
  end
end
