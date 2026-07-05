# Science packs — consommés PAR des items, pas pack ← pack

## Objectif

la famille **`earth-<espèce>-sample`**, fabriquée dans le bâtiment `data-array` est étendue ici pour consommer plus de types de packs de science

## Existant vérifié

Sources : `prototypes/recipes/recipes.lua`, `prototypes/recipes/<créature>/recipes-<créature>.lua`,
`prototypes/upgrades/data-array.lua` (pyalienlife, github.com/pyanodon/pyalienlife).

### La famille `earth-*-sample`

Recette racine, catégorie `data-array` (débloquée par `xenobiology`) :

```
earth-generic-sample ← iron-chest 1 + automation-science-pack 15 + bio-sample 10
```

Puis, pour chaque espèce, une recette `data-array` du même moule :

```
earth-<espèce>-sample ← earth-generic-sample 1 + <UN science pack> N + <espèce>-codex M
```

Le sample résultant est ensuite un ingrédient de la recette « from scratch » de la créature
(catégorie `creature-chamber`, ex. `phagnot ← … + earth-giraffe-sample 1 + phagnot-codex 2 + …`).
**C'est le point d'entrée réel** : chaque science pack utilisé ici finit par conditionner la
création d'une espèce entière.

### Diversité actuelle des packs consommés — 26 recettes `earth-*-sample` recensées

| Pack consommé | Occurrences | Espèces |
|---|---|---|
| `automation-science-pack` | 11 | generic, bee, bear, mouse, venus-fly, shroom, palmtree, giraffe, flower, sea-sponge, horse |
| `logistic-science-pack` | 7 | jute, cow, sunflower, strorix-unknown, potato, tropical-tree, crustacean |
| `chemical-science-pack` | 3 | lizard, wolf, roadrunner |
| `py-science-pack-3` | 3 | antelope, spider, goat |
| `py-science-pack-2` | 1 | tiger |
| `py-science-pack-4` | 1 | bat |
| `military-science-pack` | 0 | — |
| `production-science-pack` | 0 | — |
| `utility-science-pack` | 0 | — |
| `space-science-pack` | 0 | — |
| `py-science-pack-1` | 0 | — |

**Le trou à combler** : `py-science-pack-1`, `military-science-pack`, `production-science-pack`,
`utility-science-pack` et `space-science-pack` ne conditionnent la création d'aucune espèce.
`automation-science-pack` et `logistic-science-pack` portent à eux seuls 18 des 26 recettes.

### Familles sans `earth-*-sample` dédié — le gisement pour en ajouter

41 familles ont un dossier `prototypes/recipes/<nom>/`. 26 recettes `earth-*-sample` couvrent
15 d'entre elles (une espèce, `zungror`, en a deux : spider et goat). Les 26 restantes n'ont
**aucune** recette `earth-*-sample` dédiée. Parmi elles :

- **5 sans mécanisme de bootstrap du tout** (`fish`, `guar`, `moss`, `sap`, `seaweed`, `tree`) :
  pas de `-codex`, pas de recette `creature-chamber` — plantes/poissons simples, pas de bonne
  cible (trop tôt, principe 4).
- **13 avec un `-codex` vérifié** (donc structurellement éligibles au même mécanisme) mais qui
  soit n'ont **aucun** sample (`kmauts`, `moondrop`), soit **empruntent** le sample d'une autre
  espèce au lieu d'avoir le leur : `xeno` (emprunte `earth-generic-sample` + `strorix-unknown-sample`
  → automation + logistic), `korlex` (`earth-cow-sample` → logistic), `dhilmos`/`xyhiphoe`
  (`earth-crustacean-sample` → logistic), `trits` (`earth-crustacean-sample` +
  `earth-cow-sample` → logistic ×2), `yaedols`/`navens`/`bhoddos` (`earth-shroom-sample` →
  automation), `cadaveric-arum` (`earth-tropical-tree-sample` + `earth-flower-sample` →
  logistic + automation), `vonix` (`earth-wolf-sample` + `earth-flower-sample` → chemical +
  automation), `vrauks` (tech trop précoce, automation ×1 seulement — à laisser de côté).

`recipes-kmauts.lua` contient même un commentaire des auteurs pY laissé en l'état :
`-- add alien sample from pyALiens mod here`. C'est littéralement une case vide qu'ils ont
prévue et jamais remplie.

## Proposition

### 1. Deux ajouts entièrement chiffrés, prêts à implémenter

Choisis pour combler un pack absent **et** vérifiés contre la technologie de déblocage réelle
de l'espèce (le pack ajouté doit être un pack que cette techno consomme déjà, sinon on
punirait avant l'heure — principe 4) :

| Nouvel item | Recette (`data-array`) | Pourquoi ce pack |
|---|---|---|
| `earth-kmauts-sample` | earth-generic-sample 1 + **py-science-pack-1** 5 + kmauts-codex 1 | tech `kmauts` consomme déjà `py-science-pack-1` ×1 ; `kmauts` n'a aujourd'hui aucun sample — comble le TODO des auteurs |
| `earth-xeno-sample` | earth-generic-sample 1 + **military-science-pack** 10 + xeno-codex 1 | tech `xeno` consomme déjà `military-science-pack` ×2 (et `production-science-pack` ×1, cf. §2) ; `xeno` n'a aujourd'hui aucun sample dédié |

Branchement (ajout d'ingrédient sur la recette `creature-chamber` existante, sans rien retirer) :

```lua
data:extend {
    {
        type = "recipe",
        name = "earth-kmauts-sample",
        category = "data-array",
        enabled = false,
        energy_required = 300,
        ingredients = {
            {type = "item", name = "earth-generic-sample", amount = 1},
            {type = "item", name = "py-science-pack-1",    amount = 5},
            {type = "item", name = "kmauts-codex",         amount = 1},
        },
        results = {{type = "item", name = "earth-kmauts-sample", amount = 1}},
    },
    {
        type = "recipe",
        name = "earth-xeno-sample",
        category = "data-array",
        enabled = false,
        energy_required = 300,
        ingredients = {
            {type = "item", name = "earth-generic-sample",   amount = 1},
            {type = "item", name = "military-science-pack",  amount = 10},
            {type = "item", name = "xeno-codex",              amount = 1},
        },
        results = {{type = "item", name = "earth-xeno-sample", amount = 1}},
    },
}
RECIPE("kmauts"):add_unlock("xenobiology") -- si pas déjà prérequis, cf. points durs
RECIPE("kmauts"):add_ingredient {type = "item", name = "earth-kmauts-sample", amount = 1}
RECIPE("xeno"):add_ingredient {type = "item", name = "earth-xeno-sample", amount = 1}
```

Effet : `py-science-pack-1` et `military-science-pack` sortent tous les deux du néant — 2 des
5 packs absents couverts, 2 nouveaux items dans la famille, zéro recette existante retirée.

### 2. `production-science-pack` et `utility-science-pack` — un cran plus haut, pas à la base

Aucune techno de **déblocage de base** n'exige ces deux packs (vérifié sur les 18 technos de
créatures inspectées) : ils n'apparaissent qu'aux tiers `mk02+` (`xeno-mk02`/`vonix-mk02`
demandent `production-science-pack`, `xeno-mk04`/`vonix-mk04` demandent `utility-science-pack`).
Or ces tiers n'ont **pas** de recette `creature-chamber` unique à eux — ce sont des recettes
« module » multipliées (`recipes-xeno-modules.lua`, une recette par organe/tier). Accrocher
`production`/`utility` à la base (comme au §1) serait donc **anachronique** : le joueur les
aurait en main bien avant que la techno ne les demande.

Proposition : créer `earth-xeno-sample-mk02` (production-science-pack) et
`earth-xeno-sample-mk04` (utility-science-pack), consommés en plus de l'`alien-sample-03`
déjà présent dans les recettes de modules `xeno-mk02`/`xeno-mk04` correspondantes. **[à
vérifier]** identifier la ligne exacte de `recipes-xeno-modules.lua` par tier avant
d'implémenter — pas fait ici pour éviter d'inventer un montant.

### 3. `space-science-pack` — pas de bon point d'ancrage, à ne pas forcer

Aucune technologie de créature ne le demande ; seule `land-animals-mk05` (jalon générique) le
consomme. Le forcer dans la famille `earth-*-sample` serait une invention sans base dans les
sources — le rebalance SpaceX déjà présent dans ce mod (`spacemod.lua`) est l'endroit legitime
pour ce pack, pas la génétique. Recommandation : **ne pas** l'ajouter ici.

### 4. Suite du chantier — les 11 familles restantes

Même méthode (vérifier le profil de packs de la techno de base, choisir le pack le plus rare
à ce palier, ajouter une recette `earth-<espèce>-sample` puis la brancher en ingrédient
supplémentaire de la recette `creature-chamber` existante) :

| Famille | Profil de packs de la techno de base (vérifié) | Sample actuel (à garder ou remplacer) |
|---|---|---|
| `korlex` | automation, py1, logistic | `earth-cow-sample` (logistic) |
| `dhilmos` | automation ×4, py1, logistic, py2, chemical | `earth-crustacean-sample` (logistic) |
| `trits` | automation ×4, py1, logistic, py2 | `earth-crustacean-sample` + `earth-cow-sample` (logistic ×2) |
| `vonix` | automation ×5, py1, logistic, py2, chemical, py3 | `earth-wolf-sample` (chemical) + `earth-flower-sample` (automation) |
| `xyhiphoe` | — [à vérifier, fichier techno non localisé] | `earth-crustacean-sample` (logistic) |
| `navens` | automation ×4, py1, logistic, py2 | `earth-shroom-sample` (automation) |
| `bhoddos` | automation, py1, logistic, py2 | `earth-shroom-sample` (automation) |
| `cadaveric-arum` | automation, py1, logistic, py2 | `earth-tropical-tree-sample` + `earth-flower-sample` |
| `yaedols` | automation ×4, py1, logistic | `earth-shroom-sample` (automation) |
| `moondrop` | automation ×1 (très précoce) | aucun — laisser (principe 4) |
| `vrauks` | automation ×1 (très précoce) | aucun — laisser (principe 4) |

Aucune de ces technos de base n'atteint military/production/utility/space — cohérent avec le
§2/§3 : ces 5 packs ne se placent qu'à la base pour `kmauts`/`xeno` (§1) ou plus haut dans
l'arbre MK (§2), jamais en forçant une techno de base à un tier qu'elle n'a pas.

## Points durs

- **[à vérifier]** `kmauts`/`xeno` sont-ils prérequis par `xenobiology` (tech qui débloque
  `earth-generic-sample`) ? Si l'ordre technologique ne le garantit pas déjà, ajouter le
  prérequis pour éviter une recette accessible avant son ingrédient.
- Ne pas dupliquer un pack déjà rare ailleurs dans le mod à cette étape (cf. doc 01, toile
  intra-niveau) — vérifier l'arbre recalculé après ajout, pas seulement la source pyalienlife.
- `earth-kmauts-sample`/`earth-xeno-sample` ajoutent un ingrédient à des recettes
  `creature-chamber` déjà riches (kmauts : 5 ingrédients ; xeno : 9) — energy_required (300 pour
  le sample, calqué sur `earth-giraffe-sample`) à recalibrer si le temps de craft total devient
  déraisonnable en pratique.
- §2 (production/utility sur les tiers mk02/04) dépend de recettes de modules qui existent déjà
  pour `xeno` — vérifier que `vonix` (alternative possible) a bien sa chaîne mk02-04 avant de
  s'y brancher : le doc 08 note que la chaîne d'élevage complète de vonix **n'est pas encore
  construite**, donc `xeno` est le choix sûr pour l'instant.

---

## Anciennes pistes (rejetées) — conservées pour mémoire

### Pack N ← pack N−1

Chaque pack de rang N consomme le pack de rang N−1. Rejeté : un pack ne doit pas consommer un
autre pack (principe 1).

### Packs consommant `alien-sample-02/03`/`perfect-samples`

Ces items sont déjà des *ingrédients des packs* (l'inverse de ce qui est demandé) — proposer de
leur faire consommer des packs supplémentaires revient à inverser leur rôle dans la recette, ce
qui n'est ni vérifié ni cohérent avec leur usage actuel (matière première génétique, pas
sous-produit de recherche). Abandonné au profit de la famille `earth-*-sample` ci-dessus, qui
est la vraie famille « pack → item ».
