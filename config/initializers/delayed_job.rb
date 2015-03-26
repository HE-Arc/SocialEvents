# Logs
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_jobs.log'))