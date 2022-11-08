require 'net/ftp'

class ReadInvoicesFtp
  FTP_ADDRESS = '91.239.68.66'
  SOURCE_FILE = 'ftp/serts/json/inv_uas.json'
  DESTINATION_FILE = 'public/invoices.json'
  
  def self.call
    begin
      Net::FTP.send(:remove_const, 'FTP_PORT')
      Net::FTP.const_set('FTP_PORT', 121)

      Net::FTP.open(FTP_ADDRESS,
                    Rails.application.credentials.dig(:ftp_new, :login),
                    Rails.application.credentials.dig(:ftp_new, :password)) do |ftp|
        ftp.getbinaryfile(SOURCE_FILE, DESTINATION_FILE)
    end
    rescue Errno::ETIMEDOUT
      abort 'Не удалось подключиться к ftp серверу'
    end
  end
end
