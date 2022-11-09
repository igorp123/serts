require 'net/ftp'
require 'rubygems'
require 'zip'

class Drug < ApplicationRecord
  before_create :generate_token
  after_create :get_serts_from_ftp

  IMAGE_TYPES = %w(jpg jpeg gif bmp tiff tif png)
  TMP_PATH = 'public/uploads/tmp/'
  OUTPUT_PATH = 'public/uploads/'
  FTP_ADDRESS = '91.239.68.66'
  FTP_PATH = 'ftp/serts/'
  FTP_PORT = 121

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

    File.new(output_file_name('zip'), 'wb').write(file.sysread)

    output_file_name('zip')
  end

  def create_serts_pdf
    Prawn::Document.generate(output_file_name('pdf')) do |pdf|
      serts.each do |sert|
        pdf.image sert_url(sert), fit: [pdf.bounds.right, pdf.bounds.top]

        pdf.start_new_page unless pdf.page_count == serts.length
      end
    end
    output_file_name('pdf')
  end

private

  def generate_token
    self.token = SecureRandom.hex(4)
  end

  def output_file_name(type)
    "#{OUTPUT_PATH}/#{type}/#{token}_serts.#{type}"
  end

  def sert_url(sert)
    "public#{sert.sert.url}"
  end

  def get_serts_from_ftp
    begin
      Net::FTP.send(:remove_const, 'FTP_PORT')
      Net::FTP.const_set('FTP_PORT', FTP_PORT)
      Net::FTP.open(FTP_ADDRESS,
          Rails.application.credentials.dig(:ftp_new, :login),
          Rails.application.credentials.dig(:ftp_new, :password)) do |ftp|

        files = get_file_names() #ftp.nlst

        puts files

        files.each_with_index do |file, index|
          file_extension = file.split('.').last

          next if !IMAGE_TYPES.include? file_extension

          local_file_name = "#{TMP_PATH}image_#{index + 1}.#{file_extension}"

          ftp.getbinaryfile(file, local_file_name)

          sert_file = File.open(local_file_name)

          self.serts.build(sert: sert_file).save

          File.delete(local_file_name)
        end

        ftp.close
      end
    rescue Errno::ETIMEDOUT
      abort 'Не удалось подключиться к ftp серверу'
    end
  end

  def get_file_names()
    self.sert_path.split(',').map{|file_name| "#{FTP_PATH}#{file_name}"}
  end
end
