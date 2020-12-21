require "fileutils"

data = File.read("in/day_21.txt")
labels = data.scan(/\s*(.+)\s+\(\s*contains\s+(.+)\)\s*\n/).map do |x|
    [x[0].split(/\s+/), x[1].split(/,\s*/)]
end
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
all_ingredients, all_allergens = labels.transpose.map do |x|
    x.flatten
end
safe_ingredients = all_allergens.uniq.reduce(all_ingredients.uniq) do |acc, x|
    acc - allergen_ingredients[x]
end
safe_ingredient_count = all_ingredients.filter do |x|
    safe_ingredients.include?(x)
end.length
ingredient_allergens = { }
loop do
    allergen, ingredients = allergen_ingredients.find do |key, value|
        value.length == 1
    end
    if not allergen
        break
    end
    ingredient = ingredients[0]
    ingredient_allergens[ingredient] = allergen
    allergen_ingredients.transform_values! do |x|
        x - ingredients
    end
end
unsafe_ingredients = ingredient_allergens.sort_by do |_, allergen|
    allergen
end.map do |ingredient, _|
    ingredient
end
puts safe_ingredient_count
puts unsafe_ingredients.join(",")
