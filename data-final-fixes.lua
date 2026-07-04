-- Space Extension Mod rebalance: applies with the SpaceModExpensivePatch fork (preferred,
-- adds the fusion-generator stage 3 requirement) or with plain SpaceModFeorasFork.
if mods["SpaceModExpensivePatch"] or mods["SpaceModFeorasFork"] then
    require("prototypes.spacemod")
end

require("prototypes.chains")
require("prototypes.alien-life-tweaks")
require("prototypes.misc")
