module Analyzable
  def average_price(arr)
  	count = 0
  	total = 0.0
  	arr.each do |product|
  		total += product.price.to_f
  		count += 1
  	end
  	return count
  end
end
