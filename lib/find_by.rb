class Module
  def create_finder_methods(*attributes)
	    attributes.each do |attribute|
	    	new_method = %Q{
			   def find_by_#{attribute}(data)
					products = self.all			
					products.each do |product|
						if product.#{attribute} == data
							data_object = product
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
