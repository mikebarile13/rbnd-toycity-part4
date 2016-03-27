require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

	def self.create(attributes = nil)
	  
		data_path = File.dirname(__FILE__) + "/../data/data.csv"
	  
  		CSV.open(data_path, 'a+') do |csv|
  			csv << [attributes.values]
  		end

		data_object = self.new(attributes)
		return data_object

	end





  
end
