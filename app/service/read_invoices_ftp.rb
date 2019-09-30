require 'net/ftp'

class ReadInvoicesFtp
  FILE_NAME = 'public/invoices1.json'
  JSON_FOLDER = 'json'
  FILE = 'invoices.json'

  def self.call
    begin
      Net::FTP.open('91.239.68.66',
                    Rails.application.credentials.dig(:ftp, :login),
                    Rails.application.credentials.dig(:ftp, :password)) do |ftp|

      ftp.chdir(JSON_FOLDER)
      ftp.getbinaryfile(FILE, "#{FILE_NAME}")
    end
    rescue Errno::ETIMEDOUT
      abort 'Не удалось подключиться к ftp серверу'
    end
  end
end
