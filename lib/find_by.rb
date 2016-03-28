class Module
  def create_finder_methods(*attributes)
	    attributes.each do |attribute|
	    	new_method = %Q{
			   def find_by_#{attribute}(data)
			   		data_path = File.dirname(__FILE__) + "/data/data.csv"
					products = CSV.read(data_path)
					header = products[0]
					products.shift
					index = header.find_index("#{attribute}")
					products.each do |product|
						if product[index] == data
							data_object = self.clone(header, product)
							return data_object
						end
					end
			   end
			}
			self.class_eval(new_method)
		end
    end
    Module.create_finder_methods("brand", "name", "price", "id")
end
