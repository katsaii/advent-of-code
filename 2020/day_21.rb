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
puts allergen_ingredients
puts safe_ingredient_count
