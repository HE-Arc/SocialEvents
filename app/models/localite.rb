class Localite < ActiveRecord::Base
  def self.find_canton(npa)
    result = self.where(npa: npa).select(:canton).take
    
    if not result.nil?
      result.canton
    else
      "Undefined"
    end
  end
end
