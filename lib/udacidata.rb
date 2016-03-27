require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

	@@all_products = []
	@@data_path	= File.dirname(__FILE__) + "/../data/data.csv"
	

	#Create new data object and save to database
	def self.create(attributes = nil)
		data_object = self.new(attributes)

		data_entry = []
			data_entry << data_object.id
			data_entry << data_object.brand
			data_entry << data_object.name
			data_entry << data_object.price

  		CSV.open(@@data_path, 'a') do |csv|
  			csv << data_entry
  		end

		return data_object
	end

	#Return array of all products 
	def self.all
		@@all_products = []
		products = CSV.read(@@data_path)
		headers = products.shift

		products.each do |row|
			data_object_hash = {}
			headers.each_with_index do |value, index|
				data_object_hash[value] = row[index]
			end
			data_object = self.new(data_object_hash)
			@@all_products << data_object
		end
		
		return @@all_products
	end

	#Returns first product in all_products array
	def self.first
		return @@all_products[0]
	end




  
end
