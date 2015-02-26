class DeleteEventsTask
  include Delayed::RecurringJob
  
  run_every 60.second
  run_at '05:00pm'
  timezone 'Bern'
  queue 'slow-jobs'
  
  def perform
    Event.purge_events()
    p "perform"
  end
end
