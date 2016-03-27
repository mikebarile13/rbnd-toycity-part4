require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

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
		all_products = []
		products = CSV.read(@@data_path)
		headers = products.shift

		products.each do |row|
			data_object_hash = {}
			headers.each_with_index do |value, index|
				data_object_hash[value.to_sym] = row[index]
			end
			data_object = self.new(data_object_hash)
			all_products << data_object
		end
		
		return all_products
	end

	#Returns first n products in database
	def self.first(num_prods = 1)
		headers = CSV.read(@@data_path)[0]
		products = CSV.read(@@data_path).drop(1).first(num_prods)
		n_products = []

		products.each do |row|
			data_object_hash = {}
			headers.each_with_index do |value, index|
				data_object_hash[value.to_sym] = row[index]
			end
			data_object = self.new(data_object_hash)
			n_products << data_object
		end
		
		if n_products.length == 1
			return n_products[0]
		else return n_products
		end
	end
  
end
