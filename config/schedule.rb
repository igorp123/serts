every 1.hours, at: '0:10 am' do
  runner "ReadInvoicesFtp.call"
end

every 1.hours, at: '0:15 am' do
  runner "ReadSerts.call"
end
