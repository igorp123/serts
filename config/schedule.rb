every 1.day, at: '0:15 am' do
  runner "ReadInvoicesFtp.call"
end

every 1.day, at: '0:20 am' do
  runner "ReadSerts.call"
end
