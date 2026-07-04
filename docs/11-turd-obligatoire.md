# TURD obligatoire — trois serrures, trois clés

## Mécanisme TURD vérifié (pyalienlife)

- `prototypes/turd.lua` charge ~60 fichiers d'upgrades (un par créature/bâtiment), activés
  selon les mods présents.
- Chaque voie génère des **variantes de recettes data-stage** aux produits signatures
  distincts. Exemple bhoddos (upgrades/bhoddos.lua) :
  - voie *meltdown* : recettes `bhoddos-N-meltdown` — plus rapides, sans substrat → volume ;
  - voie *exoenzymes* : recettes `-exoenzymes` — sous-produit `plutonium-oxide` ;
  - voie *spores* : `bhoddos-spore-upgraded` (spores ×10 depuis `rich-dust`) + effets cachés
    `change-recipe-productivity`.

Les trois voies d'une créature ont donc déjà des **sorties différenciées** — il n'y a qu'à
poser des serrures dessus.

## Le pattern

Pour rendre le TURD d'une créature incontournable sans scripting « au moins un choix » :
créer un item-serrure avec exactement trois recettes, chacune consommant la sortie signature
d'une voie :

```
item "bhoddos-concentrate" [nouveau]
  recette A ← ti-biomass ×N            (meltdown : payer en volume)
  recette B ← plutonium-oxide ×n       (exoenzymes : payer en complexité nucléaire)
  recette C ← bhoddos-spore ×N + rich-dust (spores : payer en logistique)
```

puis injecter la serrure dans un point de passage obligé : `py-science-pack-3`, un bâtiment
mk04, ou une rocket part. Le joueur choisit *comment* payer, jamais *si*.

Créatures candidates (voies aux sorties bien différenciées, à confirmer en relisant leurs
fichiers upgrades) : bhoddos, yotoi, zipir, arqad, mukmoux — une serrure chacune, réparties
sur py3/py4/production/utility/rocket parts pour étaler la pression.

Verrous à poser : les recettes A/B/C ne doivent débloquer QUE via la sous-techno TURD
correspondante (`add_unlock` sur la techno de la voie — vérifier comment turd.lua nomme les
sous-technos) ; et l'item-serrure ne doit avoir aucune autre source (bioprinting, caged
loops…).

## Rocket parts escaladantes

Même logique appliquée au spacemod (les technos SpaceX sont déjà remaniées par le mod) :

```
palier 1 (début SpaceX)  : rocket-part actuelle
palier 2 (mid SpaceX)    : techno "rocket-retooling-1" REMPLACE la recette :
                           += module mk2 [?], rocket-fuel → nuclear-fuel [?]
palier 3 (FTL)           : "rocket-retooling-2" : += module mk3, + serrure TURD dédiée
```

Remplacement par masquage : la techno cache l'ancienne recette (`recipe.hidden` via effet)
et débloque la nouvelle — pas de coexistence, principe « rien d'optionnel ». Les paliers se
calent sur les groupes de technos de SpaceModExpensivePatch/prototypes/technology-pyanodons.lua.

## Interaction pypostprocessing

Les items-serrures entrent dans des science packs → l'auto-tech va intégrer leurs chaînes
dans le calcul des prérequis. Les trois recettes ayant des chaînes amont très différentes,
vérifier que l'auto-tech prend bien le « OU » (première recette atteignable) et ne remonte
pas les trois — sinon l'arbre gonfle artificiellement. Test dédié dans le harnais (doc 01
§vérification).
