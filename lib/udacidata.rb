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
	def self.find(id)
		self.check_id(id)

		headers = CSV.read(@@data_path)[0]
		products = self.all

		product = nil
		products.each do |row|
			if row.id == id
				product = row
			end
		end

		return product
	end

	#Destroy the object at specified idation
	def self.destroy(id)
		self.check_id(id)

		database = CSV.read(@@data_path)
		headers = database[0]
		product = self.find(id)

		index = 0
		database.each_with_index do |row, ind|
			if id == row[0].to_i
				index = ind
			end
		end

		database.delete_at(index)

		CSV.open(@@data_path, 'wb') do |csv|
  			database.each do |row|
  				csv << row
  			end
  		end

		return product
	end

	#Return array containing all products with attribute
	def self.where(attributes={})
		where_arr = []
		database = CSV.read(@@data_path)
		headers = database[0]
		products = database.drop(1)

		products = products.map! do |product|
			data_object_hash = {}
			headers.each_with_index do |value, index|
				data_object_hash[value.to_sym] = product[index]
			end
			data_object_hash
		end

		products.each do |product|
			add = true
			attributes.each do |key, value|
				if product[key] != value
					add = false
				end
			end
			if add == true
				where_arr << self.new(product)
			end
		end

		return where_arr
	end

	#Update a product's instance variables and the database
	def update(opts={})
		database = CSV.read(@@data_path)
		products = database.drop(1)

		if opts[:brand] != nil; @brand = opts[:brand]; end
		if opts[:name] != nil; @name = opts[:name]; end
		if opts[:price] != nil; @price = opts[:price]; end
		new_entry = [@id, @brand, @name, @price]

		index = 0
		products.each_with_index do |row, ind|
			if row[0].to_i == @id
				index = ind
			end
		end
		index += 1

		database[index] = new_entry
		CSV.open(@@data_path, 'wb') do |csv|
  			database.each do |row|
  				csv << row
  			end
  		end

		return self
	end

	def self.check_id(id)
		if id > self.all.length - 1
			raise UdaciDataErrors::ProductNotFoundError, "ID #{id} invalid"
		elsif id < 1
			raise UdaciDataErrors::ProductNotFoundError, "ID #{id} invalid"
		end

		exists = false
		self.all.each do |product|
			if product.id == id
				exists = true
			end
		end
		
		if exists == false
			raise UdaciDataErrors::ProductNotFoundError, "ID #{id} invalid"
		end		
		
	end

	#Useful method for quickly creating new entry for database
	def self.create_update_entry(data_object)
		data_entry = []
		data_entry << data_object.id
		data_entry << data_object.brand
		data_entry << data_object.name
		data_entry << data_object.price
		return data_entry
	end

	#Creates clone of a product listed in database
	def self.clone(key_arr, prod_arr)
		data_object_hash = {}
		key_arr.each_with_index do |value, index|
			data_object_hash[value.to_sym] = prod_arr[index]
		end
		data_object = self.new(data_object_hash)
		return data_object
	end

end
