require 'net/ftp'

class Drug < ApplicationRecord
  after_create :get_serts_from_ftp

  IMAGE_TYPES = %w(jpg jpeg gif bmp tiff tif)
  TMP_PATH = 'public/uploads/tmp/'

  has_and_belongs_to_many :invoices
  has_many :serts

  private

  def get_serts_from_ftp
    Net::FTP.open('192.168.137.237', 'igor', '') do |ftp|
      ftp.chdir(self.sert_path)

      files = ftp.nlst

      files.each_with_index do |file, index|
        file_extension = file.split('.')[-1]

        if IMAGE_TYPES.include? file_extension
          local_file_name = "#{TMP_PATH}image_#{index + 1}.#{file_extension}"

          ftp.getbinaryfile(file, local_file_name)

          sert_file = File.open(local_file_name)

          self.serts.build(sert: sert_file).save

          File.delete(local_file_name)

        end
      end
      ftp.close
    end
  end
end
