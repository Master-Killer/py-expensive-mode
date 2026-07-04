local max_amount = 65535

--- Caps the input value to a value between 1 and the ingredient amount maximum (65535).
-- @param amount number: The amount to be capped.
-- @return number: The capped and ceiled amount.
function pyem.cap_amount(amount)
    if amount > max_amount then return max_amount end
    return math.ceil(amount)
end

-- Helper to normalize strings or tables into tables
local function to_table(val)
    if type(val) == "string" then return {val} end
    return val
end

--- Simplifies the creation of complex recipe graphs with automatic amount calculation.
-- It builds a DAG (Directed Acyclic Graph) and calculates the height of each node.
-- Default Amount = Height + 1 + offset.
-- @param graph_data table: A list of entries. Each entry can be:
--   1. {product(s), ingredient(s)}
--   2. {item1, item2, item3, ...} (Nested chain)
-- @param offset_override number: (Optional) Add this value to all calculated amounts.
function pyem.recipe_graph(graph_data, offset_override)
    local edges = {} -- product -> {ingredients}
    local all_products = {}
    
    -- 1. Phase de Collecte : Normalisation en arêtes de graphe
    for _, entry in ipairs(graph_data) do
        if #entry > 2 and type(entry[3]) ~= "number" then
            -- Format Chaîne : item1 -> item2 -> item3
            for i = 1, #entry - 1 do
                local products = to_table(entry[i])
                local ingredients = to_table(entry[i+1])
                for _, p in ipairs(products) do
                    edges[p] = edges[p] or {}
                    all_products[p] = true
                    for _, ing in ipairs(ingredients) do table.insert(edges[p], ing) end
                end
            end
        else
            -- Format Dépendance : {produit(s), ingrédient(s)}
            local products = to_table(entry[1])
            local ingredients = to_table(entry[2])
            for _, p in ipairs(products) do
                edges[p] = edges[p] or {}
                all_products[p] = true
                for _, ing in ipairs(ingredients) do table.insert(edges[p], ing) end
            end
        end
    end

    -- 2. Phase d'Analyse (Calcul des hauteurs avec détection de cycle)
    local heights = {}
    local visiting = {}

    local function get_height(node)
        if visiting[node] then error("Cycle détecté dans le graphe de recettes pour le nœud : " .. tostring(node)) end
        if heights[node] then return heights[node] end
        
        visiting[node] = true
        local max_h = 0
        local children = edges[node]
        
        if children then
            for _, child in ipairs(children) do
                local h
                if all_products[child] then
                    h = get_height(child) + 1
                else
                    h = 1 -- Les feuilles contribuent à hauteur de 1
                end
                if h > max_h then max_h = h end
            end
        end
        
        visiting[node] = nil
        heights[node] = max_h
        return max_h
    end

    -- Calculer la hauteur pour tous les produits
    for p in pairs(all_products) do
        get_height(p)
    end

    local offset = offset_override or 0

    -- 3. Phase d'Application
    for p, ingredients in pairs(edges) do
        local r = RECIPE(p)
        local amount = pyem.cap_amount(heights[p] + 1 + offset)
        if amount < 1 then amount = 1 end
        
        for _, ing in ipairs(ingredients) do
            r:add_ingredient {type = "item", name = ing, amount = amount}
        end
    end
end

--- Wrapper for simple chains using the graph logic with relative offset.
-- @param items table: List of items in the chain.
-- @param offset number: (Optional) Offset relative to the calculated max height.
function pyem.recipe_chain(items, offset)
    pyem.recipe_graph({items}, offset)
end

--- Special wrapper for armors which have stack_size = 1.
-- This automatically creates a packed version of the armors to bypass the 
-- stack size limit in assembling machines.
-- @param items table: List of armors in the chain.
-- @param offset number: (Optional) Offset relative to the calculated max height.
function pyem.armor_recipe_chain(items, offset)
    local function simple_deep_copy(obj)
        if type(obj) ~= 'table' then return obj end
        local res = {}
        for k, v in pairs(obj) do res[k] = simple_deep_copy(v) end
        return res
    end

    for i = 2, #items do
        local armor_name = items[i]
        local packed_name = armor_name .. "-packed"
        
        -- Create packed item if it doesn't exist
        local has_item = data.raw.item and data.raw.item[packed_name]
        if data.raw.armor and data.raw.armor[armor_name] and not has_item then
            local armor = data.raw.armor[armor_name]
            local packed = simple_deep_copy(armor)
            packed.type = "item"
            packed.name = packed_name
            packed.stack_size = 50
            packed.equipment_grid = nil
            packed.inventory_size_bonus = nil
            if armor.localised_name then
                packed.localised_name = {"", armor.localised_name, " (Packed)"}
            else
                packed.localised_name = {"", {"item-name." .. armor_name}, " (Packed)"}
            end
            data:extend({packed})

            -- Create packing recipe
            data:extend({
                {
                    type = "recipe",
                    name = armor_name .. "-packing",
                    ingredients = {{type = "item", name = armor_name, amount = 1}},
                    results = {{type = "item", name = packed_name, amount = 1}},
                    energy_required = 0.5,
                    enabled = true,
                    category = "crafting"
                }
            })

            -- Create unpacking recipe
            data:extend({
                {
                    type = "recipe",
                    name = armor_name .. "-unpacking",
                    ingredients = {{type = "item", name = packed_name, amount = 1}},
                    results = {{type = "item", name = armor_name, amount = 1}},
                    energy_required = 0.5,
                    enabled = true,
                    category = "crafting"
                }
            })
        end
    end

    -- Update recipes using the calculated heights
    for i = 1, #items - 1 do
        local product = items[i]
        local ingredient = items[i+1]
        local height = #items - i
        local amount = pyem.cap_amount(height + 1 + (offset or 0))
        if amount < 1 then amount = 1 end

        local r = RECIPE(product)
        r:add_ingredient {type = "item", name = ingredient .. "-packed", amount = amount}
    end
end

--- Prints the structure of a recipe graph for debugging purposes.
-- Shows adjacency list, calculated heights, and final amounts.
function pyem.print_graph(graph_data, offset_override)
    local edges = {}
    local all_products = {}
    
    for _, entry in ipairs(graph_data) do
        if #entry > 2 and type(entry[3]) ~= "number" then
            for i = 1, #entry - 1 do
                local products = to_table(entry[i])
                local ingredients = to_table(entry[i+1])
                for _, p in ipairs(products) do
                    edges[p] = edges[p] or {}
                    all_products[p] = true
                    for _, ing in ipairs(ingredients) do table.insert(edges[p], ing) end
                end
            end
        else
            local products = to_table(entry[1])
            local ingredients = to_table(entry[2])
            for _, p in ipairs(products) do
                edges[p] = edges[p] or {}
                all_products[p] = true
                for _, ing in ipairs(ingredients) do table.insert(edges[p], ing) end
            end
        end
    end

    local heights = {}
    local visiting = {}
    local function get_height(node)
        if visiting[node] then return "CYCLE" end
        if heights[node] then return heights[node] end
        visiting[node] = true
        local max_h = 0
        local children = edges[node]
        if children then
            for _, child in ipairs(children) do
                local h = all_products[child] and (get_height(child) + 1) or 1
                if type(h) == "number" and h > max_h then max_h = h end
            end
        end
        visiting[node] = nil
        heights[node] = max_h
        return max_h
    end

    for p in pairs(all_products) do get_height(p) end
    local offset = offset_override or 0

    print("\n--- Visualisation du Graphe de Recettes ---")
    local sorted_products = {}
    for p in pairs(all_products) do table.insert(sorted_products, p) end
    table.sort(sorted_products, function(a, b)
        if heights[a] ~= heights[b] then
            return heights[a] < heights[b]
        end
        return a < b
    end)

    for _, p in ipairs(sorted_products) do
        local h = heights[p]
        local amount = pyem.cap_amount(h + 1 + offset)
        local ings = table.concat(edges[p], ", ")
        print(string.format("[H:%d | Qte:%d] %s -> {%s}", h, amount, p, ings))
    end
    print("-------------------------------------------\n")
end
