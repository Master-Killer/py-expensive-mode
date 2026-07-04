# Interconnexions du vivant MK (zipir/xyhiphoe, arqad, vonix)

## Items vérifiés

- Zipir : `zipir1..4` (tiers créature), `zipir-eggs`, `zipir-pup`, `zipir-food-01/02`,
  `zipir-codex(-mk02..04)`. Les `zipir-eggs` sont déjà dans `py-science-pack-2` (×15).
- Xyhiphoe : `xyhiphoe(-mk02..04)`, `xyhiphoe-cub(-mk02..04)`, `blood-xyhiphoe`,
  `guts-xyhiphoe`, `shell-xyhiphoe`, `meat-xyhiphoe` ; fluide `blood`.
- Arqad : `arqad-queen` — revient avec `probability = 0.999` dans le raising, produite à
  0.01 (recipes-arqad-raising.lua) ; fluide `arqad-honey`.
- Vonix : `vonix`, `vonix-eggs` — pas de tiers mk, pas de chaîne d'élevage complète.

## Zipir ↔ Xyhiphoe (débloqués dans les mêmes technos)

### Niveau 1 — interconnexion simple

- `zipir-eggs` += `shell-xyhiphoe` 2 (les œufs se pondent dans les coquilles).
- maturing de `xyhiphoe-cub` += `meat-xyhiphoe`→ non : += viande de zipir **[item exact à
  vérifier : rendering zipir]** (la larve mange du Zipir).
- élevage des deux += fluide `blood` — ou déplacer le sang sur les poissons/Navens : les
  `navens-mkN-breeder` consomment déjà `xyhiphoe-mkN` ×9 via les tweaks du mod, boucler par
  les poissons diversifie.

### MK2+ — amorçage croisé non-chuntable

Une recette double par tier, produits jetables qui ne servent qu'à amorcer chaque côté :

```
"tidepool-symbiosis-mk0N" (creature-chamber, 300 s) :
  zipir(N−1) 2 + xyhiphoe-mk0(N−1) 2 + arqad-honey 200 + workers-food-0X 5
  → shell-cluster-mk0N 1 + blood-clot-mk0N 1        [6 items nouveaux au total]

amorçage xyhiphoe-cub-mk0N ← shell-cluster-mk0N 1
amorçage zipir(N)           ← blood-clot-mk0N 1
```

Impossible d'utiliser l'amorçage d'un côté pour sauter l'autre : les deux lignées montent
ensemble. Les recettes d'amorçage normales (par codex/cDNA) sont supprimées ou renchéries à
ces tiers pour que la symbiose soit LE chemin (« rien d'optionnel »).

## Arqad — la gelée royale

```
"royal-jelly" (arqad-hive) : arqad-queen 1 (SANS retour) + arqad-honey 100 → royal-jelly 5
```

Consommée par : `arqad-mk0N-breeding` (déjà retouchés par le mod : ulric-mk02, korlex-mk03,
phadai-mk03 — la gelée s'y ajoute), et `workers-food-03` deluxe (doc 07). Sacrifier une reine
(0.1 % de drop naturel par cycle de raising, sinon production dédiée à 1 %) doit rester un
événement — quantités faibles, effet fort.

## Vonix → wyrmhole

Le mod fait déjà `wyrmhole ← simik-boiler ← outposts` (recipe_graph). Le « vonix mk04 obtenu
par une mauvaise recette d'amorçage » se corrige en donnant au vonix une vraie chaîne :

- Créer `vonix-mk02..04` + breeding/maturing sur le gabarit des fichiers zipir
  (pyalienlife/prototypes/recipes/zipir/ comme modèle de structure).
- Produit d'élevage : le venin **[item exact à vérifier : venom]** — utilisé par pyhardmode ?
  non, par les primers/military (pyhardmode ajoute déjà zipirs à la military science : ne pas
  collisionner, cf. doc 07) — donner au venin un débouché propre : recettes d'amorçage
  d'AUTRES créatures (le « choix du diable » systématique ci-dessous).
- `wyrmhole` += `vonix-mk04` 1 : le trou de ver exige le serpent ultime.

## Règle transverse — amorçages « choix du diable »

À chaque tier mk02+ de chaque créature, l'amorçage propose deux recettes, toutes deux
coûteuses mais différemment :

1. **rapide** : consomme un produit TURD ou un item d'une AUTRE créature du même tier
   (interdépendance horizontale, cf. doc 01 pour les machines) ;
2. **lente** : autonome mais très longue et peu productive (cDNA, artificial blood — les
   items d'amorçage existants).

C'est un *choix entre deux coûts* (licite), pas une option gratuite. Le tableau exact
créature×tier se construit à l'implémentation, en s'appuyant sur l'inventaire du doc 07 pour
choisir les croisements qui ne créent pas de cycle.
