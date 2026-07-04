# Filières énergie pyAE — chaque filière devient un passage obligé

## Inventaire des familles (buildings pyAE vérifiés)

éolien HAWT/VAWT/multiblade, solaire (panels mk01-04, anti-solar, tour à concentration
heliostat/megastructure, stirling/solar-concentrator, sut), nucléaire (reactor + MOX mk01-04,
neutron-moderator mk01-04, neutron-absorber), géothermie (geothermal-plant-mk01,
antimony-drill), marémoteur (tidal mk01-04), micro-ondes/laser (microwave-receiver, mdh,
lrf), RTG, thermique (coal/gas/oil/biomass powerplants), stockage (accumulator-mk03,
nexelit-power-pole/substation), aerial (aerial mk01-04 + aerial-base).

Constat de jeu : chaque joueur n'exploite qu'un sous-ensemble ; les composants des autres
filières restent des items morts.

## Principe (« le seul consommateur possible »)

Chaque filière détient l'exclusivité d'un **composant requis ailleurs** — pas d'obligation de
*produire de l'électricité* avec (injouable à imposer), mais obligation de *construire la
chaîne de composants* de la filière. Attributions :

| Filière | Composant signature | Puits obligatoire |
|---|---|---|
| Éolien | nacelle, yaw-drive, composants MK | déjà fait (chaînes du mod) + doc 02 (mechanical-parts) |
| Solaire concentration | `mirror-mk03`, `stirling-concentrator` | Thermite Furnace (doc 03 : amorçage thermique des coulées) + nexelit « résonance » via molten-salt 1000° |
| Nucléaire | `neutron-moderator-mk0N`, `neutron-absorber` | rocket parts palier 2-3 (doc 11 : nuclear-fuel) + Remelting Furnace (VAR = arc sous vide : électrodes + blindage) |
| Géothermie | `geothermal-plant-mk01` | source de chaleur du choc chaleur (doc 12) : CVP/Ladle acceptent la chaleur géothermale |
| Marémoteur | turbines `tidal-mk0N` | drydock SpaceX (structure marine — déjà « world tour », y router les tidal) |
| Micro-ondes/laser | `microwave-receiver`, panneaux `lrf` | composants FTL du spacemod + fusion-generator (SpaceModExpensivePatch) |
| RTG | `rtg` | fusion-generator (déjà le cas ? sinon ajout) + aerial-base |
| Thermique | powerplants mk0N | toile doc 01 (donneurs des machines à choc électrique) |
| Stockage | `nexelit-battery`, accumulator-mk03 | pool de donneurs tier 2 (doc 01) + saddles (doc 09) |

Le véhicule principal est le **rebalance spacemod du mod** (chaque composant SpaceX adopte
1-2 filières) + les **nouveaux bâtiments métallurgie** (docs 03-04) qui répartissent leurs
recettes de construction sur les filières restantes.

## Aerial (cas particulier)

Les aerials mk01-04 + aerial-base sont une filière entière quasi optionnelle. Proposition :
`outpost-aerial`/`-fluid` (déjà dans le recipe_graph du mod) += `aerial-mk0N` du rang — les
avant-postes volants exigent la flotte volante. Cohérence thématique immédiate.

## Vérification

Pour chaque filière, un test « la filière est-elle traversée ? » : le graphe de recettes doit
contenir un chemin composant-signature → produit end-game (spacemod part ou science). Le
harnais du doc 01 peut le vérifier mécaniquement (atteignabilité inverse depuis les puits).
