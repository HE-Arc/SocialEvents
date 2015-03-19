class Localite < ActiveRecord::Base
  def self.find_canton(npa)
    self.where(npa: npa).select(:canton).take.canton
  end
end
