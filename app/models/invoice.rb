require 'json'

class Invoice < ApplicationRecord
  has_and_belongs_to_many :drugs

end
