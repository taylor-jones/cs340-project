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


-----------------------------------
-- SELECT
-----------------------------------

-- get a list of all the recipe names
SELECT recipe_id, recipe_name FROM recipe ORDER BY recipe_name;

-- get a list of all the ingredient names
SELECT ingredient_id, ingredient_name FROM ingredient ORDER BY ingredient_name;

-- get a list of all the food group names
SELECT food_group_id, food_group_name FROM food_group ORDER BY food_group_name;

-- get a list of all the dietary restriction names
SELECT dietary_restriction_id, dietary_restriction_name FROM dietary_restriction ORDER BY dietary_restriction_name;

-- get a list of all the unit of measure names
SELECT unit_of_measure_id, unit_of_measure_name FROM unit_of_measure ORDER BY unit_of_measure_name;

-- get a list of all the cuisine names

-- get a list of all the recipe category names




-- get all the data for a single recipe

-- get all recipes matching a specified text search.

-- get all restricted ingredients for a specified dietary restriction

-- get all restricted recipes for a specified dietary restriction

-- get all non-restricted ingredients for a specified dietary restriction

-- get all non-restricted recipes for a specified dietary restriction





-- get all 'liked' recipes for a single user

-- get all 'disliked' recipes for a single user

-- get all created recipes for a single user

-- get a 'random' recipe based on the user's significant recipes and the user options on the 'Recipe Options' form






-----------------------------------
-- INSERT
-----------------------------------

-- add a new ingredient

-- add a new food group

-- add a new food group-dietary restriction

-- add a new dietary restriction

-- add a new recipe-ingredient

-- add a new recipe

-- add a new unit of measure

-- add a new user

-- add user-recipe significance

-- add a new recipe significance type

-- add a new recipe category

-- add a new cuisine





-----------------------------------
-- UPDATE
-----------------------------------

-- update a recipe's data based on submission of the 'Update Recipe' form

-- update a user's data based on submission of the 'Update User' form

-- update a user's significant recipe




-----------------------------------
-- DELETE
-----------------------------------

-- delete a recipe

-- delete a user

-- delete a user's significant recipe