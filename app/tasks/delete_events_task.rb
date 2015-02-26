class DeleteEventsTask
  
  include Delayed::RecurringJob
  run_every 1.day
  run_at '00:05'
  timezone 'Bern'
  queue 'slow-jobs'
  
  def perform
    Event.purge_events()
  end
    
end
