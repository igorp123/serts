class Drug < ApplicationRecord
  has_and_belongs_to_many :invoices
  has_many :serts
end
