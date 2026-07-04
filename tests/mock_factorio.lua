-- Simulation de l'environnement Factorio pour les tests unitaires
_G.pyem = {}
_G.data = {
    raw = { recipe = {} },
    extend = function(self, tbl)
        for _, obj in ipairs(tbl) do
            if obj.type then
                self.raw[obj.type] = self.raw[obj.type] or {}
                self.raw[obj.type][obj.name] = obj
            end
        end
    end
}
_G.settings = { startup = {} }
_G.log = function(msg) end

-- Mock de la fonction RECIPE (Factory pattern)
_G.RECIPE = function(name)
    if not data.raw.recipe[name] then
        data.raw.recipe[name] = { name = name, ingredients = {} }
    end
    local r = data.raw.recipe[name]
    
    local obj = {}
    function obj:is_valid()
        return true
    end
    function obj:add_ingredient(ing)
        table.insert(r.ingredients, ing)
        return self
    end
    function obj:clear_ingredients()
        r.ingredients = {}
        return self
    end
    return obj
end

-- Mock de la fonction ITEM (Factory pattern)
_G.ITEM = function(name)
    data.raw.item = data.raw.item or {}
    if not data.raw.item[name] then
        data.raw.item[name] = { name = name, type = "item" }
    end
    local i = data.raw.item[name]

    local obj = {}
    function obj:is_valid()
        return true
    end
    function obj:set(field, value)
        i[field] = value
        return self
    end
    setmetatable(obj, {
        __index = i,
        __newindex = i
    })
    return obj
end

-- Fonction utilitaire pour vérifier les résultats des tests
_G.assert_ingredient = function(recipe_name, ing_name, expected_amount)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then error("Recipe not found: " .. recipe_name) end
    
    for _, ing in ipairs(recipe.ingredients) do
        if ing.name == ing_name then
            if ing.amount == expected_amount then
                return true
            else
                error(string.format("Wrong amount for %s in %s: expected %d, got %d", 
                    ing_name, recipe_name, expected_amount, ing.amount))
            end
        end
    end
    error(string.format("Ingredient %s not found in recipe %s", ing_name, recipe_name))
end
