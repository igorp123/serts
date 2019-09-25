class ReadSerts

  FILE_NAME = 'public/invoices.json'

  def self.call
    invoices = self.load_from_json(FILE_NAME)

    abort if invoices.nil?

    invoices.each do |invoice_data|
      invoice = Invoice.where('STRFTIME("%Y", date) = ? and number = ? and inn = ?',
                             Date.parse(invoice_data['date']).year.to_s,
                             invoice_data['number'],
                             invoice_data['inn']).first_or_initialize


     #invoice = Invoice.where("date_part('year', date) = ? and number = ? and inn = ?",
     #                        Date.parse(invoice_data['date']).year.to_s,
     #                        invoice_data['number'],
     #                        invoice_data['inn']).first_or_initialize
      invoice.date = invoice_data['date']
      invoice.number = invoice_data['number']
      invoice.inn = invoice_data['inn']

      invoice.drugs.delete_all

      invoice_data['drugs'].each do |drug_data|
        drug = Drug.where(name: drug_data['name'], serie: drug_data['serie']).first_or_initialize
        drug.name = drug_data['name']
        drug.serie = drug_data['serie']
        drug.sert_path = drug_data['path']

        drug.save!

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

      return
    rescue Errno::ENOENT
      puts 'Не найден файл выгрузки.'
    rescue JSON::ParserError
      puts 'Не правильный формат файла выгрузки'
    end

    abort
  end
end


