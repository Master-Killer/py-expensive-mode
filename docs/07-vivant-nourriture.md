# Vivant — la nourriture comme carburant des bâtiments d'élevage

## Briques existantes (vérifiées)

- Fuel-categories par créature déjà déclarées dans pyAL : `dingrit-food`, `phadai-food`,
  `fish`, `auog`, `dingrits`, `simik`, `gastrocapacitor` (fuel-categories.lua) — et
  `auog-generator` brûle la catégorie `auog` : **des bâtiments pY brûlent déjà des créatures**.
- Items nourriture en deux qualités `X-food-01`/`X-food-02` pour : arthurian, ulric, mukmoux,
  dhilmos, phadai, auog, fish, dingrits, phagnot, zipir, vrauks, korlex, simik
  (+ `cottongut-food-01..03`). `workers-food`/`-02`/`-03` avec chaîne existante
  (wf-02 ← 4 wf ; wf-03 ← 4 wf-02).

## Conversion burner des bâtiments d'élevage

```lua
ENTITY("mukmoux-pasture-mk0N").energy_source = {
    type = "burner",
    fuel_categories = {N <= 2 and "mukmoux-food" or "mukmoux-food-quality"},
    emissions_per_minute = ..., effectivity = 1,
}
```

- Créer les fuel-categories manquantes (2 par créature : standard / qualité) ; ajouter
  `fuel_value` + `fuel_category` aux items `X-food-01` (standard) et `X-food-02` (qualité).
- **mk01-02 brûlent la 01, mk03-04 exigent la 02** — catégories distinctes pour que le mk04
  ne puisse pas brûler du bas de gamme.
- Calibrage : consommation cible ~2-6 items/min par bâtiment (métabolisme, pas centrale
  électrique). La puissance des bâtiments d'élevage pyAL est connue par entité → script de
  calibration des fuel_value plutôt que réglage à la main. Attention aux valeurs actuelles
  (2.5 MJ sur beaucoup de foods) : les relever par catégorie dédiée n'affecte pas les burners
  `chemical` existants.
- Les bâtiments burner perdent leur conso électrique → compenser en relevant légèrement la
  demande électrique ailleurs (les technos de choc, doc 12) ou assumer le transfert
  électricité→logistique de bouffe, qui est déjà un gros nerf de confort.
- Effet de bord réglé : la boucle « l'auog exige de la nourriture qui exige des auogs »
  devient naturelle (carburant), plus besoin d'ingrédient circulaire.

## Chaîne qualité ← standard

`pyem.recipe_chain` par paire : la recette de `X-food-02` gagne `X-food-01` (×2-4 selon la
taille de lot). 14 couples + cottongut (3 niveaux) + workers-food (déjà chaînée — juste
re-doser via le depth-factor du mod).

## Créatures sans nourriture au déblocage — panachage (esprit pY)

Inventaire à scripter : pour chaque techno `<créature>-mk0N` [ou domestication], vérifier que
`X-food-0Y` est atteignable dans l'arbre recalculé. Pour chaque trou, choisir selon le TURD de
la créature (prototypes/upgrades/<créature>.lua) :

| Situation | Solution |
|---|---|
| la voie TURD booste déjà l'alimentation | déplacer le déblocage de la food au mk01 |
| créature « industrielle » (simik, numal) | workers-food du niveau atteint |
| créature précoce | nourriture basique nouvelle (recette moss/seaweed/cottongut) |
| créature end-game | abats mk d'une autre créature (lien doc 08) |

Ne pas appliquer deux fois la même solution d'affilée dans l'ordre de déblocage.

## Workers food

- Réintroduire l'ancienne « recette du diable » pour `workers-food-03` + `royal-jelly`
  (doc 08 §arqad).
- Injecter des produits animaux mk02-03 dans `workers-food`/`-02` (guts/abats mk02) —
  remplacement d'ingrédients existants, pas de recette parallèle.

## Interaction avec pyhardmode

pyhardmode ajoute du spoilage sur 100+ items et nerfe les sources de biomasse : si les foods
deviennent des carburants stockés en buffer près des bâtiments, le spoilage les frappera —
tester la cohabitation, prévoir un setting de désactivation de la conversion burner quand
pyhardmode est présent (ou des fuel_value ajustées).
