# Températures des métaux fondus et fenêtres thermiques

## Ce que le moteur permet (et ce que pY fait déjà)

- Un produit fluide peut sortir à une température fixe (`temperature = N`).
- Un ingrédient fluide peut exiger `minimum_temperature` / `maximum_temperature`.
- **pY l'utilise déjà** : `molten-salt` est consommé à `temperature = 1000` dans pyAE
  (recipes.lua:771) — la mécanique a un précédent dans le pack, pas seulement dans IR3.

## Le support existe déjà dans pyrawores : les 5 recettes BOF

Vérifié dans recipes-iron.lua — les cinq niveaux de fer fondu de tes notes existent tels
quels, ordonnés (champ `order` bae → baa) :

| Recette | Entrée | molten-iron produit | Techno |
|---|---|---|---|
| molten-iron-05 | processed-iron-ore 5 | 10 | iron-mk01 |
| molten-iron-06 | unslimed-iron 1 | 40 | iron-mk02 |
| molten-iron-03 | high-grade-iron 1 | 150 | iron-mk03 |
| molten-iron-02 | reduced-iron 1 | 200 | iron-mk04 |
| molten-iron-01 | sintered-iron 1 | 150 (×2 sintered/reduced = 300) | iron-mk05 |

La productivité croissante par étage **existe déjà** (10 → 300 par unité de minerai
équivalente). Ce qui manque : rien ne *force* à monter les étages tant que le débit suffit.

## Proposition

### 1. Températures de sortie par étage

Échelle réaliste (le fer fond à 1538 °C ; une charge mal préparée donne un bain plus froid) :

```
molten-iron-05 → temperature = 1200
molten-iron-06 → temperature = 1300
molten-iron-03 → temperature = 1400
molten-iron-02 → temperature = 1500
molten-iron-01 → temperature = 1600
```

Même principe pour les autres métaux sur 4 niveaux (1200/1300/1400/1500), décalé selon le
point de fusion réel pour la saveur (aluminium 700-1000, cuivre 1100-1400, titane
1700-2000). Implémentation : `RECIPE("molten-X-0N").results[1].temperature = T` + relever le
`max_temperature` des fluides molten (fluids/molten-*.lua, un champ chacun).

### 2. Les consommateurs exigent un minimum (jamais un maximum)

Un cap « maximum » rendrait le métal chaud inutile ; un plancher « minimum » le rend
obligatoire (principe « rien d'optionnel ») :

| Consommateur | Contrainte proposée |
|---|---|
| `iron-plate-1` (casting, 100 molten → 60 plaques) | inchangé (≥ 1200 implicite) |
| plaques destinées aux small/mechanical-parts-03+ (nouvelles recettes casting) | ≥ 1400 |
| `molten-steel` (BOF : coke + molten-iron 50 + O₂) | ≥ 1400 — l'acier exige du fer mk03+ |
| `molten-stainless-steel` / AOD (doc 04) | ≥ 1500 |
| alliages grade 3-4, casting avancé (docs 04, 06) | ≥ 1500-1600 |
| nexelit « résonance » (doc 03) | molten-salt = 1000 (existant) |

Effet : l'early game ne change pas ; l'acier de milieu de partie exige l'étage pulp/high-grade ;
le end-game exige reduced/sintered. La montée en température EST la montée en complexité.

### 3. Chauffe et trempe explicites (Ladle Furnace)

Le moteur ne calcule pas les mélanges → recettes fixes dans la poche (doc 04) :

```
réchauffe : molten-iron 100 (≥1200) + coke-dust 2 + oxygen 30 → molten-iron 95 (1500)   [perte 5 %]
maintien  : molten-iron 100 (≥1400) + fuel/heat                → molten-iron 100 (1400)
trempe    : molten-iron 50 (≥1500) + molten-iron 50 (≤1300)    → molten-iron 100 (1400)
```

La réchauffe est volontairement *moins* efficace que produire chaud d'origine (perte de
matière + combustible) : raccourci disponible, jamais rentable — compatible avec « rien
d'optionnel » sans frustrer.

### 4. La fenêtre fine (50-60°) — cas nickel

Plutôt qu'une fenêtre artificielle, le procédé Mond (doc 03) la fournit naturellement :
carbonylation à T ≤ 60°, décomposition à T ≥ 220°, avec le même gaz dans les deux recettes.
Le joueur doit *refroidir* le CO recyclé (qui ressort chaud de la décomposition) avant de le
réinjecter : échangeur pyAE en recette de refroidissement explicite. Première implémentation
de la fenêtre, justifiée et localisée ; généraliser ensuite si l'UX tient.

### 5. Bascule automatique façon four

À prototyper séparément : la sélection auto des furnaces se fait par ingrédient, pas par
température. Ne rien promettre tant qu'un test en jeu n'a pas tranché ; le fallback (deux
recettes à plages disjointes) couvre tous les designs ci-dessus.

## Garde-fous

- Chaque température distincte d'un même fluide segmente les réseaux de tuyaux : rester sur
  ~5 paliers par métal, tous produits par des recettes (pas de dégradation continue).
- Vérifier le comportement de Factory Planner/YAFC avec les contraintes min/max (FP les gère).
- Les recettes existantes qui consomment du molten sans contrainte continuent de fonctionner
  quelle que soit la température : la migration des consommateurs peut être progressive.
