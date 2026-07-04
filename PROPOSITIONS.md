# Propositions détaillées — py-expensive-mode

> **Remplacé pour le détail par [docs/00-index.md](docs/00-index.md)** (un document par
> concept, chaînes concrètes, sources en ligne, mods pY clonés et vérifiés). Ce fichier reste
> comme synthèse ; en cas de divergence, les docs font foi.

Compagnon de [IDEES.md](IDEES.md) : pour chaque idée, une proposition concrète avec les noms
d'items/recettes réels vérifiés dans les sources locales (pyalienlife, pyalternativeenergy,
pycoalprocessing, pyhardmode). Les faits non vérifiables localement (pyrawores,
pypetroleumhandling, pyhightech absents du disque) sont marqués **[à vérifier]**.

---

## 0. Principes révisés

### 0.1 Pas d'optionnel

Le cœur du mod est d'être *plus cher*. Une recette alternative « plus chère mais plus
productive » n'est pas un coût, c'est une optimisation offerte au joueur — abandonné.
Toute dépendance ajoutée doit être **obligatoire**. Trois techniques pour rendre obligatoire
sans créer de cercle vicieux dans l'arbre des technologies :

1. **L'ingrédient va dans le bâtiment, pas dans le produit.** Un bâtiment se fabrique une fois,
   son coût peut donc inclure des items très chers (montures, armures, autres machines) sans
   casser les ratios de production. C'est le mécanisme de tout le §1.
2. **Contrainte de température `minimum`, pas `maximum`.** « Le BOF MK4 n'accepte que ≤400° »
   rend le métal chaud *inutile* ; « la recette du BOF MK4 exige ≥400° » rend le métal chaud
   *obligatoire* pour profiter de la machine rapide. Voir §4.
3. **Le seul consommateur possible.** Si l'item revalorisé est le seul chemin vers un produit
   indispensable (science pack, rocket part, bâtiment MK4), il est de fait obligatoire.

Le *choix* reste licite quand il porte sur **comment payer, pas si on paye** : les trois voies
TURD (§7), le choix des recettes de craquage, le panachage des solutions nourriture (§6.3).

### 0.2 Nouveau pilier : dépendances intra-niveau

Constat vérifié dans les sources — au tier 1, les machines dépendent les unes des autres :

- `geothermal-plant-mk01` ← 4× `electric-mining-drill` (pyAE, geothermal-plant-mk01.lua)
- `uranium-mining-drill` ← 1× `automated-factory-mk01` (pyAE)
- `nuclear-reactor-mox-mkN` ← 1× `nuclear-reactor-mkN` — **du même tier** (pyAE, les 4 MK)
- `solar-tower-heilostat` ← `mirror-mk03`, `solar-tower-megastructure` ← `solar-tower-building`

Mais à partir du MK2, le pattern devient uniformément : *machine N−1 + plaques + circuits +
small-parts du tier*. Exemple type (auog-paddock.lua) :

```
mk01 : stone 100, soil 300, iron-plate 80, bolts 50
mk02 : mk01 + titanium-plate 35, electronic-circuit 10, duralumin 50, small-parts-02 30
mk03 : mk02 + nbti-alloy 25, advanced-circuit 20, neuromorphic-chip 30, py-heat-exchanger 1, small-parts-03 30
mk04 : mk03 + science-coating 15, processing-unit 30, low-density-structure 30, metallic-glass 10
```

Seul le `py-heat-exchanger` du mk03 échappe au générique. **Réintroduire la toile de
dépendances à chaque niveau est le chantier n°1** — il porte à lui seul la moitié des autres
idées (revalorisation des items orphelins §11, montures §3, capstone §8).

---

## 1. La toile intra-niveau (tier web)

Deux mécanismes complémentaires, à doser pour ne pas tout uniformiser.

### 1.1 Composants signatures étrangers (systématique, outillé)

La chaîne éolienne de pyAE fournit une famille complète d'intermédiaires « à la IR3 » déjà
existante — utilisée par l'éolien ET par les `mechanical-parts-0N` (correction : voir l'audit
dans [docs/02-composants-mk.md](docs/02-composants-mk.md)) :

`shaft-mk01..04`, `gearbox-mk01..04`, `brake-mk01..04`, `controler-mk01..04`,
`utility-box-mk01..04`, `electronics-mk01..04` (items-wind.lua — les 6 familles vont bien
jusqu'au mk04).

**Règle** : tout bâtiment mkN (N ≥ 2) reçoit 2 composants signatures issus de familles
étrangères à la sienne, choisis dans un pool par tier :

| Tier | Pool de donneurs (items vérifiés) |
|---|---|
| 2 | `electronics-mk02`, `gearbox-mk02`, `shaft-mk02`, `utility-box-mk02`, `nexelit-battery`, `py-heat-exchanger` |
| 3 | `electronics-mk03`, `gearbox-mk03`, `brake-mk03`, `controler-mk03`, `neuromorphic-chip`, monture tier 3 (§3) |
| 4 | `electronics-mk04`, `gearbox-mk04`, `controler-mk04`, `utility-box-mk04`, `self-assembly-monomer`/`metallic-glass` **[noms à vérifier]**, monture tier 4 (§3) |

**Implémentation** — nouveau `lib/tier-web.lua`, affectation *déterministe* (pas de
`math.random`, il faut la même data à chaque chargement) par hash du nom :

```lua
-- pyem.tier_web{pattern = "%-mk0(%d)$", donors = DONORS, exclude = {...}}
-- Pour chaque recette de bâtiment matchant le pattern :
--   local h = simple_hash(recipe.name)
--   ajoute donors[tier][1 + h % #pool] et donors[tier][1 + (h // #pool) % #pool]
--   en excluant les donneurs de la même famille (table famille→items à maintenir).
```

Quantités : composants 5–20 par bâtiment (calqué sur les 30 `small-parts-0N` existants),
machines/montures : 1.

**Pourquoi outillé plutôt que curaté** : ~150 bâtiments mk02-04 dans pyAL+pyAE seuls. La
curation manuelle ne passera pas à l'échelle ; en revanche on garde une **table d'overrides**
pour les cas thématiques (§1.2) et les exclusions (machines déjà très chères).

### 1.2 Toile machine→machine (curatée, thématique)

Généraliser le pattern MOX (`nuclear-reactor-mox-mkN` ← `nuclear-reactor-mkN`) : chaque
bâtiment mkN reçoit **un** bâtiment étranger de tier N ou N−1, justifié thématiquement.
Amorce de matrice (une dizaine de paires pour commencer, toutes **[à valider contre l'arbre
des technos]**) :

| Receveur | Donneur | Thème |
|---|---|---|
| `ez-ranch-mkN` | `auog-paddock-mkN` | l'élevage générique s'appuie sur l'élevage de base |
| `mukmoux-pasture-mkN` | `moss-farm-mkN` | pâturage = fourrage |
| `dhilmos-pool-mkN` | `fish-farm` (+1 par tier) | bassins interconnectés |
| `genlab-mkN` | `incubator` (+1 par tier) | le labo incube |
| `fluid-drill-mkN` | `micro-mine-mkN` | forage ↔ mine |
| `centrifuge-mkN` (pyAE) | `steam-turbine-mkN` | équilibrage du choc électrique |
| `heat-exchanger-mkN` (pyAE) | `electric-boiler` (+N) | chaîne thermique |
| `biomass-powerplant-mkN` | `compost-plant` (+N) | filière biomasse |

Garde-fou anti-explosion : le donneur est toujours **feuille** dans `pyem.recipe_graph` (un
bâtiment déjà receveur d'une chaîne verticale peut être donneur, jamais l'inverse au même
tier), sinon la profondeur du graphe fait exploser les quantités calculées.

### 1.3 Vérification (indispensable, à faire en premier)

Étendre `lib/recipe-graph.lua` + `tests/` (le harnais `mock_factorio.lua` existe) :

1. **Détection de cycles** sur le graphe complet recettes+ingrédients après application du
   tier web (pas seulement sur les chaînes déclarées).
2. **Contrôle d'ordre technologique** en `data-final-fixes`, après pypostprocessing : pour
   chaque ingrédient ajouté, vérifier `tech(ingredient) ≤ tech(recette)` dans l'arbre
   recalculé ; logger les violations au lieu de crasher. C'est LE risque du chantier :
   pypostprocessing déplace les technos quand les ingrédients changent.

---

## 2. Ratios science packs (N → N−1)

État vérifié : les recettes de packs pY sont déjà riches (py-science-pack-2 : moss 400,
zipir-eggs 15, arqad-honey 600, casein 30… → 18 packs ; production-science-pack vanilla
remaniée par pyCP : speed-module-2, efficiency-module-2, uranium-fuel-cell, coal-briquette…)
mais **aucun pack ne consomme de pack**.

**Proposition** : chaque pack de rang N consomme le pack de rang N−1, dans l'ordre pY :
`automation → py1 → logistic → military → py2 → chemical → py3 → production → py4 →
utility → space`.

**Attention à la multiplication en cascade** : un facteur k appliqué à 10 étages coûte k^10 en
packs rouges. Chiffrage proposé (par pack produit, en tenant compte des tailles de lot — la
recette py2 sort 18 packs) :

| Pack | Consomme | Coût cumulatif en automation-sp (k=0.5) |
|---|---|---|
| py1 | 0.5 automation-sp | 0.5 |
| logistic | 0.5 py1 | 0.25 |
| military | 1 logistic | 0.25 |
| py2 | 0.5 military | 0.125 |
| … | … | … |

Avec k=0.5 le cumul reste borné (< 1 pack rouge par pack final) tout en forçant à *maintenir
en production* toutes les chaînes de science précédentes — c'est l'effet recherché, pas le
gonflement du coût de recherche. Exposer k en startup setting
(`pyem-science-chain-factor`, défaut 0.5, 0 = off). Implémentation : boucle sur la liste
ordonnée + `add_ingredient` avec arrondi au multiple de la taille de lot.

Le « 3 ASP → 6 SP » de tes notes se paramètre dans cette même table (k=2 sur les étages
concernés) une fois qu'on a identifié les paires exactes que tu visais.

---

## 3. Montures, armures, mechanical parts — version obligatoire

Le désalignement techno se contourne en appliquant le principe 0.1-1 : **les montures entrent
dans les bâtiments, pas dans les mechanical parts consommés en masse**.

1. **Armure N → monture N** (le packing d'armures du mod existe pour ça) :
   - `crawdad` ← 3× `heavy-armor` packée ; `dingrido` ← 3× `modular-armor` packée ;
   - `phadaisus` ← 2× `power-armor` packée ; `spidertron` ← 1× `power-armor-mk2` packée.
   L'alignement exact (les montures se débloquent aux technos `domestication-mkN`,
   les armures à côté) est **[à vérifier]** — si une armure arrive après sa monture,
   prendre l'armure du rang inférieur.
2. **Monture N → bâtiments N+1** via la toile du §1 : les montures entrent au pool de
   donneurs tiers 3-4 pour les familles « de plein air » : `fluid-drill-mk03` ← `crawdad`,
   `ree-mining-drill-mk04` ← `dingrido`, `micro-mine-mk04` ← 1 animal de trait
   (`digosaurus`/`thikat`/`work-o-dile`, déjà chaînés par le mod).
3. **Mechanical parts** : pour boucler mech part N → armure N → monture N → mech part N+1
   sans mettre une monture par craft, utiliser le **catalyseur à retour probabiliste**
   (précédent vérifié : l'arqad-queen revient avec `probability = 0.999` dans les recettes de
   raising) :

```lua
RECIPE("mechanical-parts-03")  -- items pyAE, mechanical-parts-01..04 vérifiés
    :add_ingredient {type = "item", name = "crawdad", amount = 1}
    :add_result {type = "item", name = "crawdad", amount = 1, probability = 0.98,
                 ignored_by_productivity = 1, ignored_by_stats = 1}
```

   → la bête de trait « actionne » la chaîne et s'use (2 % par craft). Consommation réelle
   réglable par la probabilité, sans casser les ratios de masse. Interdire les modules de
   productivité sur ces recettes ou marquer le retour `ignored_by_productivity` (fait
   ci-dessus) pour éviter la duplication de montures.

---

## 4. Températures

Tout est data-stage : `minimum_temperature`/`maximum_temperature` sur les ingrédients fluides,
`temperature` sur les produits. pyrawores n'est pas sur le disque : les noms exacts des
fluides fondus et des categories du BOF sont **[à vérifier]**.

### 4.1 Métaux fondus à paliers — version obligatoire

- Recettes de fonte par étage : sortie à 100° (processed), 200° (unslimed), 300° (pulp),
  400° (reduced), 500° (sintered). Modification : `results[].temperature` des recettes
  existantes, aucun nouvel item.
- **Recettes de plaques par tier de BOF avec `minimum_temperature`** (principe 0.1-2) :

| Recette | Category (tier BOF) | Contrainte | Rendement |
|---|---|---|---|
| plaques-mk01 | bof-mk01 | ≥ 100° | 100 fondu → 50 plaques |
| plaques-mk02 | bof-mk02 | ≥ 200° | → 75 |
| plaques-mk03 | bof-mk03 | ≥ 300° | → 100 |
| plaques-mk04 | bof-mk04 | ≥ 400° | → 135 |

  Le BOF MK4 (rapide, indispensable au débit end-game) **exige** du métal de haut étage : le
  chaud est obligatoire, pas optionnel. Le fer garde son 5e palier (500°) comme recette
  exclusive du BOF MK4 à 150 plaques — asymétrie assumée, esprit pY. La productivité est dans
  la recette, donc pas besoin d'autoriser les modules de prod sur le BOF.
- **Alliages avancés** : `minimum_temperature` sur l'ingrédient fondu selon la position dans
  l'arbre — cibles vérifiées côté consommateurs : `nbti-alloy`, `nbfe-alloy`, `duralumin`,
  `stainless-steel`, `ns-material`, `metallic-glass`.

### 4.2 Fenêtre intermédiaire (50° < T < 60°)

Factorio ne calcule pas les mélanges : recettes de trempe explicites, dans un bâtiment simple
(heat-exchanger pyAE existant en mk02-04) :

```
"tempering-<fluide>" : 50 <fluide>@≥100° + 50 <fluide>@≤20° → 100 <fluide>@55°
```

Chaque branche (production chaude / production froide) avec des ingrédients suffisamment
différents pour que les pénuries soient asymétriques. Commencer par UNE fenêtre sur UN fluide
end-game pour valider l'UX avant de décliner par tranches de 10°.

### 4.3 Bascule automatique façon four

La sélection de recette des furnaces se fait par ingrédient, pas par température → prototyper
avant de promettre ; repli : deux recettes à plages disjointes, choix manuel.

### 4.4 Variété des étages reduced/sintered

Chaque métal pioche son ingrédient d'étage dans une **famille différente** (tableau de
correspondance à écrire au moment de l'implémentation, un croisement par métal) : fer ←
vivant (bonemeal/blood), aluminium ← pétrochimie, titane ← circuits, nickel ← biomasse, etc.
S'appuyer sur la liste des sous-produits « junk » recyclés par pyhardmode (README) comme
vivier : `limestone`, `bonemeal`, `tar`, `creosote`, `anthracene-oil`, `sand`…

---

## 5. Chocs de carburant

Précédent du choc : les centrifugeuses (électricité). Deux implémentations possibles, à
panacher :

1. **Ingrédient combustible dans la recette** (lisible dans les planners ; précédent vérifié :
   `production-science-pack` pyCP contient `coal-briquette` 5 + `uranium-fuel-cell` 1) :
   les recettes du BOF gagnent `coal-briquette`/`coke` **[noms pyrawores à vérifier]**.
2. **Conversion en burner** (vrai choc logistique : il faut *alimenter* la machine) :
   `energy_source = {type = "burner", fuel_categories = {...}}`. Précédent pY vérifié :
   `auog-generator` brûle la catégorie `auog`, les caravanes mangent de la nourriture.

**Différenciation biomasse/fossile** : deux fuel-categories nouvelles (`pyem-biofuel`,
`pyem-fossil`) ; ajouter la catégorie aux items concernés sans retirer `chemical` (les usages
existants survivent). BOF = choc solide 1 (fossile), sinter plant = choc solide 2, un choc
biomasse sur une machine du vivant (bio-reactor ou biofactory), choc liquide sur l'advanced
foundry **[à vérifier]**, choc chaleur = aligné sur pyhardmode (§9).

---

## 6. Vivant

### 6.1 Bâtiments d'élevage à la nourriture

Conversion burner par créature — les briques existent toutes :

- fuel-categories par créature déjà présentes : `dingrit-food`, `phadai-food`, `fish`, `auog`
  (fuel-categories.lua) ; en créer pour les autres (`mukmoux-food`, `zipir-food`…).
- items nourriture par créature déjà présents en deux qualités : `X-food-01` / `X-food-02`
  vérifiés pour arthurian, ulric, mukmoux, dhilmos, phadai, auog, fish, dingrits, phagnot,
  zipir, vrauks, korlex, simik (+ `cottongut-food-01..03`).
- **Règle** : bâtiments mk01-02 brûlent `X-food-01`, mk03-04 exigent `X-food-02`
  (fuel-category distincte pour le food-02 afin que le mk04 ne puisse pas brûler du 01).
- `fuel_value` à calibrer pour que la consommation reflète le « métabolisme » (les foods ont
  aujourd'hui des valeurs faibles type 2.5 MJ — viser une nourriture consommée en continu,
  quelques items/min par bâtiment).

Ça remplace la boucle « Auog exige de la nourriture qui exige des Auog » de tes notes : la
redondance disparaît puisque la nourriture est le carburant, pas un ingrédient de plus.

### 6.2 Nourriture qualité ← standard

`pyem.recipe_chain` sur chaque paire : `X-food-02` ← `X-food-01` (~14 couples listés en 6.1),
`cottongut-food-03` ← `-02` ← `-01`, et `workers-food-03` ← `-02` ← `-01` (chaîne déjà
existante dans pyAL : wf-02 consomme 4 wf, wf-03 consomme 4 wf-02 — vérifier les quantités
après passage du depth-factor du mod).

### 6.3 Créature MK sans nourriture au déblocage

Inventaire à faire (script : pour chaque techno de créature mkN, la recette de `X-food-0Y`
est-elle atteignable ?), puis panacher les 4 solutions de tes notes **en fonction du TURD de
la créature** (chaque fichier `prototypes/upgrades/<créature>.lua` dit ce que les voies
favorisent) : si une voie TURD booste déjà la bouffe, déplacer le déblocage ; sinon nourriture
basique ou workers-food du niveau atteint.

### 6.4 Zipir ↔ Xyhiphoe

Items vérifiés : `zipir1..4` (tiers créature), `zipir-eggs`, `zipir-pup`, `zipir-food-01/02` ;
`xyhiphoe`, `xyhiphoe-mk02..04`, `xyhiphoe-cub(-mk02..04)`, `shell-xyhiphoe`, `blood-xyhiphoe`,
`guts-xyhiphoe`, `meat-xyhiphoe` ; fluide `blood`.

- **Niveau 1 (interconnexion simple)** : la recette `zipir-eggs` gagne `shell-xyhiphoe` 2 ;
  le maturing de `xyhiphoe-cub` gagne `meat` de zipir (larve mange du Zipir) ; les recettes
  d'élevage des deux gagnent du fluide `blood` (ou le déplacer sur les poissons/Navens — les
  `navens-mkN-breeder` consomment déjà des `xyhiphoe-mkN` via les tweaks du mod).
- **MK2+ (amorçage croisé non-chuntable)** : une recette d'amorçage double par tier, sortie en
  *deux nouveaux items jetables* qui ne servent qu'à amorcer chacun son côté :

```
"tidepool-symbiosis-mk0N" (très lente, chère) :
  zipir(N−1) 2 + xyhiphoe-mk0(N−1) 2 + arqad-honey + workers-food-0X
  → "shell-cluster-mk0N" 1 + "blood-clot-mk0N" 1

amorçage xyhiphoe-cub-mk0N ← shell-cluster-mk0N
amorçage zipir(N) ← blood-clot-mk0N
```

  Deux items nouveaux par tier (6 au total), aucun n'est réutilisable ailleurs → impossible de
  détourner l'amorçage, et les deux espèces montent forcément ensemble.

### 6.5 Gelée royale (arqad queen)

La queen revient aujourd'hui avec `probability = 0.999` (raising) et 0.01 en production
(recipes-arqad-raising.lua). Nouvel item `royal-jelly` :

```
"royal-jelly" : arqad-queen 1 (SANS retour) + arqad-honey 100 → royal-jelly 5
```

consommé par : les amorçages `arqad-mk0N-breeding` (cohérent avec les tweaks arqad existants
du mod) et la deluxe workers-food (§6.6). Sacrifier une reine doit faire mal — c'est le point.

### 6.6 Workers food

- Réintroduire l'« ancienne recette du diable » pour la deluxe (`workers-food-03`) + y mettre
  `royal-jelly`.
- Injecter des items MK2-3 dans `workers-food` et `workers-food-02` (ex. `guts-xyhiphoe`,
  abats mk02) — obligatoire, pas en recette parallèle (principe 0.1).

### 6.7 Vonix / wyrmhole

`vonix` n'a ni tiers mk ni chaîne d'élevage complète (seulement `vonix-eggs`, art, TURD dans
upgrades/vonix.lua) — le « Vonix mk4 par mauvaise recette d'amorçage » de tes notes.
Proposition : créer la chaîne breeding/maturing mk02-04 sur le modèle des fichiers zipir
(`recipes/zipir/…` comme gabarit), avec le venin comme produit d'élevage pour qu'elle serve à
autre chose que le wyrmhole. Le `recipe_graph` wyrmhole du mod reste tel quel — il consommera
naturellement le mk04 propre.

---

## 7. TURD obligatoire

Mécanisme vérifié (upgrades/bhoddos.lua) : chaque voie TURD génère des **variantes de
recettes** data-stage (`bhoddos-N-meltdown`, `-exoenzymes`, `bhoddos-spore-upgraded`…) avec
des produits signatures distincts (biomasses, `plutonium-oxide`, spores boostées).

**Pattern « trois serrures, trois clés »** : pour rendre un TURD obligatoire sans scripting,
créer un item indispensable avec exactement trois recettes, chacune consommant le produit
signature d'UNE voie :

```
item "bhoddos-concentrate" (requis dans py-science-pack-3, par ex.)
  recette A ← ti-biomass (voie meltdown : ça explose en volume)
  recette B ← plutonium-oxide (voie exoenzymes : complexité nucléaire)
  recette C ← bhoddos-spore ×N (voie upgraded : complexité logistique)
```

Le joueur choisit *comment* payer, pas *si* (principe 0.1). Décliner sur 4-5 créatures dont
les TURD ont des produits signatures nets (bhoddos, yotoi, zipir, arqad…), un item-serrure par
créature, injecté dans les science packs pY ou les bâtiments MK4.

**Rocket parts escaladantes** : même mécanisme au niveau des `rocket-part` — par palier de
science SpaceX (les technos sont dans SpaceModExpensivePatch/technology-pyanodons.lua), la
recette de rocket part est remplacée (`Module MK1 → MK2 → MK3`, `rocket-fuel →
nuclear-fuel`…) via des technos successives à effet `recipe-unlock` + masquage de l'ancienne
— pattern déjà utilisé par le rebalance spacemod du mod.

---

## 8. Casting avancé & intermédiaires capstone

### 8.1 Réutiliser l'existant comme intermédiaires IR3

Ne PAS créer tige/câble/piston : **les 6 familles éoliennes (§1.1) sont exactement ça** et
sont déjà dessinées, localisées, équilibrées. Le chantier consiste à les sortir du ghetto
éolien :

- via la toile intra-niveau (§1.1) — leur débouché principal ;
- dans les `mechanical-parts-0N` : `+ shaft-mkN 2 + gearbox-mkN 1` (pyAE injecte déjà
  `electronics-mk02..04` dans les circuits vanilla, base-updates.lua — même geste) ;
- deux **produits finaux nouveaux** par tier, consommés par les bâtiments mk03-04 et le
  spacemod :

```
"drivetrain-mkN"      = shaft-mkN + gearbox-mkN + brake-mkN + mechanical-parts-0N
"control-station-mkN" = controler-mkN + utility-box-mkN + electronics-mkN + circuits du tier
```

### 8.2 Bâtiment de casting

- Entité `assembling-machine` « py-foundry-advanced », 10-12 fluid boxes d'entrée
  (supporté par le moteur ; les gros bâtiments pY multi-pipes servent de gabarit graphique).
- Recettes : métaux fondus ≥ 400° (lien §4 — le casting est le 2e consommateur obligatoire du
  métal chaud) → directement `advanced-small-parts`/ASP, SSP, `drivetrain-mkN` coulés.
- **Moules** : un item par pièce, catalyseur à retour probabiliste (le pattern queen §3) :

```
"mold-drivetrain" : electronics-mk01 20 + mechanical-parts-02 5 + intermetallics 10 → 1
recette de coulée : ... + mold-drivetrain 1 → produit + mold-drivetrain (probability 0.9)
```

  Le moule est le puits principal d'`electronics-mk01` (item vérifié quasi-orphelin :
  nacelle-mk01 et fast-inserter-2 seulement).

---

## 9. Hard mode

pyhardmode vérifié (README) : chaleur (incubator, simik den, cracker, advanced foundry, heavy
oil refinery convertis à la chaleur ; burners produisent de la chaleur ; décroissance 2°/tuile),
nerf du voiding, spoilage, créatures optionnelles rendues utiles (zipirs dans la military
science, mukmoux dans la chemical…).

- **Phase 1 — cohabitation** : dépendance optionnelle + garde-fous : quand pyhardmode est
  présent, pyem n'ajoute pas ses propres exigences là où pyhardmode a déjà frappé (il fait
  déjà « zipirs → military science » : ne pas doubler). Table de détection par recette.
- **Phase 2 — emprunts** : si on veut les mécaniques sans la totalité du mode, porter
  uniquement : le choc chaleur (§5) en réutilisant leur pattern burner→heat, et le macguffin
  end-game **[mécanique à relire dans leurs sources au moment venu]**.

---

## 10. Familles de modules

Inchangé : priorité basse, gros coût d'équilibrage, concurrence les modules-créatures de pyAL
(module-categories.lua existant). À ne rouvrir que si tout le reste est stabilisé.

---

## 11. Filières énergie pyAE obligatoires

Inventaire des familles (buildings pyAE vérifiés) et de leur « signature » à revaloriser :

| Filière | Items signatures | Puits obligatoire proposé |
|---|---|---|
| Éolien HAWT/VAWT/multiblade | nacelle, yaw-drive, blades, vanes | déjà chaîné par le mod ; débouché §1/§8 |
| Solaire (panels, anti-solar, tour, concentrateurs) | `mirror-mk03`, `solar-tower-panel`, `stirling-concentrator` | composant SpaceX « solar array » + capstone |
| Nucléaire (reactor, MOX, breeder) | `neutron-moderator-mk01..04`, `neutron-absorber` | rocket parts nucléaires (§7) |
| Géothermie | `geothermal-plant-mk01` | choc chaleur §5 (source imposée) |
| Marémoteur `tidal-mk01..04` | turbines tidal | drydock SpaceX (structure marine) |
| Micro-ondes/laser (`microwave-receiver`, `mdh`, `lrf`) | récepteurs, panneaux lrf | composant SpaceX « FTL » / fusion generator |
| RTG | `rtg` | fusion-generator (déjà dans le patch spacemod) |
| Thermique (coal/gas/oil/biomass powerplants) | powerplants mkN | toile §1.2 (choc électrique de croissance) |

Principe 0.1-3 : chaque filière devient *le seul chemin* vers un composant du spacemod ou un
produit capstone — le rebalance SpaceX du mod est le véhicule naturel, les composants sont
déjà à nous.

---

## 12. Ordre d'attaque révisé

1. **Outillage de vérification** (§1.3) — sans lui, tout le reste est de la roulette russe.
2. **Toile intra-niveau** (§1) + injection des composants éoliens (§8.1, sans le casting).
3. **Vivant** (§6) : burner-food, chaînes food-02←01, zipir/xyhiphoe, royal-jelly.
4. **Science packs** (§2) + montures obligatoires (§3).
5. **Températures** (§4) + chocs carburant (§5) — nécessite de vérifier pyrawores.
6. **Casting + capstone** (§8.2), TURD obligatoire (§7), rocket parts.
7. **Hard mode** (§9), modules (§10) en dernier.
