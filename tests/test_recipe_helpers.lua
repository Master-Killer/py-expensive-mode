-- Charger l'environnement de mock
require("tests.mock_factorio")

-- Charger les fonctions à tester
dofile("lib/recipe-graph.lua")

-- Exécuter les tests avec cette commande
--lua tests/test_recipe_helpers.lua
local function run_tests()
    print("Exécution des tests unitaires (Algorithme de Graphe)...")

    ---- Test 1: pyem.recipe_chain simple
    print("- Test: recipe_chain simple")
    pyem.recipe_chain({"item-A", "item-B", "item-C"})
    assert_ingredient("item-A", "item-B", 3)
    assert_ingredient("item-B", "item-C", 2)

    -- Test 2: pyem.recipe_chain avec embranchements (logistique)
    print("- Test: recipe_chain avec embranchements")
    pyem.recipe_chain({{"logi-1", "logi-2"}, "base-chest"})
    assert_ingredient("logi-1", "base-chest", 2)
    assert_ingredient("logi-2", "base-chest", 2)

    -- Test montant de base différent
    pyem.recipe_chain({"yaw-drive-mk04", "yaw-drive-mk03", "yaw-drive-mk02", "yaw-drive-mk01"}, -1)
    assert_ingredient("yaw-drive-mk04", "yaw-drive-mk03", 3)
    assert_ingredient("yaw-drive-mk03", "yaw-drive-mk02", 2)
    assert_ingredient("yaw-drive-mk02", "yaw-drive-mk01", 1)

    -- Test autres embranchements
    pyem.recipe_graph({
        {"vane-mk03", "vane-mk02", "vane-mk01"},
        {"hotair-vane-mk02", "vane-mk01"},
    })
    assert_ingredient("vane-mk03", "vane-mk02", 3)
    assert_ingredient("vane-mk02", "vane-mk01", 2)
    assert_ingredient("hotair-vane-mk02", "vane-mk01", 2)

    -- Test: Graphe des Tanks
    print("- Test: Graphe des Tanks (Profondeur complexe)")
    data.raw.recipe = {} -- Reset data
    pyem.recipe_graph({
      {"py-tank-10000", {"py-tank-9000", "py-tank-8000"}},
      {"py-tank-9000", {"py-tank-7000", "py-tank-5000"}},
      {"py-tank-8000", "py-tank-6500", {"storage-tank", "py-tank-4000"}},
      {"py-tank-7000", "py-tank-4000", {"py-tank-1500", "py-tank-3000"}},
      {"py-tank-5000", "storage-tank"},
      {"storage-tank", {"py-tank-1500", "py-tank-1000"}},
      {{ "py-tank-1500", "py-tank-3000", "py-tank-1000" }, "tailings-pond", "py-gas-vent"}
    })

    assert_ingredient("py-tank-10000", "py-tank-9000", 7)
    assert_ingredient("py-tank-10000", "py-tank-8000", 7)
    assert_ingredient("py-tank-9000", "py-tank-7000", 6)
    assert_ingredient("py-tank-9000", "py-tank-5000", 6)
    assert_ingredient("py-tank-8000", "py-tank-6500", 6)
    assert_ingredient("py-tank-6500", "storage-tank", 5)
    assert_ingredient("py-tank-6500", "py-tank-4000", 5)
    assert_ingredient("py-tank-7000", "py-tank-4000", 5)
    assert_ingredient("py-tank-5000", "storage-tank", 5)
    assert_ingredient("py-tank-4000", "py-tank-1500", 4)
    assert_ingredient("py-tank-4000", "py-tank-3000", 4)
    assert_ingredient("storage-tank", "py-tank-1500", 4)
    assert_ingredient("storage-tank", "py-tank-1000", 4)
    assert_ingredient("py-tank-1000", "tailings-pond", 3)
    assert_ingredient("py-tank-1500", "tailings-pond", 3)
    assert_ingredient("py-tank-3000", "tailings-pond", 3)
    assert_ingredient("tailings-pond", "py-gas-vent", 2)

    -- Test: Graphe des Coffres (Multi-chaînes)
    print("- Test: Graphe des Coffres (Chaînes et embranchements)")
    data.raw.recipe = {}
    local chest_graph = {
        { "py-deposit-basic", "py-warehouse-basic", "py-storehouse-basic", "py-shed-basic", "steel-chest" },
        { { "requester-chest", "passive-provider-chest", "active-provider-chest", "buffer-chest", "storage-chest" }, "steel-chest" },
        { { "py-shed-requester", "py-shed-passive-provider", "py-shed-active-provider", "py-shed-buffer", "py-shed-storage" }, "py-shed-basic" },
        { { "py-storehouse-requester", "py-storehouse-passive-provider", "py-storehouse-active-provider", "py-storehouse-buffer", "py-storehouse-storage" }, "py-storehouse-basic" },
        { { "py-warehouse-requester", "py-warehouse-passive-provider", "py-warehouse-active-provider", "py-warehouse-buffer", "py-warehouse-storage" }, "py-warehouse-basic" },
        { { "py-deposit-requester", "py-deposit-passive-provider", "py-deposit-active-provider", "py-deposit-buffer", "py-deposit-storage" }, "py-deposit-basic" },
    }
    pyem.recipe_graph(chest_graph)
    pyem.print_graph(chest_graph)

    pyem.recipe_chain({ "py-deposit-requester", "py-warehouse-requester", "py-storehouse-requester", "py-shed-requester", "requester-chest" })
    pyem.recipe_chain({ "py-deposit-active-provider", "py-warehouse-active-provider", "py-storehouse-active-provider", "py-shed-active-provider", "active-provider-chest" })
    pyem.recipe_chain({ "py-deposit-passive-provider", "py-warehouse-passive-provider", "py-storehouse-passive-provider", "py-shed-passive-provider", "passive-provider-chest" })
    pyem.recipe_chain({ "py-deposit-buffer", "py-warehouse-buffer", "py-storehouse-buffer", "py-shed-buffer", "buffer-chest" })
    pyem.recipe_chain({ "py-deposit-storage", "py-warehouse-storage", "py-storehouse-storage", "py-shed-storage", "storage-chest" })

    --assert_ingredient("steel-chest", "iron-chest", 3)
    assert_ingredient("requester-chest", "steel-chest", 2)
    assert_ingredient("py-shed-requester", "py-shed-basic", 3)
    assert_ingredient("py-shed-requester", "requester-chest", 2)
    assert_ingredient("py-storehouse-requester", "py-shed-requester", 3)
    assert_ingredient("py-warehouse-requester", "py-storehouse-requester", 4)
    assert_ingredient("py-deposit-basic", "py-warehouse-basic", 5)
    assert_ingredient("py-deposit-requester", "py-warehouse-requester", 5)
    assert_ingredient("py-deposit-requester", "py-deposit-basic", 6)

    -- Test: Graphe des Armures (Solution 1)
    print("- Test: Graphe des Armures (Solution 1 / Armor Packing)")
    data.raw.recipe = {} -- Reset recipes
    data.raw.armor = {
        ["power-armor-mk2"] = { name = "power-armor-mk2", type = "armor" },
        ["power-armor"] = { name = "power-armor", type = "armor" },
        ["modular-armor"] = { name = "modular-armor", type = "armor" },
        ["heavy-armor"] = { name = "heavy-armor", type = "armor" },
        ["light-armor"] = { name = "light-armor", type = "armor" }
    }
    data.raw.item = {}

    pyem.armor_recipe_chain({"power-armor-mk2", "power-armor", "modular-armor", "heavy-armor", "light-armor"})

    assert_ingredient("power-armor-mk2", "power-armor-packed", 5)
    assert_ingredient("power-armor", "modular-armor-packed", 4)
    assert_ingredient("modular-armor", "heavy-armor-packed", 3)
    assert_ingredient("heavy-armor", "light-armor-packed", 2)

    -- Verify that packing/unpacking recipes were registered
    assert(data.raw.recipe["power-armor-packing"] ~= nil, "Packing recipe not found")
    assert(data.raw.recipe["power-armor-unpacking"] ~= nil, "Unpacking recipe not found")

    print("\nTOUS LES TESTS ONT RÉUSSI !")
end

-- Lancer les tests
local status, err = pcall(run_tests)
if not status then
    print("\nÉCHEC DU TEST :")
    print(err)
    os.exit(1)
end
