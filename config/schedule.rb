every 1.day, :at => '00:01 am' do
  runner 'CheckIdleCustomerWorker.perform_async'
end