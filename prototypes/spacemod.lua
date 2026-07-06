-- Space Extension Mod (SpaceX) rebalance for Pyanodons.
-- Based on the spacemod compatibility patch from "MadDuck's Py Tweaks" (md-py-tweaks) by MdStudio5,
-- heavily rebalanced for this mod. All ingredient amounts are fixed (no production multiplier);
-- the SpaceX-research startup setting is still honored for technology costs.
--
-- Run the Pyanodons Post-processing fix_tech method on all techs to make space mod start after the victory tech.
-- Also streamline all the tech costs to be

local researchMulti = settings.startup["SpaceX-research"].value

fix_tech("space-assembly",{order="000106",prerequisites={"pyrrhic"},unit={count=6000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("space-construction",{order="000107",prerequisites={"space-assembly"},unit={count=9000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("fuel-cells",{order="000108",prerequisites={"space-construction"},unit={count=12000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("fusion-reactor",{order="000110",prerequisites={"fuel-cells"},unit={count=24000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("space-casings",{order="000108",prerequisites={"space-construction"},unit={count=12000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("protection-fields",{order="000109",prerequisites={"space-casings"},unit={count=16000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("space-thrusters",{order="000110",prerequisites={"protection-fields"},unit={count=24000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("habitation",{order="000108",prerequisites={"space-construction"},unit={count=12000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("life-support-systems",{order="000109",prerequisites={"habitation"},unit={count=16000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("spaceship-command",{order="000110",prerequisites={"life-support-systems"},unit={count=24000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1200}})
fix_tech("astrometrics",{order="000111",prerequisites={"pyrrhic", "space-thrusters", "fusion-reactor", "spaceship-command"},unit={count=32000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1600}})
fix_tech("ftl-theory-A",{order="000112",prerequisites={"astrometrics"},unit={count=200000 * researchMulti,ingredients={{"automation-science-pack",2},{"py-science-pack-1",1}},time=1600}})
fix_tech("ftl-theory-B",{order="000113",prerequisites={"ftl-theory-A"},unit={count=200000 * researchMulti,ingredients={{"automation-science-pack",6},{"logistic-science-pack",2},{"military-science-pack",1},{"py-science-pack-2",1},{"py-science-pack-1",3}},time=1600}})
fix_tech("ftl-theory-C",{order="000114",prerequisites={"ftl-theory-B"},unit={count=200000 * researchMulti,ingredients={{"automation-science-pack",20},{"logistic-science-pack",6},{"military-science-pack",3},{"chemical-science-pack",2},{"py-science-pack-3",1},{"py-science-pack-2",3},{"py-science-pack-1",10}},time=1600}})
fix_tech("ftl-theory-D1",{order="000115",prerequisites={"ftl-theory-C"},unit={count=200000 * researchMulti,ingredients={{"automation-science-pack",60},{"py-science-pack-1",30},{"logistic-science-pack",20},{"py-science-pack-2",10},{"chemical-science-pack",6},{"py-science-pack-3",3},{"production-science-pack",2},{"py-science-pack-4",1},{"military-science-pack",10}},time=1600}})
fix_tech("ftl-theory-D2",{order="000115",prerequisites={"ftl-theory-C"},unit={count=200000 * researchMulti,ingredients={{"automation-science-pack",100},{"logistic-science-pack",30},{"military-science-pack",20},{"chemical-science-pack",10},{"production-science-pack",3},{"utility-science-pack",1},{"py-science-pack-4",2},{"py-science-pack-3",6},{"py-science-pack-2",20},{"py-science-pack-1",60}},time=1600}})

if settings.startup["SpaceX-no-space-sci"].value then
    fix_tech("ftl-propulsion",{order="000116",prerequisites={"ftl-theory-D1", "ftl-theory-D2"},unit={count=200000 * researchMulti,ingredients={{"automation-science-pack",100},{"logistic-science-pack",30},{"military-science-pack",20},{"chemical-science-pack",10},{"production-science-pack",3},{"utility-science-pack",1},{"py-science-pack-4",2},{"py-science-pack-3",6},{"py-science-pack-2",20},{"py-science-pack-1",60}},time=1600}})
    fix_tech("exploration-satellite",{order="000117",prerequisites={"ftl-propulsion"},unit={count=36000 * researchMulti,ingredients={{"automation-science-pack",100},{"logistic-science-pack",30},{"military-science-pack",20},{"chemical-science-pack",10},{"production-science-pack",3},{"utility-science-pack",1},{"py-science-pack-4",2},{"py-science-pack-3",6},{"py-science-pack-2",20},{"py-science-pack-1",60}},time=1600}})
    fix_tech("space-ai-robots",{order="000117",prerequisites={"ftl-propulsion"},unit={count=36000 * researchMulti,ingredients={{"automation-science-pack",100},{"logistic-science-pack",30},{"military-science-pack",20},{"chemical-science-pack",10},{"production-science-pack",3},{"utility-science-pack",1},{"py-science-pack-4",2},{"py-science-pack-3",6},{"py-science-pack-2",20},{"py-science-pack-1",60}},time=1600}})
    fix_tech("space-fluid-tanks",{order="000117",prerequisites={"ftl-propulsion"},unit={count=36000 * researchMulti,ingredients={{"automation-science-pack",100},{"logistic-science-pack",30},{"military-science-pack",20},{"chemical-science-pack",10},{"production-science-pack",3},{"utility-science-pack",1},{"py-science-pack-4",2},{"py-science-pack-3",6},{"py-science-pack-2",20},{"py-science-pack-1",60}},time=1600}})
    fix_tech("space-cartography",{order="000118",prerequisites={"exploration-satellite"},unit={count=48000 * researchMulti,ingredients={{"automation-science-pack",100},{"logistic-science-pack",30},{"military-science-pack",20},{"chemical-science-pack",10},{"production-science-pack",3},{"utility-science-pack",1},{"py-science-pack-4",2},{"py-science-pack-3",6},{"py-science-pack-2",20},{"py-science-pack-1",60}},time=2000}})
else
    fix_tech("ftl-propulsion",{order="000116",prerequisites={"ftl-theory-D1", "ftl-theory-D2"},unit={count=200000 * researchMulti,ingredients={{"automation-science-pack",400},{"logistic-science-pack",100},{"military-science-pack",60},{"chemical-science-pack",30},{"production-science-pack",10},{"utility-science-pack",3},{"space-science-pack",2},{"py-science-pack-4",6},{"py-science-pack-3",20},{"py-science-pack-2",60},{"py-science-pack-1",200}},time=1600}})
    fix_tech("exploration-satellite",{order="000117",prerequisites={"ftl-propulsion"},unit={count=36000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1600}})
    fix_tech("space-ai-robots",{order="000117",prerequisites={"ftl-propulsion"},unit={count=36000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1600}})
    fix_tech("space-fluid-tanks",{order="000117",prerequisites={"ftl-propulsion"},unit={count=36000 * researchMulti,ingredients={{"automation-science-pack",200},{"logistic-science-pack",60},{"military-science-pack",30},{"chemical-science-pack",20},{"production-science-pack",6},{"utility-science-pack",2},{"space-science-pack",1},{"py-science-pack-4",3},{"py-science-pack-3",10},{"py-science-pack-2",30},{"py-science-pack-1",100}},time=1600}})
    fix_tech("space-cartography",{order="000118",prerequisites={"exploration-satellite"},unit={count=48000 * researchMulti,ingredients={{"automation-science-pack",400},{"logistic-science-pack",100},{"military-science-pack",60},{"chemical-science-pack",30},{"production-science-pack",10},{"utility-science-pack",3},{"space-science-pack",2},{"py-science-pack-4",6},{"py-science-pack-3",20},{"py-science-pack-2",60},{"py-science-pack-1",200}},time=3200}})
end



-- Assembly Robot
--
-- Original Recipe:
-- 5 Low density structure
-- 5 Construction robot
-- 1 Speed module 3
-- 1 Efficiency module 3
--
-- Assembly robots are the pinnacle of automated construction. These massive autonomous machines are capable of
-- operating on massive construction projects in space thanks to their advanced AI and mechanical components and the
-- addition of a highly efficient miniaturized fusion reactor.
RECIPE("assembly-robot")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "speed-module-3", amount = 1}
        :add_ingredient {type = "item", name = "efficiency-module-3", amount = 1}
        :add_ingredient {type = "item", name = "low-density-structure", amount = 5}
        :add_ingredient {type = "item", name = "py-construction-robot-mk04", amount = 5}
        :add_ingredient {type = "item", name = "mechanical-parts-04", amount = 1}
        :add_ingredient {type = "item", name = "fission-reactor-equipment", amount = 1}
        :add_ingredient {type = "item", name = "personal-fusion-cell", amount = 1}
        .category = "crafting"

-- SpaceX Combinator
--
-- Original Recipe:
-- 5 Copper cable
-- 5 Electronic circuit (green)
-- 1 Advanced circuit (red)
--
-- The SpaceX combinator not only displays the current progress of the SpaceX program but it also calculates very
-- precise estimates for how many of each component is required.
RECIPE("spacex-combinator")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "csle-diode", amount = 5}
        :add_ingredient {type = "item", name = "processing-unit", amount = 5}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 1}
        :add_ingredient {type = "item", name = "quantum-battery", amount = 1}
        .category = "crafting"

-- Drydock Assembly Component
--
-- Original Recipe:
-- 200 Processing unit (blue)
-- 100 Low density structure
-- 50 Assembly robot
-- 10 Roboport
-- 200 Solar panel
--
-- A single Drydock assembly component is a monstrous factory powered by advanced construction machines and robots. It
-- is powered by a vast array of solar panels and accumulators to ensure constant construction. The already advanced
-- logistics network is advanced by an array of highly advanced processors to ensure precision construction of a ship
-- capable of FTL travel. Imagine what an array of these could accomplish!
RECIPE("drydock-assembly")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "automated-factory-mk04", amount = 10}
        :add_ingredient {type = "item", name = "py-roboport-mk03", amount = 10}
        :add_ingredient {type = "item", name = "py-ze-mk04", amount = 10}
        :add_ingredient {type = "item", name = "solar-panel-mk04", amount = 25}
        :add_ingredient {type = "item", name = "accumulator-mk03", amount = 250}
        :add_ingredient {type = "item", name = "assembly-robot", amount = 50}
        :add_ingredient {type = "item", name = "low-density-structure", amount = 100}
        :add_ingredient {type = "item", name = "super-steel", amount = 100}
        :add_ingredient {type = "item", name = "nbti-alloy", amount = 100}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 200}
        :add_ingredient {type = "item", name = "mechanical-parts-04", amount = 10}
        .category = "crafting"

-- Drydock Structural Component
--
-- Original Recipe:
-- 200 Low density structure
--
-- Drydock structural components are a world tour of high end materials built to hold up against the rigorous
-- construction methods used during space ship construction as well as the occasional impact.
RECIPE("drydock-structural")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "super-steel", amount = 2000}
        :add_ingredient {type = "item", name = "stainless-steel", amount = 4000}

        :add_ingredient {type = "item", name = "low-density-structure", amount = 2000}
        :add_ingredient {type = "item", name = "carbon-nanotube", amount = 2500}
        :add_ingredient {type = "item", name = "metallic-glass", amount = 1500}
        :add_ingredient {type = "item", name = "hyperelastic-material", amount = 1500}

        :add_ingredient {type = "item", name = "super-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "nbti-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "agzn-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "alag-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "ticocr-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "ndfeb-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "crco-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "sncr-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "fecr-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "nbfe-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "nxsb-alloy", amount = 1000}
        :add_ingredient {type = "item", name = "pbsb-alloy", amount = 1000}

        :add_ingredient {type = "item", name = "nxag-matrix", amount = 1000}
        :add_ingredient {type = "item", name = "ernico", amount = 1000}
        :add_ingredient {type = "item", name = "heavy-fermion", amount = 1000}
        :add_ingredient {type = "item", name = "nxzngd", amount = 1000}
        :add_ingredient {type = "item", name = "re-tin", amount = 1000}
        :add_ingredient {type = "item", name = "nichrome", amount = 1000}
        :add_ingredient {type = "item", name = "duralumin", amount = 1000}
        :add_ingredient {type = "item", name = "ticl4", amount = 1000}
        :add_ingredient {type = "item", name = "ferrite", amount = 1000}
        :add_ingredient {type = "item", name = "nenbit-matrix", amount = 1000}
        :add_ingredient {type = "item", name = "nanocrystaline-core", amount = 1000}
        :add_ingredient {type = "item", name = "conductive-sheet", amount = 1000}
        :add_ingredient {type = "item", name = "ti-n", amount = 1000}
        :add_ingredient {type = "item", name = "czts-plate", amount = 1000}

        :add_ingredient {type = "item", name = "metastable-quasicrystal", amount = 2000}
        :add_ingredient {type = "item", name = "time-crystal", amount = 20000}
        :add_ingredient {type = "item", name = "ns-material", amount = 8000}
        :add_ingredient {type = "item", name = "self-assembly-monolayer", amount = 24000}
        :add_ingredient {type = "item", name = "intermetallics", amount = 48000}

       .category = "crafting"

-- Hull Component
--
-- Original Recipe:
-- 100 Steel plate
-- 200 Low density structure
--
-- Built to withstand the rigors of interstellar space at faster than light speeds, these hull components use advanced
-- materials configured in a revolutionary way.
RECIPE("hull-component")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "low-density-structure", amount = 250}
        :add_ingredient {type = "item", name = "science-coating", amount = 100}
        :add_ingredient {type = "item", name = "reinforced-wall-shield", amount = 100}
        :add_ingredient {type = "item", name = "super-alloy", amount = 200}
        :add_ingredient {type = "item", name = "super-steel", amount = 250}
        :add_ingredient {type = "item", name = "nbti-alloy", amount = 250}
        :add_ingredient {type = "item", name = "metastable-quasicrystal", amount = 100}
        .category = "crafting"

-- Protection Field
--
-- Original Recipe:
-- 100 Energy shield MK2
--
-- A pair of MK2 energy shields, once enhanced with advanced super conducting components, can have its power output
-- exponentially increased. Preliminary tests show that it should be able to withstand FTL travel. However, the power
-- source to run this array at full strength will need to be quite impressive.
RECIPE("protection-field")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "accumulator-mk03", amount = 100}
        :add_ingredient {type = "item", name = "energy-shield-mk2-equipment", amount = 100}
        :add_ingredient {type = "item", name = "superconductor-servomechanims", amount = 50}
        :add_ingredient {type = "item", name = "harmonic-absorber", amount = 100}
        :add_ingredient {type = "item", name = "diamagnetic-material", amount = 200}
        :add_ingredient {type = "item", name = "parametric-oscilator", amount = 200}
        :add_ingredient {type = "item", name = "bose-einstein-superfluid", amount = 100}
        :add_ingredient {type = "item", name = "sc-unit", amount = 100}
        :add_ingredient {type = "item", name = "metastable-quasicrystal", amount = 100}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 100}
        :add_ingredient {type = "item", name = "cryostat", amount = 100}
        :add_ingredient {type = "item", name = "cryocooler", amount = 50}
        .category = "crafting"

-- Spaceship Thruster
--
-- Original Recipe
-- 100 Processing unit (blue)
-- 100 Electric engine unit
-- 100 Low density structure
-- 50 Speed module 3
--
-- By supercharging centrifuges with an array of superconducting engines we are able to extract exotic particles from
-- fuel cells prepared on Nauvis. These particles are then accelerated to relativistic speeds and then beamed through
-- a specialized quasicrystal matrix. By using this technique we are able to produce a surprising amount of thrust for
-- a very tiny amount of input.

RECIPE("space-thruster")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "particle-accelerator-mk04", amount = 25}
        :add_ingredient {type = "item", name = "centrifuge-mk04", amount = 25}
        :add_ingredient {type = "item", name = "low-density-structure", amount = 100}
        :add_ingredient {type = "item", name = "nxzngd", amount = 100}
        :add_ingredient {type = "item", name = "metastable-quasicrystal", amount = 50}
        :add_ingredient {type = "item", name = "parametric-oscilator", amount = 50}
        :add_ingredient {type = "item", name = "mechanical-parts-04", amount = 50}
        :add_ingredient {type = "item", name = "sc-engine", amount = 100}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 100}
        :add_ingredient {type = "item", name = "ht-pipes", amount = 100}
        :add_ingredient {type = "item", name = "speed-module-3", amount = 50}
        :add_ingredient {type = "item", name = "efficiency-module-3", amount = 50}
        .category = "crafting"

-- Fuel Cell
--
-- Original Recipe:
-- 100 Steel plate
-- 100 Processing unit (blue)
-- 100 Low density structure
-- 500 Rocket fuel
--
-- The advanced process used by the spaceship's thrusters requires a mix of rare elements that must be prepared and
-- contained perfectly on Nauvis. A magnetic chamber holds the rare elements in stasis powered by an array of quantum
-- batteries to be used during transit.
RECIPE("fuel-cell")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "low-density-structure", amount = 100}
        :add_ingredient {type = "item", name = "pu-238", amount = 500}
        :add_ingredient {type = "item", name = "po-210", amount = 500}
        :add_ingredient {type = "item", name = "cm-250", amount = 500}
        :add_ingredient {type = "item", name = "u-233", amount = 500}
        :add_ingredient {type = "item", name = "sc-unit", amount = 100}
        :add_ingredient {type = "item", name = "superconductor-servomechanims", amount = 100}
        :add_ingredient {type = "item", name = "magnetic-ring", amount = 200}
        :add_ingredient {type = "item", name = "harmonic-absorber", amount = 50}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 100}
        :add_ingredient {type = "item", name = "super-alloy", amount = 100}
        :add_ingredient {type = "item", name = "metallic-glass", amount = 200}
        :add_ingredient {type = "item", name = "quantum-battery", amount = 150}
        :add_ingredient {type = "item", name = "small-parts-03", amount = 200}
        .category = "crafting"

-- Fusion Reactor
--
-- Original Recipe:
-- 100 Portable fusion reactor unit
--
-- An unimaginable amount of energy is required to power the ships systems and kickstart the FTL drive. Fortunately, a
-- revolutionary advancement in fusion technology has been made! It turns out that by firing antimatter through an array
-- of particle accelerators enhanced by advanced superconductor technology, the full yield can be drawn out almost
-- instantly. The reaction has to take place within a perfectly fine tuned reflective vacuum chamber protected by an
-- advanced protection field. A solar tower building is repurposed to cooridinate this nearly magical dance of high
-- energy acrobatics.
--
-- Since the process is so intense, a huge array of automated factories, foundaries, and crushers are constantly
-- crushing captured space rocks and smelting the constituents into rare materials which are then used to construct
-- replacement parts for the energy containment fields on the fly.
RECIPE("fusion-reactor")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "protection-field", amount = 1}
        :add_ingredient {type = "item", name = "quantum-computer", amount = 1}
        :add_ingredient {type = "item", name = "fusion-reactor-mk02", amount = 10}
        :add_ingredient {type = "item", name = "particle-accelerator-mk04", amount = 10}
        :add_ingredient {type = "item", name = "hawt-turbine-mk04", amount = 50}
        :add_ingredient {type = "item", name = "solar-tower-building", amount = 1}
        :add_ingredient {type = "item", name = "solar-tower-panel",amount = 500}
        :add_ingredient {type = "item", name = "vacuum-pump-mk04", amount = 10}
        :add_ingredient {type = "item", name = "automated-factory-mk04", amount = 10}
        :add_ingredient {type = "item", name = "advanced-foundry-mk04", amount = 5}
        :add_ingredient {type = "item", name = "jaw-crusher-mk04", amount = 5}
        :add_ingredient {type = "item", name = "nano-assembler-mk04", amount = 10}
        :add_ingredient {type = "item", name = "pi-josephson-junction", amount = 200}
        :add_ingredient {type = "item", name = "var-josephson-junction", amount = 200}
        :add_ingredient {type = "item", name = "science-coating", amount = 200}
        :add_ingredient {type = "item", name = "reinforced-wall-shield", amount = 200}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 400}
        :add_ingredient {type = "item", name = "sc-unit", amount = 200}
        :add_ingredient {type = "item", name = "ht-pipes", amount = 500}
        :add_ingredient {type = "item", name = "mechanical-parts-04", amount = 50}
        :add_ingredient {type = "item", name = "speed-module-3", amount = 50}
        :add_ingredient {type = "item", name = "productivity-module-3", amount = 50}
        :add_ingredient {type = "item", name = "antimatter", amount = 500}
        .category = "crafting"

-- Fusion generator
--
-- Only exists with the SpaceModExpensivePatch fork, which adds the fusion-generator item as a stage 3 requirement.
if data.raw.recipe["fusion-generator"] then
RECIPE("fusion-generator")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "steam-turbine-mk04", amount = 1}
        :add_ingredient {type = "item", name = "centrifuge-mk04", amount = 7}
        :add_ingredient {type = "item", name = "mechanical-parts-04", amount = 7000}
        :add_ingredient {type = "item", name = "metastable-quasicrystal", amount = 5000}
        :add_ingredient {type = "item", name = "inside-turbine", amount = 1000}
        :add_ingredient {type = "item", name = "destabilized-toxirus", amount = 1000}
        :add_ingredient {type = "item", name = "pi-josephson-junction", amount = 700}
        :add_ingredient {type = "item", name = "var-josephson-junction", amount = 600}
        :add_ingredient {type = "item", name = "sc-engine", amount = 1000}
        :add_ingredient {type = "item", name = "mqdc", amount = 800}
        :add_ingredient {type = "item", name = "nv-center", amount = 500}
        :add_ingredient {type = "item", name = "quantum-vortex-storage-system", amount = 500}
        :add_ingredient {type = "item", name = "mositial-nx", amount = 5000}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 800}
        :add_ingredient {type = "item", name = "superconductor-servomechanims", amount = 800}
        :add_ingredient {type = "item", name = "refined-concrete", amount = 10000}
        :add_ingredient {type = "item", name = "science-coating", amount = 2500}
        :add_ingredient {type = "item", name = "heavy-fermion", amount = 4500}
        .category = "crafting"
end

-- Habitation
-- Original Recipe:
-- 100 Steel
-- 500 Plastic Bar
-- 100 Processing unit (blue)
-- 100 Low Density Structure
--
-- All the best logistics and small machinery is deployed to make life aboard the interstellar ship enjoyable. Every
-- single desire is but a thought away as bots, belts, and grabbers go out of their way to get you want you want at a
-- moments notice.
RECIPE("habitation")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "express-transport-belt", amount = 500}
        :add_ingredient {type = "item", name = "hyperelastic-material", amount = 500}
        :add_ingredient {type = "item", name = "bulk-inserter", amount = 500}
        :add_ingredient {type = "item", name = "py-roboport-mk03", amount = 10}
        :add_ingredient {type = "item", name = "py-ze-mk04", amount = 10}
        :add_ingredient {type = "item", name = "py-recharge-station-mk01", amount = 10}
        :add_ingredient {type = "item", name = "py-logistic-robot-mk04", amount = 100}
        :add_ingredient {type = "item", name = "kondo-processor", amount = 200}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 100}
        :add_ingredient {type = "item", name = "super-steel", amount = 100}
        :add_ingredient {type = "item", name = "super-alloy", amount = 100}
        :add_ingredient {type = "item", name = "small-parts-03", amount = 150}
        .category = "crafting"

-- Life Support
-- Original Recipe:
-- 100 Processing unit (blue)
-- 100 Low Density Structure
-- 200 Pipe
-- 50 Productivity Module 3
--
-- The tastiest plants and animals are combined with advanced logistic and mechanical systems to create a fully
-- sustainable source of all kinds of delicious bio material. Tholin extractors are able to draw the tiny amounts of
-- tholins that float around space to sustain the base materials needed for growth. Using the scrumptious biomass, bio
-- printers turn it into any meal imaginable -- chemical plants are used to provide a wide array of flavor additives.
RECIPE("life-support")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "express-transport-belt", amount = 500}
        :add_ingredient {type = "item", name = "bulk-inserter", amount = 500}
        :add_ingredient {type = "item", name = "mega-farm", amount = 5}
        :add_ingredient {type = "item", name = "carbon-filter-mk04", amount = 5}
        :add_ingredient {type = "item", name = "chemical-plant-mk04", amount = 5}
        :add_ingredient {type = "item", name = "evaporator-mk04", amount = 5}
        :add_ingredient {type = "item", name = "multiblade-turbine-mk03", amount = 5}
        :add_ingredient {type = "item", name = "py-tank-10000", amount = 8}
        :add_ingredient {type = "item", name = "ht-pipes", amount = 300}
        :add_ingredient {type = "item", name = "tuuphra-plantation-mk04", amount = 5}
        :add_ingredient {type = "item", name = "guar-gum-plantation-mk04", amount = 5}
        :add_ingredient {type = "item", name = "guar-mk04", amount = 200}
        :add_ingredient {type = "item", name = "yotoi-aloe-orchard-mk04", amount = 5}
        :add_ingredient {type = "item", name = "ulric-corral-mk04", amount = 5}
        :add_ingredient {type = "item", name = "ulric-mk04", amount = 500}
        :add_ingredient {type = "item", name = "botanical-nursery-mk04", amount = 10}
        :add_ingredient {type = "item", name = "ez-ranch-mk04", amount = 5}
        :add_ingredient {type = "item", name = "simik-den-mk04", amount = 5}
        :add_ingredient {type = "item", name = "simik-mk04", amount = 200}
        :add_ingredient {type = "item", name = "arqad-hive-mk04", amount = 5}
        :add_ingredient {type = "item", name = "arqad-mk04", amount = 200}
        :add_ingredient {type = "item", name = "auog-paddock-mk04", amount = 5}
        :add_ingredient {type = "item", name = "auog-mk04", amount = 50}
        :add_ingredient {type = "item", name = "bio-printer-mk04", amount = 5}
        :add_ingredient {type = "item", name = "compost-plant-mk04", amount = 5}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 250}
        :add_ingredient {type = "item", name = "mechanical-parts-04", amount = 20}
        :add_ingredient {type = "item", name = "tholin-atm-mk04", amount = 5}
        .category = "crafting"

-- Command Center
-- Original Recipe:
-- 200 Plastic Bar
-- 100 Processing unit (blue)
-- 50 Speed Module 3
-- 50 Efficiency Module 3
-- 50 Productivity Module 3
--
-- A feat of engineering and logistics, the command center allows the pilot to control all ship systems from a single
-- place.
RECIPE("command")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "productivity-module-3", amount = 100}
        :add_ingredient {type = "item", name = "efficiency-module-3", amount = 100}
        :add_ingredient {type = "item", name = "speed-module-3", amount = 100}
        :add_ingredient {type = "item", name = "beacon", amount = 50}
        :add_ingredient {type = "item", name = "megadar", amount = 10}
        :add_ingredient {type = "item", name = "power-armor-mk2", amount = 1}
        :add_ingredient {type = "item", name = "electronics-mk04", amount = 100}
        :add_ingredient {type = "item", name = "metallic-glass", amount = 300}
        :add_ingredient {type = "item", name = "hyperelastic-material", amount = 500}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 300}
        :add_ingredient {type = "item", name = "kondo-processor", amount = 400}
        :add_ingredient {type = "item", name = "pi-josephson-junction", amount = 200}
        :add_ingredient {type = "item", name = "var-josephson-junction", amount = 200}
        :add_ingredient {type = "item", name = "transparent-anode", amount = 200}
        :add_ingredient {type = "item", name = "microwave-receiver", amount = 5}
        :add_ingredient {type = "item", name = "microwave-satellite", amount = 5}
        :add_ingredient {type = "item", name = "super-steel", amount = 250}
        :add_ingredient {type = "item", name = "super-alloy", amount = 250}
        :add_ingredient {type = "item", name = "small-parts-03", amount = 150}
        .category = "crafting"

-- Astrometrics Lab
-- Original Recipe:
-- 300 Processing unit (blue)
-- 100 Low Density Structure
-- 50 Speed Module 3
--
-- The calculations required to travel though space at high speeds are quite intense, requiring quantum computers to
-- even come close to being able to perform the task. These quantum computers are made more effective using a variety
-- of high tech quantum materials. In order to keep the computers cool while they run, advanced coolers and cryostats
-- are paired with an array of metastable elements mixed with stranglets which allow us to pump heat into adjacent
-- dimensions.
RECIPE("astrometrics")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 500}
        :add_ingredient {type = "item", name = "electronics-mk04", amount = 100}
        :add_ingredient {type = "item", name = "speed-module-3", amount = 120}
        :add_ingredient {type = "item", name = "quantum-computer", amount = 3}
        :add_ingredient {type = "item", name = "nv-center", amount = 200}
        :add_ingredient {type = "item", name = "pi-josephson-junction", amount = 200}
        :add_ingredient {type = "item", name = "var-josephson-junction", amount = 200}
        :add_ingredient {type = "item", name = "quantum-dots", amount = 200}
        :add_ingredient {type = "item", name = "quantum-vortex-storage-system", amount = 200}
        :add_ingredient {type = "item", name = "milfe", amount = 200}
        :add_ingredient {type = "item", name = "metastable-quasicrystal", amount = 200}
        :add_ingredient {type = "item", name = "strangelets", amount = 200}
        :add_ingredient {type = "item", name = "cryostat", amount = 200}
        :add_ingredient {type = "item", name = "cryocooler", amount = 100}
        .category = "crafting"

-- FTL Drive
-- Original Recipe:
-- 100 Processing unit (blue)
-- 100 Low Density Structure
-- 500 Speed Module 3
-- 500 Efficiency Module 3
-- 500 Productivity Module 3
--
-- At the edge of possibility lies the FTL drive. The true nature of the drive is a four dimensional entity, similar to
-- a tesseract. Unfortunately, in our world we can only see in three dimensions. In order to create the substructure of
-- the drive a large number of the most advanced nuclear reactors are stripped down and reconfigured to form a single
-- three dimensional slice of the overall drive. Then using advances in multidimensional technology, the entire three
-- dimensional drive slice is rotated into the fourth dimension by bombarding it with strangelets that have been
-- accelerated to relativistic speeds and fired through the horns of dimension hopping antelopes.
--
-- Once completed the FTL drive is kickstarted by expending 99.99% of the material kept within the onboard fusion reactors,
-- a truly incomprehensible amount of energy. Once activated, specialized Dingrit-powered generators (enhanced with
-- super fluids and other dimensional materials) are employed with an army of dimensional antelopes. Once up to speed,
-- the antelopes start dimension hopping and the onboard supercharged quantum computing arrays are able to use the
-- seemingly random dimensional jump patterns to calculate the firing solution to punch a hole in reality using a
-- proprietary mix of strangelets, tholins, and dimensional gastricorgs. A wormhole is effectively generated allowing
-- the ship to make an apparent faster than light move even though many would say its cheating.
RECIPE("ftl-drive")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "productivity-module-3", amount = 500}
        :add_ingredient {type = "item", name = "efficiency-module-3", amount = 500}
        :add_ingredient {type = "item", name = "speed-module-3", amount = 500}
        :add_ingredient {type = "item", name = "quantum-computer", amount = 50}
        :add_ingredient {type = "item", name = "particle-accelerator-mk04", amount = 50}
        :add_ingredient {type = "item", name = "nuclear-reactor-mk04", amount = 50}
        :add_ingredient {type = "item", name = "neutron-absorber-mk04", amount = 50}
        :add_ingredient {type = "item", name = "neutron-moderator-mk04", amount = 50}
        :add_ingredient {type = "item", name = "tholin-plant-mk04", amount = 50}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 500}
        :add_ingredient {type = "item", name = "dimensional-gastricorg", amount = 500}
        :add_ingredient {type = "item", name = "filled-tholins-vessel", amount = 1000}
        :add_ingredient {type = "item", name = "caged-antelope", amount = 500}
        :add_ingredient {type = "item", name = "strangelets", amount = 500}
        :add_ingredient {type = "item", name = "generator-2", amount = 20}
        :add_ingredient {type = "item", name = "nv-center", amount = 500}
        :add_ingredient {type = "item", name = "bose-einstein-superfluid", amount = 500}
        :add_ingredient {type = "item", name = "destabilized-toxirus", amount = 500}
        :add_ingredient {type = "item", name = "yaw-drive-mk04", amount = 1000}
        .category = "crafting"

if mods["pyhardmode"] then
    RECIPE("ftl-drive"):add_ingredient {type = "item", name = "macguffin", amount = 500}
end

-- TODO(mdstudio5): Update these bad boys with some fun times.

RECIPE("exploration-satellite")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "satellite", amount = 5}
        :add_ingredient {type = "item", name = "destabilized-toxirus", amount = 30}
        :add_ingredient {type = "item", name = "snarer-heart", amount = 30}
        :add_ingredient {type = "item", name = "space-thruster", amount = 1}
        :add_ingredient {type = "item", name = "nuclear-fuel", amount = 10}
        .category = "crafting"

RECIPE("space-ai-robot")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "exoskeleton-equipment", amount = 75}
        :add_ingredient {type = "item", name = "belt-immunity-equipment", amount = 75}
        :add_ingredient {type = "item", name = "megadar", amount = 50}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 100}
        :add_ingredient {type = "item", name = "productivity-module-3", amount = 100}
        :add_ingredient {type = "item", name = "quantum-battery", amount = 50}
        :add_ingredient {type = "item", name = "space-ai-robot-frame", amount = 50}
        :add_ingredient {type = "item", name = "fission-reactor-equipment", amount = 20}
        :add_ingredient {type = "item", name = "xeno-codex-mk04", amount = 10}
        :add_ingredient {type = "item", name = "quantum-computer", amount = 1}
        :add_ingredient {type = "item", name = "personal-roboport-mk2-equipment", amount = 5}
        :add_ingredient {type = "item", name = "personal-laser-defense-equipment", amount = 5}
        :add_ingredient {type = "item", name = "wyrmhole", amount = 5}
        .category = "crafting"

RECIPE("space-ai-robot-frame")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "py-construction-robot-mk04", amount = 5}
        :add_ingredient {type = "item", name = "py-logistic-robot-mk04", amount = 5}
        :add_ingredient {type = "item", name = "nukavan-turd", amount = 1}
        :add_ingredient {type = "item", name = "work-o-dile-turd", amount = 1}
        :add_ingredient {type = "item", name = "chorkok", amount = 1}
        :add_ingredient {type = "item", name = "phadaisus", amount = 1}
        .category = "crafting"


RECIPE("space-water-tank")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "water-barrel", amount = 2000}
        :add_ingredient {type = "item", name = "pump", amount = 100}
        :add_ingredient {type = "item", name = "py-tank-10000", amount = 100}
        :add_ingredient {type = "item", name = "ht-pipes", amount = 500}
        .category = "crafting"

RECIPE("space-fuel-tank")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "tritium-barrel", amount = 2000}
        :add_ingredient {type = "item", name = "nuclear-fuel", amount = 500}
        :add_ingredient {type = "item", name = "pump", amount = 100}
        :add_ingredient {type = "item", name = "py-tank-10000", amount = 100}
        :add_ingredient {type = "item", name = "ht-pipes", amount = 500}
        .category = "crafting"

RECIPE("space-oxygen-tank")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "oxygen-barrel", amount = 2000}
        :add_ingredient {type = "item", name = "pump", amount = 100}
        :add_ingredient {type = "item", name = "py-tank-10000", amount = 100}
        :add_ingredient {type = "item", name = "ht-pipes", amount = 500}
        .category = "crafting"

RECIPE("space-oxygen-barrel")
        :clear_ingredients()

RECIPE("space-map")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "exploration-data-disk", amount = 25}
        .category = "crafting"

RECIPE("laser-cannon")
        :clear_ingredients()
        :add_ingredient {type = "item", name = "laser-turret", amount = 200}
        :add_ingredient {type = "item", name = "intelligent-unit", amount = 100}
        :add_ingredient {type = "item", name = "parametric-oscilator", amount = 500}
        :add_ingredient {type = "item", name = "graphene-roll", amount = 500}
        :add_ingredient {type = "item", name = "low-density-structure", amount = 300}
        :add_ingredient {type = "item", name = "selector-combinator", amount = 200}
        .category = "crafting"


