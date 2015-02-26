class ImportEventsTask
  
  class << self
    
    def import(user_id, token)
                  
      user = User.find(user_id)
      user.is_fetching = true
      user.save!
      
      sleep 20

      user.is_fetching = false
      user.save!
      
    end
    handle_asynchronously :import
    
  end

  
end
