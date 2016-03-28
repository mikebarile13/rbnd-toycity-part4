module Analyzable
  def average_price(arr)
  	count = 0
  	total = 0.0
  	arr.each do |product|
  		total += product.price.to_f
  		count += 1
  	end
  	return (total/count).round(2)
  end

  def count_by_brand(arr)
  	brands = []
  	arr.each do |product|
  		brands << product.brand
  	end
  	brands.uniq!

  	brands = Hash[*brands.map {|k| [k, 0]}.flatten]

  	arr.each do |product|
  		brands[product.brand] += 1
  	end

  	return brands
  end

  def count_by_name(arr)
  	names = []
  	arr.each do |product|
  		names << product.name
  	end
  	names.uniq!

  	names = Hash[*names.map {|k| [k, 0]}.flatten]

  	arr.each do |product|
  		names[product.name] += 1
  	end

  	return names
  end

  def print_report(arr)

  end

end
