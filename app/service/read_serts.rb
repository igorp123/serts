class ReadSerts

  FILE_NAME = 'public/invoices1.json'

  def self.call
    invoices = self.load_from_json(FILE_NAME)

    invoices.each do |invoice_data|
     invoice = Invoice.where(number: invoice_data['number'], date: invoice_data['date'],
                             inn: invoice_data['inn']).first_or_initialize

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
    file = File.read(file_name, encoding: 'utf-8')

    json_file = JSON.parse(file)
  end
end


