class Sert < ApplicationRecord
  belongs_to :drug

  mount_uploader :sert, SertUploader
end
