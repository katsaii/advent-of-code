data = File.read("in/day_21.txt")
labels = data
        .scan(/\s*(.+)\s+\(\s*contains\s+(.+)\)\s*\n/)
        .map{|x| [x[0].split(/\s+/), x[1].split(/,\s*/)]}
allergen_ingredients = { }
labels.each do |label|
    ingredients = label[0]
    allergens = label[1]
    allergens.each do |allergen|
        if allergen_ingredients.has_key?(allergen)
            allergen_ingredients[allergen] &= ingredients
        else
            allergen_ingredients[allergen] = ingredients
        end
    end
end
all_ingredients, all_allergens = labels.transpose.map{|x| x.flatten}
safe_ingredients = all_allergens.uniq
        .reduce(all_ingredients.uniq){|acc, x| acc - allergen_ingredients[x]}
safe_ingredient_count = all_ingredients
        .filter{|x| safe_ingredients.include?(x)}
        .length
ingredient_allergens = { }
loop do
    allergen, ingredients = allergen_ingredients
            .find{|_, ingredients| ingredients.length == 1}
    if not allergen
        break
    end
    ingredient = ingredients[0]
    ingredient_allergens[ingredient] = allergen
    allergen_ingredients
            .transform_values!{|x| x - ingredients}
end
unsafe_ingredients = ingredient_allergens
        .sort_by{|_, allergen| allergen}
        .map{|ingredient, _| ingredient}
puts "safe ingredient count\n#{safe_ingredient_count}"
puts "\nthe list of unsafe ingredients\n#{unsafe_ingredients.join(",")}"
