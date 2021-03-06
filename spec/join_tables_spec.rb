require 'spec_helper'


describe('#recipes_categories_join') do
  it("verifies the association of one recipe with many categories") do
    crappy_foods = Category.create({categ_name: "Junk Food"})
    recipe1 = crappy_foods.recipes.create({rec_name: "cheeseburger"})
    recipe2 = crappy_foods.recipes.create({rec_name: "hamburger"})
    expect(crappy_foods.recipes.order(:rec_name)).to(eq([recipe1, recipe2]))
  end
end

describe('#rec_ing_ammount_join') do
  it("adds recipes and ingredients to amounts table with measurement") do
    cheeseburger = Recipe.create({rec_name:"cheeseburger"})
    beef = Ingredient.create({ing_name: "beef"})
    cheese_beef_amount = Amount.create({recipe_id: cheeseburger.id, ingredient_id: beef.id, measure: "1 patty"})
    expect(cheeseburger.amounts.where(ingredient_id: beef.id)).to(eq([cheese_beef_amount]))

  end
end

describe("#ingredients_for_recipe") do
  it("ensures ingredient information pulled from the database is initialized in the correct form.") do
    cheeseburger = Recipe.create({rec_name:"cheeseburger"})
    beef = Ingredient.create({ing_name: "beef"})
    cheese_beef_amount = Amount.create({recipe_id: cheeseburger.id, ingredient_id: beef.id, measure: "1 patty"})
    cheese = Ingredient.create({ing_name: "cheese"})
    cheese_amount = Amount.create({recipe_id: cheeseburger.id, ingredient_id: cheese.id, measure: "1 slice"})
    ingredient_list = cheeseburger.ingredients
    expect(ingredient_list).to(eq([beef, cheese]))
  end
end

describe("#amounts_for_ingredients_for_recipe") do
  it("checks that amounts are storing and retrieving correctly from join table.") do
    cheeseburger = Recipe.create({rec_name:"cheeseburger"})
    beef = Ingredient.create({ing_name: "beef"})
    cheese_beef_amount = Amount.create({recipe_id: cheeseburger.id, ingredient_id: beef.id, measure: "1 patty"})
    cheese = Ingredient.create({ing_name: "cheese"})
    cheese_amount = Amount.create({recipe_id: cheeseburger.id, ingredient_id: cheese.id, measure: "1 slice"})
    ingredient_list = cheeseburger.ingredients
    amounts = Amount.ing_amounts(cheeseburger.id)
    expect(amounts).to(eq([[beef.id, "1 patty"],[cheese.id, "1 slice"]]))
  end
end

describe("#recipe name thorugh category create") do
  it("check the name of the object made through category") do
    junk = Category.create({categ_name: "junk food"})
    bad = junk.recipes.create({rec_name: "burger", rec_inst: "don't burn it"})
    expect(bad.rec_name).to(eq("burger"))
  end
end

describe('#update recipe') do
  it("checks if recipe can be updated") do
    food = Category.create({categ_name: "food"})
    junk = Category.create({categ_name: "junk"})
    beef = Ingredient.create({ing_name: "beef"})
    cheeseburger = Recipe.create({rec_name:"cheeseburger"})
    cheese_beef_amount = Amount.create({recipe_id: cheeseburger.id, ingredient_id: beef.id, measure: "1 patty"})
    cheeseburger.categories.push(food)
    junk.recipes.push(cheeseburger)
    expect(cheeseburger.categories.order(:categ_name)).to(eq([food, junk]))
  end
end

describe('#deleteing from amounts') do
  it("willdelete a single entry from the eamounts table given two ids") do
    milk = Ingredient.create({ing_name: "milk"})
    pizza = Recipe.create({rec_name:"pizza"})
    milk_pizza = Amount.create({recipe_id: pizza.id, ingredient_id: milk.id, measure: "1 patty"})
    orange = Ingredient.create({ing_name: "cheese"})
    orange_pizza = Amount.create({recipe_id: pizza.id, ingredient_id: orange.id, measure: "1 slice"})
    pizza.ingredients.delete(milk)
    expect(Amount.all).to(eq([orange_pizza]))
  end
end
