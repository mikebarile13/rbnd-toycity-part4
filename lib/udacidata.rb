require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

	@@data_path	= File.dirname(__FILE__) + "/../data/data.csv"
	

	#Create new data object and save to database
	def self.create(attributes = nil)
		data_object = self.new(attributes)

		data_entry = self.create_update_entry(data_object)

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
			data_object = self.clone(headers, row)
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
			data_object = self.clone(headers, row)
			n_products << data_object
		end
		
		if n_products.length == 1
			return n_products[0]
		else return n_products
		end
	end

	#Returns last n products in database
	def self.last(num_prods = 1)
		headers = CSV.read(@@data_path)[0]
		products = CSV.read(@@data_path).drop(1).reverse.first(num_prods)
		n_products = []

		products.each do |row|
			data_object = self.clone(headers, row)
			n_products << data_object
		end
		
		if n_products.length == 1
			return n_products[0]
		else return n_products
		end
	end

	#Find the object at specified location and returns it
	def self.find(loc)
		headers = CSV.read(@@data_path)[0]
		product = CSV.read(@@data_path)[loc]

		data_object = self.clone(headers, product)
		return data_object
	end

	#Destroy the object at specified location
	def self.destroy(loc)
		database = CSV.read(@@data_path)
		headers = database[0]
		product = database[loc]
		database.delete_at(loc)

		CSV.open(@@data_path, 'wb') do |csv|
  			database.each do |row|
  				csv << row
  			end
  		end

		data_object = self.clone(headers, product)
		return data_object
	end

	#Return array containing all products with attribute
	def self.where(attributes={})
		where_arr = []
		database = CSV.read(@@data_path)
		headers = database[0]
		products = database.drop(1)

		attributes.each do |key, value|
			index = headers.find_index(key.to_s)
			products.each do |product|
				if product[index] = value
					data_object = self.clone(headers, product)
					where_arr << data_object
				end
			end
		end

		return where_arr
	end

	def update(opts={})
		database = CSV.read(@@data_path)
		if opts[:brand] != nil; @brand = opts[:brand]; end
		if opts[:name] != nil; @name = opts[:name]; end
		if opts[:price] != nil; @price = opts[:price]; end

		data_entry = []
		data_entry << @id
		data_entry << @brand
		data_entry << @name
		data_entry << @price

		database[@id] = data_entry
		CSV.open(@@data_path, 'wb') do |csv|
  			database.each do |row|
  				csv << row
  			end
  		end

		return self
	end

	def self.create_update_entry(data_object)
		data_entry = []
		data_entry << data_object.id
		data_entry << data_object.brand
		data_entry << data_object.name
		data_entry << data_object.price
		return data_entry
	end

	def self.clone(key_arr, prod_arr)
		data_object_hash = {}
		key_arr.each_with_index do |value, index|
			data_object_hash[value.to_sym] = prod_arr[index]
		end
		data_object = self.new(data_object_hash)
		return data_object
	end

end
