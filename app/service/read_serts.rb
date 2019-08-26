class ReadSerts

  FILE_NAME = 'public/invoices.json'

  def self.call
    invoices = self.load_from_json(FILE_NAME)

    invoices.each do |invoice_data|
     i = Invoice.where(number: invoice_data['invoice'], inn: invoice_data['inn']).first_or_initialize
     i.number = invoice_data['invoice']
     i.inn = invoice_data['inn']

      invoice_data['drugs'].each do |drug|
        d = Drug.where(name: drug['name'], serie: drug['serie']).first_or_initialize
        d.name = drug['name']
        d.serie = drug['serie']
        d.sert_path = drug['path']
        d.save!

        i.drugs << d if i.drugs.find_by(id: d.id).blank?
      end
      i.save!
    end
  end

  private

  def self.load_from_json(file_name)
    file = File.read(file_name, encoding: 'utf-8')

    json_file = JSON.parse(file)
  end
end


