class ImportEventsTask
  
  class << self
    
    def import(user, token)
      Event.destroy_all()
      
      p "trst"
      
      #user.is_fetching = true
      #user.save!
      
      
      #user.is_fetching = false
      #user.save!
    end
    handle_asynchronously :import
    
  end

  
end
