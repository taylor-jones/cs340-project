const express = require('express');
const router = express.Router();

const cuisines = require('../data/cuisines.json');
const categories = require('../data/recipe-categories.json');
const diets = require('../data/dietary-restrictions.json');
const recipes = require('../data/recipes.json');

/* GET browse page. */
router.get('/', (req, res, next) => {
  res.render('browse', {
    page: 'Browse Recipes',
    menuId: 'browse',
    cuisines: cuisines,
    categories: categories,
    diets: diets,
    recipes: recipes,
  });
});

module.exports = router;