require 'net/ftp'

class ReadInvoicesFtp
  FILE_NAME = 'public/invoices.json'
  JSON_FOLDER = 'json'
  FILE = 'inv_uas.json'

  def self.call
    begin
      # 91.239.68.66
      Net::FTP.open('192.168.137.40',
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
