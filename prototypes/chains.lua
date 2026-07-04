--Créatures
pyem.recipe_chain({"phadaisus", "spidertron", "dingrido", "crawdad"})
pyem.armor_recipe_chain({"power-armor-mk2", "power-armor", "modular-armor", "heavy-armor", "light-armor"})
pyem.recipe_chain({"chorkok", "huzu", "gobachov"})
pyem.recipe_chain({"work-o-dile", "thikat", "digosaurus"})
pyem.recipe_chain({"work-o-dile-turd", "thikat-turd", "digosaurus-turd"})

-- Apparemment on ne peut pas insérer plus d'une caravane à la fois
RECIPE("nukavan"):add_ingredient {type = "item", name = "flyavan", amount = 1}:add_ingredient {type = "item", name = "fluidflyavan", amount = 1}
RECIPE("nukavan-turd"):add_ingredient {type = "item", name = "flyavan-turd", amount = 1}:add_ingredient {type = "item", name = "fluidflyavan-turd", amount = 1}
RECIPE("flyavan"):add_ingredient {type = "item", name = "caravan", amount = 1}
RECIPE("flyavan-turd"):add_ingredient {type = "item", name = "caravan-turd", amount = 1}
RECIPE("fluidflyavan"):add_ingredient {type = "item", name = "fluidavan", amount = 1}
RECIPE("fluidflyavan-turd"):add_ingredient {type = "item", name = "fluidavan-turd", amount = 1}

pyem.recipe_graph({
    {"wyrmhole", "simik-boiler", {"outpost-aerial", "outpost-aerial-fluid"}},
    {"outpost-aerial", "ipod", "pyphoon-bay", "outpost"},
    {"outpost-aerial-fluid", "generator-2", "generator-1", "outpost-fluid"}
})

-- Other recipe tweaks
RECIPE("crawdad"):replace_ingredient("py-shed-basic", "py-shed-buffer")
RECIPE("dingrido"):replace_ingredient("py-shed-basic", "py-storehouse-buffer")
RECIPE("spidertron"):replace_ingredient("py-shed-basic", "py-warehouse-buffer")
RECIPE("phadaisus"):replace_ingredient("py-shed-basic", "py-deposit-buffer")
RECIPE("crawdad-earth-sample-turd"):replace_ingredient("py-shed-basic", "py-shed-buffer")
RECIPE("dingrido-earth-sample-turd"):replace_ingredient("py-shed-basic", "py-storehouse-buffer")
RECIPE("spidertron-earth-sample-turd"):replace_ingredient("py-shed-basic", "py-warehouse-buffer")
RECIPE("phadaisus-earth-sample-turd"):replace_ingredient("py-shed-basic", "py-deposit-buffer")

-- Éoliennes
pyem.recipe_chain({"hawt-turbine-mk04", "hawt-turbine-mk03", "hawt-turbine-mk02", "hawt-turbine-mk01"})
pyem.recipe_chain({"anemometer-mk04", "anemometer-mk03", "anemometer-mk02", "anemometer-mk01"}, -1)
pyem.recipe_chain({"yaw-drive-mk04", "yaw-drive-mk03", "yaw-drive-mk02", "yaw-drive-mk01"}, -1)
pyem.recipe_chain({"nacelle-mk04", "nacelle-mk03", "nacelle-mk02", "nacelle-mk01"})
pyem.recipe_chain({"blade-mk03", "blade-mk02", "blade-mk01"})
pyem.recipe_chain({"rotor-mk03", "rotor-mk02", "rotor-mk01"})
pyem.recipe_graph({
    {"vane-mk03", "vane-mk02", "vane-mk01"},
    {"hotair-vane-mk02", "vane-mk01"},
})
pyem.recipe_chain({"tower-mk04", "tower-mk03", "tower-mk02", "tower-mk01"}, -1)

-- citernes et coffres
pyem.recipe_graph({
  {"py-tank-10000", {"py-tank-9000", "py-tank-8000"}},
  {"py-tank-9000", {"py-tank-7000", "py-tank-5000"}},
  {"py-tank-8000", "py-tank-6500", {"storage-tank", "py-tank-4000"}},
  {"py-tank-7000", "py-tank-4000", {"py-tank-1500", "py-tank-3000"}},
  {"py-tank-5000", "storage-tank"},
  {"storage-tank", {"py-tank-1500", "py-tank-1000"}},
})

RECIPE("py-tank-10000"):remove_ingredient("py-tank-4000")
RECIPE("py-tank-9000"):remove_ingredient("py-tank-3000"):add_ingredient {type = "item", name = "py-tank-5000", amount = -1}
RECIPE("py-tank-8000"):remove_ingredient("py-tank-4000")
RECIPE("py-tank-7000"):remove_ingredient("storage-tank")
RECIPE("py-tank-6500"):add_ingredient {type = "item", name = "py-tank-4000", amount = -1}
RECIPE("py-tank-5000"):remove_ingredient("py-tank-1500")

--RECIPE("py-tank-1000"):add_ingredient {type = "item", name = "tailings-pond", amount = 1}
--RECIPE("py-tank-1500"):add_ingredient {type = "item", name = "tailings-pond", amount = 1}
RECIPE("py-tank-3000"):add_ingredient {type = "item", name = "tailings-pond", amount = 1}
RECIPE("tailings-pond"):add_ingredient {type = "item", name = "py-gas-vent", amount = 1}

RECIPE("requester-chest"):remove_ingredient("steel-chest")
RECIPE("active-provider-chest"):remove_ingredient("steel-chest")
RECIPE("passive-provider-chest"):remove_ingredient("steel-chest")
RECIPE("storage-chest"):remove_ingredient("steel-chest")
RECIPE("buffer-chest"):remove_ingredient("steel-chest")

RECIPE("py-shed-basic"):remove_ingredient("wooden-chest")
RECIPE("py-storehouse-basic"):remove_ingredient("wooden-chest")
RECIPE("py-warehouse-basic"):remove_ingredient("wooden-chest")
RECIPE("py-deposit-basic"):remove_ingredient("wooden-chest")

RECIPE("py-shed-requester"):remove_ingredient("requester-chest")
RECIPE("py-storehouse-requester"):remove_ingredient("requester-chest")
RECIPE("py-warehouse-requester"):remove_ingredient("requester-chest")
RECIPE("py-deposit-requester"):remove_ingredient("requester-chest")

RECIPE("py-shed-active-provider"):remove_ingredient("active-provider-chest")
RECIPE("py-storehouse-active-provider"):remove_ingredient("active-provider-chest")
RECIPE("py-warehouse-active-provider"):remove_ingredient("active-provider-chest")
RECIPE("py-deposit-active-provider"):remove_ingredient("active-provider-chest")

RECIPE("py-shed-passive-provider"):remove_ingredient("passive-provider-chest")
RECIPE("py-storehouse-passive-provider"):remove_ingredient("passive-provider-chest")
RECIPE("py-warehouse-passive-provider"):remove_ingredient("passive-provider-chest")
RECIPE("py-deposit-passive-provider"):remove_ingredient("passive-provider-chest")

RECIPE("py-shed-storage"):remove_ingredient("storage-chest")
RECIPE("py-storehouse-storage"):remove_ingredient("storage-chest")
RECIPE("py-warehouse-storage"):remove_ingredient("storage-chest")
RECIPE("py-deposit-storage"):remove_ingredient("storage-chest")

RECIPE("py-shed-buffer"):remove_ingredient("buffer-chest")
RECIPE("py-storehouse-buffer"):remove_ingredient("buffer-chest")
RECIPE("py-warehouse-buffer"):remove_ingredient("buffer-chest")
RECIPE("py-deposit-buffer"):remove_ingredient("buffer-chest")

pyem.recipe_chain({ "steel-chest", "iron-chest", "wooden-chest" })
pyem.recipe_graph({
    { "py-deposit-basic", "py-warehouse-basic", "py-storehouse-basic", "py-shed-basic", "steel-chest" },
    { { "requester-chest", "passive-provider-chest", "active-provider-chest", "buffer-chest", "storage-chest" }, "steel-chest" },
    { { "py-shed-requester", "py-shed-passive-provider", "py-shed-active-provider", "py-shed-buffer", "py-shed-storage" }, "py-shed-basic" },
    { { "py-storehouse-requester", "py-storehouse-passive-provider", "py-storehouse-active-provider", "py-storehouse-buffer", "py-storehouse-storage" }, "py-storehouse-basic" },
    { { "py-warehouse-requester", "py-warehouse-passive-provider", "py-warehouse-active-provider", "py-warehouse-buffer", "py-warehouse-storage" }, "py-warehouse-basic" },
    { { "py-deposit-requester", "py-deposit-passive-provider", "py-deposit-active-provider", "py-deposit-buffer", "py-deposit-storage" }, "py-deposit-basic" },
})

pyem.recipe_chain({ "py-deposit-requester", "py-warehouse-requester", "py-storehouse-requester", "py-shed-requester", "requester-chest" })
pyem.recipe_chain({ "py-deposit-active-provider", "py-warehouse-active-provider", "py-storehouse-active-provider", "py-shed-active-provider", "active-provider-chest" })
pyem.recipe_chain({ "py-deposit-passive-provider", "py-warehouse-passive-provider", "py-storehouse-passive-provider", "py-shed-passive-provider", "passive-provider-chest" })
pyem.recipe_chain({ "py-deposit-buffer", "py-warehouse-buffer", "py-storehouse-buffer", "py-shed-buffer", "buffer-chest" })
pyem.recipe_chain({ "py-deposit-storage", "py-warehouse-storage", "py-storehouse-storage", "py-shed-storage", "storage-chest" })
