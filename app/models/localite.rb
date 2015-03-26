class Localite < ActiveRecord::Base
  def self.find_canton(npa)
    result = self.where('npa = ?', npa.to_s).select(:canton).take
    
    if not result.nil?
      result.canton
    else
      puts npa
      "Undefined"
    end
  end
end
