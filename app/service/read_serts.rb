class ReadSerts
  FILE_NAME = 'public/invoices.json'

  def self.call
    invoices = load_from_json(FILE_NAME)

    abort if invoices.nil?

    invoices.each do |invoice_data|
      abort if invoice_data.nil?

      invoice = self.set_invoice_query(invoice_data)

      invoice.date = invoice_data['date']
      invoice.number = invoice_data['number']
      invoice.inn = invoice_data['inn']

      invoice.drugs.delete_all

      invoice_data['drugs'].each do |drug_data|
        drug = set_drug_query(drug_data)

        drug.name = drug_data['name']
        drug.serie = drug_data['serie']
        drug.sert_path = drug_data['path']

        drug.save!

        if drug.serts.count < drug.get_file_names.count
          drug.serts.destroy_all

          puts '#{drug.serts.count} | #{drug.get_file_names.count}'
          drug.get_serts_from_ftp
        end

        invoice.drugs << drug
      end

      invoice.save!
      end
  end

  private

  def self.load_from_json(file_name)
    begin
      file = File.read(file_name, encoding: 'utf-8')

      json_file = JSON.parse(file)
    rescue Errno::ENOENT
      abort 'Не найден файл выгрузки.'
    rescue JSON::ParserError
      abort 'Не правильный формат файла выгрузки'
    end
  end

  def self.set_invoice_query(invoice_data)
    date_string = if ENV['RAILS_ENV'] == 'production'
                    "date_part('year', date)"
                  else
                    "STRFTIME('%Y', date)"
                  end

    Invoice.where("#{date_string} = ? and number = ? and inn = ?",
                  Date.parse(invoice_data['date']).year.to_s,
                  invoice_data['number'],
                  invoice_data['inn']).first_or_initialize
  end

  def self.set_drug_query(drug_data)
    Drug.where(name: drug_data['name'], serie: drug_data['serie']).first_or_initialize
  end
end
