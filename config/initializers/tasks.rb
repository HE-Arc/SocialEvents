# Be sure to restart your server when you modify this file.

# Remove old events
begin
  DeleteEventsTask.schedule!
rescue
  # if failing, the delayed jobs table couldn't be found... we can't do anything more!
end
