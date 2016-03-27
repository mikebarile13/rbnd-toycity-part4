require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

	@@all_products = []
	@@data_path = File.dirname(__FILE__) + "/../data/data.csv"

	#Create new data object and save to database
	def self.create(attributes = nil)
  		CSV.open(@@data_path, 'a+') do |csv|
  			csv << attributes.values
  		end

		data_object = self.new(attributes)
		@@all_products << data_object
		return data_object
	end

	#Return array of all products 
	def self.all
		return @@all_products
	end

	#Returns first product in all_products array
	def self.first
		return @@all_products[0]
	end




  
end
