require 'net/ftp'
require 'rubygems'
require 'zip'

class Drug < ApplicationRecord
  before_create :generate_token
  after_create :get_serts_from_ftp

  IMAGE_TYPES = %w(jpg jpeg gif bmp tiff tif png)
  TMP_PATH = 'public/uploads/tmp/'

  has_and_belongs_to_many :invoices
  has_many :serts

  def to_param
    token
  end

  def create_serts_zip
    file = Zip::OutputStream.write_buffer do |stream|
      serts.each do |sert|
        sert_name = sert.sert.identifier

        stream.put_next_entry("#{sert_name}")

        stream.write IO.read(sert_url(sert))
      end
    end

    file.rewind

    File.new(zip_file_name, 'wb').write(file.sysread)

    zip_file_name
  end

  def create_serts_pdf
    Prawn::Document.generate(pdf_file_name) do |pdf|
      serts.each do |sert|
        pdf.image sert_url(sert), fit: [pdf.bounds.right, pdf.bounds.top]

        pdf.start_new_page unless pdf.page_count == serts.length
      end
    end
    pdf_file_name
  end

private

  def generate_token
    self.token = SecureRandom.hex(4)
  end

  def zip_file_name
    "public/uploads/zip/#{token}_serts.zip"
  end

  def pdf_file_name
    "public/uploads/pdf/#{token}_serts.pdf"
  end

  def sert_url(sert)
    "public#{sert.sert.url}"
  end

  def get_serts_from_ftp
    #Net::FTP.open('192.168.137.237', 'igor', 'Olga') do |ftp|
     Net::FTP.open('91.239.68.66', Rails.application.credentials.ftp.login!, Rails.application.credentials.ftp.password!) do |ftp|
      ftp.chdir(self.sert_path)
      files = ftp.nlst

      files.each_with_index do |file, index|
        file_extension = file.split('.').last

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

