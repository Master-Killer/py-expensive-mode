# Toile de dépendances intra-niveau (tier web)

## Constat vérifié

Au tier 1, les machines pY dépendent les unes des autres ; au-delà, plus du tout :

- `geothermal-plant-mk01` ← 4× `electric-mining-drill` ; `uranium-mining-drill` ←
  `automated-factory-mk01` ; `nuclear-reactor-mox-mkN` ← `nuclear-reactor-mkN` (même tier,
  aux 4 MK — le seul cas post-mk01 du pack) ; `solar-tower-heilostat` ← `mirror-mk03`.
- Pattern mk02+ uniforme (ex. auog-paddock) : machine N−1 + plaques + circuits +
  `small-parts-0N`. Une exception isolée : `py-heat-exchanger` dans auog-paddock-mk03.

## Règle de conception

Tout bâtiment mkN (N ≥ 2) doit dépendre d'éléments **étrangers à sa propre famille**, de
tier N ou N−1 — jamais uniquement de lui-même au rang inférieur. Trois canaux :

1. **Composants signatures** (doc 02) : 2 composants mkN de familles étrangères, affectation
   systématique et outillée.
2. **Bâtiment étranger** : 1 machine de tier N ou N−1 d'une autre famille, affectation
   curatée et thématique (généralisation du pattern MOX).
3. **Créatures/montures** aux tiers 3-4 (doc 09) pour les familles « de plein air ».

## Canal 1 — systématique (helper)

```lua
-- lib/tier-web.lua
-- pyem.tier_web{donors = {[2] = {...}, [3] = {...}, [4] = {...}}, overrides = {...}}
-- Pour chaque recette de bâtiment détectée mk02+ :
--   tier = tonumber(recipe.name:match("mk0(%d)$"))
--   h = hash_stable(recipe.name)  -- somme des bytes, pas de math.random (déterminisme)
--   ajouter 2 donneurs distincts du pool[tier], en excluant ceux de la même famille
--   (table famille→items maintenue à la main pour l'éolien, le nucléaire, etc.)
```

Pools (items vérifiés, cf. doc 02 pour les quantités) :

| Tier | Pool |
|---|---|
| 2 | shaft/gearbox/utility-box/electronics-mk02, `nexelit-battery`, `py-heat-exchanger` |
| 3 | brake/controler/electronics-mk03, `neuromorphic-chip`, `mechanical-parts-03`, alliage grade 3 (doc 04) |
| 4 | gearbox/controler/utility-box/electronics-mk04, `mechanical-parts-04`, alliage grade 4, monture (doc 09) |

Détection des « bâtiments » : recette dont le résultat unique est un item plaçable avec
pattern `-mk0N` — liste blanche générée en data-final-fixes puis figée dans un fichier de
config versionné (pas de magie totale : on veut pouvoir relire ce qui a été touché).

## Canal 2 — curaté (matrice de départ)

Paires thématiques, donneur toujours **feuille** du `pyem.recipe_graph` pour ne pas faire
exploser les quantités calculées par profondeur. Toutes **[à valider contre l'arbre
recalculé par pypostprocessing]** :

| Receveur | Donneur (amount 1) | Thème |
|---|---|---|
| `ez-ranch-mk0N` | `auog-paddock-mk0N` | l'élevage générique s'appuie sur l'élevage de base |
| `mukmoux-pasture-mk0N` | `moss-farm-mk0N` | fourrage |
| `dhilmos-pool-mk0N` | `fish-farm` ×N | bassins |
| `genlab-mk0N` | `incubator` ×N | le labo incube |
| `fluid-drill-mk0N` | `micro-mine-mk0N` | forage ↔ mine |
| `centrifuge-mk0N` (pyAE) | `steam-turbine-mk0N` | le choc électrique paie son alimentation |
| `heat-exchanger-mk0N` | `electric-boiler` ×N | chaîne thermique |
| `biomass-powerplant-mk0N` | `compost-plant` ×N | filière biomasse |
| `nuclear-reactor-mk0N` | `neutron-moderator-mk0N` déjà ? sinon ajout | cœur du réacteur |
| nouveaux bâtiments docs 03-04 | set composants + 1 machine thermique du tier | métallurgie |

## Vérification (chantier préalable, non négociable)

À construire dans `lib/` + `tests/` (harnais `mock_factorio.lua` existant) :

1. **Cycle check** : graphe complet item→recette→item après tous les ajouts, détection de
   cycle avec chemin fautif dans le message d'erreur.
2. **Ordre technologique** : en data-final-fixes (après pypostprocessing), pour chaque
   ingrédient ajouté par pyem : `tech(ingredient) ≤ tech(recette)`. Violations logguées en
   warning avec la chaîne de technos. pypostprocessing *déplace* les technos quand on change
   les ingrédients — chaque lot doit être re-testé.
3. **Snapshot de diff** : un dump texte trié des recettes modifiées (nom → ingrédients),
   committé, pour voir en revue ce qu'un changement de pool/hash déplace.

## Dosage

Commencer par UNE famille de test (les bâtiments du vivant pyAL, ~60 recettes), vérifier
l'arbre, puis étendre à pyAE. Le canal 2 se déploie par paires indépendantes, à son rythme.
