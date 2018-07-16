/*
* Meal Wheel DML
* CS340
* Andrew Soback
* Taylor Jones
*/

-- Your submission should contain ALL the queries required to implement ALL the
-- functionalities listed in the Project Specs.

-- It should be possible to add entries to every table individually.
-- Every table should be used in at least one select query.
-- Your website needs to have the ability to search using text or filter using a dynamically populated list of properties to filter on.This search / filter functionality should be present for at least one entity.

-- You need to include one delete function in your website, for any of the entities.
-- You need to include one update function in your website, for any of the entities.
-- It should be possible to add and remove things from at least one many - to - many relationship.
-- It should be possible to add things to all relationships.
-------------------------------------------------------------------

-- ********************************
-- *  SELECTS
-- ********************************


--
----- Basic SELECT queries to populate lists.
--

-- get a list of all the recipe names
SELECT 
  recipe_id, 
  recipe_name 
FROM recipe 
ORDER BY recipe_name;


-- get a list of all the ingredient names
SELECT 
  ingredient_id, 
  ingredient_name 
FROM ingredient 
ORDER BY ingredient_name;


-- get a list of all the food group names
SELECT 
  food_group_id,
  food_group_name 
FROM food_group 
ORDER BY food_group_name;  


-- get a list of all the dietary restriction names
SELECT 
  dietary_restriction_id, 
  dietary_restriction_name 
FROM dietary_restriction 
ORDER BY dietary_restriction_name;


-- get a list of all the unit of measure names
SELECT 
  unit_of_measure_id, 
  unit_of_measure_name 
FROM unit_of_measure 
ORDER BY unit_of_measure_name;


-- get a list of all the cuisine names
SELECT 
  cuisine_id, 
  cuisine_name 
FROM cuisine 
ORDER BY cuisine_name;


-- get a list of all the recipe category names
SELECT 
  recipe_category_id, 
  recipe_category_name 
FROM recipe_category 
ORDER BY recipe_category_name;




--
----- SELECT queries to retrieve data for individual recipes.
--

-- get all the recipe data for a single recipe
SELECT 
  recipe_id, 
  recipe_name, 
  recipe_image, 
  recipe_instructions, 
  recipe_description, 
  user_id, 
  recipe_category_id, 
  created_date
FROM recipe
WHERE recipe_id = [user_selected_recipe_id];


-- get all the recipe-cuisines for a single recipe
SELECT
  c.cuisine_id,
  c.cuisine_name
FROM recipe AS r
  INNER JOIN recipe_cuisine AS rc ON rc.recipe_id = r.recipe_id
  INNER JOIN cuisine AS c ON rc.cuisine_id = c.cuisine_id
WHERE r.recipe_id = [user_selected_recipe_id];


-- get all the recipe-ingredients for a single recipe
SELECT 
  ri.ingredient_id, 
  i.ingredient_name, 
  ri.amount, 
  u.unit_of_measure_name 
FROM recipe_ingredient AS ri 
  INNER JOIN recipe AS r ON ri.recipe_id = r.recipe_id 
  INNER JOIN unit_of_measure AS u ON ri.unit_of_measure_id = u.unit_of_measure_id 
  INNER JOIN ingredient AS i ON ri.ingredient_id = i.ingredient_id 
WHERE ri.recipe_id = [user_selected_recipe_id] 
ORDER BY ri.amount DESC;




--
----- SELECT queries to retrieve search results
--


-- get all recipes matching a specified text search (based on the ingredient name OR recipe name)
SELECT
  ri.recipe_id,
  r.recipe_name
FROM recipe_ingredient AS ri
INNER JOIN recipe AS r ON ri.recipe_id = r.recipe_id
INNER JOIN ingredient AS i ON ri.ingredient_id = i.ingredient_id
WHERE ingredient_name LIKE '%[user_search_input]%' OR recipe_name LIKE '%[user_search_input]%'
GROUP BY r.recipe_id
ORDER BY r.recipe_name;


-- get the total # of resulting ingredients & recipes from a text search
SELECT 
  COUNT(t.recipe_id) AS total_results 
FROM (
  SELECT ri.recipe_id 
  FROM recipe_ingredient AS ri 
    INNER JOIN recipe AS r ON ri.recipe_id = r.recipe_id 
    INNER JOIN ingredient AS i ON ri.ingredient_id = i.ingredient_id 
  WHERE ingredient_name LIKE '%[user_search_input]%' OR recipe_name LIKE '%[user_search_input]%'
  GROUP BY r.recipe_id) AS t




--
----- SELECT queries to retrieve filter results
--

-- get all recipes in a specified recipe_category
SELECT
  r.recipe_id,
  r.recipe_name
FROM recipe AS r
WHERE r.recipe_category_id = [user_selected_recipe_category_id] OR [user_selected_recipe_category_id] IS NULL
ORDER BY r.recipe_name;



-- get all recipes matching a specified cuisine
SELECT 
  rc.recipe_id, 
  r.recipe_name 
FROM recipe_cuisine AS rc
  INNER JOIN recipe AS r ON rc.recipe_id = r.recipe_id 
WHERE rc.cuisine_id = [user_selected_cuisine_id] OR [user_selected_cuisine_id] IS NULL
GROUP BY r.recipe_id 
ORDER BY r.recipe_name;



-- get all recipes containing a specified ingredient id
SELECT 
  ri.recipe_id, 
  r.recipe_name 
FROM recipe_ingredient AS ri 
  INNER JOIN recipe AS r ON ri.recipe_id = r.recipe_id 
  INNER JOIN ingredient AS i ON ri.ingredient_id = i.ingredient_id 
WHERE ri.ingredient_id = [user_selected_ingredient_id] OR [user_selected_ingredient_id] IS NULL
GROUP BY r.recipe_id 
ORDER BY r.recipe_name;



-- get all the recipes containing at least one of the ingredients in a list of ingredient ids
SELECT 
  ri.recipe_id, 
  r.recipe_name 
FROM recipe_ingredient AS ri 
  INNER JOIN recipe AS r ON ri.recipe_id = r.recipe_id 
  INNER JOIN ingredient AS i ON ri.ingredient_id = i.ingredient_id 
WHERE ri.ingredient_id IN ([user_selected_ingredient_id_list]) OR [user_selected_ingredient_id_list] IS NULL
GROUP BY r.recipe_id 
ORDER BY r.recipe_name;



-- get all restricted ingredients for a specified dietary restriction id
SELECT 
  i.ingredient_id, 
  i.ingredient_name 
FROM ingredient AS i 
  INNER JOIN food_group_dietary_restriction AS fd ON i.food_group_id = fd.food_group_id 
  INNER JOIN dietary_restriction AS dr ON fd.dietary_restriction_id = dr.dietary_restriction_id 
WHERE dr.dietary_restriction_id = [user_selected_dietary_restriction_id] -- not using OR IS NULL here, so we don't restrict all ingredients
ORDER BY i.ingredient_name;



-- get all restricted ingredients related to at least one of the dietary restrictions in a list of dietary restriction ids
SELECT 
  i.ingredient_id, 
  i.ingredient_name 
FROM ingredient AS i 
  INNER JOIN food_group_dietary_restriction AS fd ON i.food_group_id = fd.food_group_id 
  INNER JOIN dietary_restriction AS dr ON fd.dietary_restriction_id = dr.dietary_restriction_id 
WHERE dr.dietary_restriction_id IN ([user_dietary_restriction_id_list]) -- not using OR IS NULL here, so we don't restrict all ingredients
ORDER BY i.ingredient_name;



-- get all non-restricted ingredients for a specified dietary restriction id
SELECT 
  ingredient_id, 
  ingredient_name 
FROM ingredient 
WHERE ingredient_id NOT IN (
  SELECT i.ingredient_id 
  FROM ingredient AS i 
    INNER JOIN food_group_dietary_restriction AS fd ON i.food_group_id = fd.food_group_id 
    INNER JOIN dietary_restriction AS dr ON fd.dietary_restriction_id = dr.dietary_restriction_id 
  WHERE dr.dietary_restriction_id = [user_selected_dietary_restriction_id] -- not using OR IS NULL here, so we don't restrict all ingredients
  ORDER BY i.ingredient_name
);



-- get all restricted recipes for a specified dietary restriction id
SELECT 
  ri.recipe_id, 
  r.recipe_name 
FROM recipe_ingredient AS ri 
  INNER JOIN recipe AS r ON ri.recipe_id = r.recipe_id 
  INNER JOIN (
    SELECT i.ingredient_id 
    FROM ingredient AS i 
      INNER JOIN food_group_dietary_restriction AS fd ON i.food_group_id = fd.food_group_id 
      INNER JOIN dietary_restriction AS dr ON fd.dietary_restriction_id = dr.dietary_restriction_id 
    WHERE dr.dietary_restriction_id = [user_selected_dietary_restriction_id] -- not using OR IS NULL here, so we don't restrict all recipes
  ) AS i ON ri.ingredient_id = i.ingredient_id 
GROUP BY r.recipe_id 
ORDER BY r.recipe_name;



-- get all non-restricted recipes for a specified dietary restriction
SELECT 
  recipe_id, 
  recipe_name 
FROM recipe 
WHERE recipe_id NOT IN (
  SELECT ri.recipe_id 
  FROM recipe_ingredient AS ri 
    INNER JOIN recipe AS r ON ri.recipe_id = r.recipe_id 
    INNER JOIN (
      SELECT i.ingredient_id 
      FROM ingredient AS i 
        INNER JOIN food_group_dietary_restriction AS fd ON i.food_group_id = fd.food_group_id 
        INNER JOIN dietary_restriction AS dr ON fd.dietary_restriction_id = dr.dietary_restriction_id 
      WHERE dr.dietary_restriction_id = [user_selected_dietary_restriction_id] -- not using OR IS NULL here, so we don't restrict all recipes
    ) AS i ON ri.ingredient_id = i.ingredient_id 
  GROUP BY r.recipe_id 
  ORDER BY r.recipe_name
);





--
----- SELECT queries to retrieve user-related recipes
--

-- get all 'liked' recipes for a single user
SELECT
  r.recipe_id,
  r.recipe_name
FROM recipe AS r
  INNER JOIN user_significant_recipe AS sr ON sr.recipe_id = r.recipe_id
  INNER JOIN app_user AS u ON u.user_id = [logged_in_user_id]
WHERE sr.recipe_significance_type_id = 1
ORDER BY r.recipe_name;


-- get all 'disliked' recipes for a single user
SELECT
  r.recipe_id,
  r.recipe_name
FROM recipe AS r
  INNER JOIN user_significant_recipe AS sr ON sr.recipe_id = r.recipe_id
  INNER JOIN app_user AS u ON u.user_id = [logged_in_user_id]
WHERE sr.recipe_significance_type_id = 2
ORDER BY r.recipe_name;


-- get all created recipes for a single user
SELECT
  r.recipe_id,
  r.recipe_name
FROM recipe AS r
WHERE r.user_id = [logged_in_user_id]
ORDER BY r.recipe_name;


-- get all recipes not owned by any user
SELECT
  r.recipe_id,
  r.recipe_name
FROM recipe AS r
WHERE r.user_id IS NULL
ORDER BY r.recipe_name;




--
----- SELECT queries to get the 'random' recipe
--

-- get a 'random' recipe based on the user's significant recipes and the user options on the 'Recipe Options' form

/* I think this one is more complicated than the rest. It's going to have to look at multiple factors to
   determine the list of appropriate recipes, like:
   - (if user is signed in), 'liked' or 'disliked' recipes
   - all the recipe options from the UI (i think we need to nail down which options we'll have):
      - recipe category
      - dietary restrictions
      - required ingredients
      - are there others???
   
   Then, it's going to need to take the resulting recipe list above and pick a random item from that list.
*/





-- ********************************
-- *  INSERTS
-- ********************************

-- add a new user
INSERT INTO app_user (user_name, user_email, user_password)
VALUES ([user_name_input], [user_email_input], [user_password_input]);


-- add a new cuisine
INSERT INTO cuisine (cuisine_name)
VALUES [cuisine_input];


-- add a new dietary restriction
INSERT INTO dietary_restriction (dietary_restriction_name)
VALUES [dietary_restriction_input];


-- add a new food group
INSERT INTO food_group (food_group_name)
VALUES [food_group_input];


-- add a new food group-dietary restriction
INSERT INTO food_group_dietary_restriction(food_group_id, dietary_restriction_id)
VALUES ([food_group_id_input], [dietary_restriction_id_input]);


-- add a new ingredient
INSERT INTO ingredient (ingredient_name, food_group_id)
VALUES ([ingredient_name_input], [food_group_id_input]);


-- add a new recipe
INSERT INTO recipe (recipe_name, recipe_image, recipe_instructions, recipe_description, user_id, recipe_category_id)
VALUES ([recipe_name_input], [recipe_image_input], [recipe_instructions_input], [recipe_description_input], [user_id_input], [recipe_category_input]);


-- add a new recipe category
INSERT INTO recipe_category (recipe_category_name)
VALUES [recipe_category_input];


-- add a new recipe cuisine
INSERT INTO recipe_cuisine(recipe_id, cuisine_id)
VALUES ([recipe_id_input], [cuisine_id_input]);


-- add a new recipe-ingredient
INSERT INTO recipe_ingredient(recipe_id, ingredient_id, amount, unit_of_measure_id)
VALUES ([recipe_id_input], [ingredient_id_input]);


-- add a new recipe significance type
INSERT INTO recipe_significance_type (recipe_significance_type_name)
VALUES [recipe_significance_type_input];


-- add a new unit of measure
INSERT INTO unit_of_measure (unit_of_measure_name, unit_of_measure_abbrev)
VALUES ([unit_of_measure_name_input], [unit_of_measure_abbrev_input]);


-- add user-recipe significance
INSERT INTO user_significant_recipe (user_id, recipe_id, recipe_significance_type_id)
VALUES ([user_id_input], [recipe_id_input], [recipe_significant_type_id_input]);






-- ********************************
-- *  UPDATES
-- ********************************

-- update a recipe record based on submission of the 'Update Recipe' form
UPDATE recipe SET
  recipe_name = [recipe_name_input],
  recipe_image = [recipe_image_input],
  recipe_instructions = [recipe_instructions_input],
  recipe_description = [recipe_description_input],
  user_id = [user_id_input],
  recipe_category_id = [recipe_category_input]
WHERE recipe_id = [recipe_id_from_update_form];


-- update a recipe-cuisine record based on submission of the 'Update Recipe' form
UPDATE recipe_cuisine SET
  recipe_id = [recipe_id_input],
  cuisine_id = [cuisine_id_input]
WHERE recipe_id = [recipe_id_from_update_form] 
AND cuisine_id = [cuisine_id_from_update_form];


-- update a recipe-ingredient record based on submission of the 'Update Recipe' form
UPDATE recipe_ingredient SET
  recipe_id = [recipe_id_input],
  ingredient_id = [ingredient_id_input],
  amount = [amount_input],
  unit_of_measure_id = [unit_of_measure_id_input]
WHERE recipe_id = [recipe_id_from_update_form] 
AND ingredient_id = [ingredient_id_from_update_form];


-- update a user's data based on submission of the 'Update User' form
UPDATE app_user SET
  user_name = [user_name_input],
  user_email = [user_email_input],
  user_password = [user_password_input]
WHERE user_id = [user_id_from_update_form];


-- update a user significant recipe record.
UPDATE user_significant_recipe SET
  user_id = [user_id_input],
  recipe_id = [recipe_id_input],
  recipe_significance_type_id = [recipe_significance_type_id_input]
WHERE user_id = [logged_in_user_id] 
AND recipe_id = [selected_recipe_id];





-- ********************************
-- *  DELETE
-- ********************************

-- delete a recipe

-- delete a recipe-ingredient

-- delete a recipe cuisine

-- delete a user 

-- delete a user's significant recipe