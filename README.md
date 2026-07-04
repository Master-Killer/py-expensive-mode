# Py Expensive Mode

An expensive end-game rebalance for [Pyanodons](https://mods.factorio.com/mod/pypostprocessing), by Temerition.

## What it does

- **Recipe chains with automatic amounts**: each tier of a chain requires the previous tier
  (mounts and TURD mounts, armors, wind turbines, py tanks, chests/warehouses, caravans...).
  Amounts are computed from the depth of the dependency graph (`pyem.recipe_graph`).
- **Armor packing**: armors have a stack size of 1, which prevents using them as ingredients in
  assembling machines. The mod generates "packed" armor items plus packing/unpacking recipes.
- **Alien life tweaks**: arqad breeding/maturing recipes (mk02-mk04) require higher-tier creatures.
- **Space Extension Mod rebalance** (applies when [Space Extension Mod (Feoras Fork)](https://mods.factorio.com/mod/SpaceModFeorasFork)
  or its SpaceModExpensivePatch variant is present):
  - Space science pack added to all SpaceX technologies (except FTL theories).
  - All SpaceX component recipes reworked with fixed, massively increased Pyanodons ingredients
    (drydock structural is a world tour of every py alloy and quantum material).
  - The `SpaceX-research` startup setting is still honored for technology costs; ingredient
    amounts are fixed and no longer affected by `SpaceX-production`.
- **Fusion generator**: with the SpaceModExpensivePatch fork, the spaceship also requires a
  fusion generator (stage 3 component) with its own very expensive recipe.

## Recommended companion mod

[SpaceModExpensivePatch] — a minimal fork of Space Extension Mod (Feoras Fork) that adds the
fusion-generator item as a stage 3 launch requirement. Py Expensive Mode works with the regular
SpaceModFeorasFork too, but without the fusion generator component.

## Credits

- **MdStudio5** — the SpaceX rebalance is based on the spacemod compatibility patch from
  [MadDuck's Py Tweaks](https://mods.factorio.com/mod/md-py-tweaks), which pioneered the
  Pyanodons ingredients for SpaceX components. The `fix_tech` helper also comes from there.
- **Feoras / elmodor** — [Space Extension Mod (Feoras Fork)](https://mods.factorio.com/mod/SpaceModFeorasFork).
- **The Pyanodons team** — for the mod suite this is all about.

## Development

Unit tests for the recipe graph helpers run with plain Lua:

```
lua tests/test_recipe_helpers.lua
```
