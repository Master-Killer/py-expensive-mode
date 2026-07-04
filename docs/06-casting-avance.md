# Casting avancé — couler des pièces complexes

## Existant vérifié (pyrawores)

- Bâtiment `casting-unit`, catégorie `casting`, 11 recettes (+ steel, chromium, zinc, pyHT).
- Les moules existent déjà : `sand-casting`, **consommé** par les coulées
  (`iron-plate-1` : molten-iron 100 + borax 3 + sand-casting 1 → 60 plaques ;
  `steel-20` : molten-steel 100 + sand-casting 2 → 25 plaques).
- Le casting actuel ne produit que des plaques/lingots simples.

Le moulage au sable réel ne fait que des formes grossières ; les pièces complexes passent par
la **cire perdue** (investment casting, moule céramique, tolérances fines) ou le **moulage
sous pression** (die casting, moule métallique permanent mais qui s'use). Ça donne exactement
la hiérarchie de moules qu'il nous faut.

## Proposition

### 1. Nouveau bâtiment : Precision Foundry

- `assembling-machine`, catégorie `precision-casting`, **10-12 fluid boxes d'entrée** (limite
  moteur OK ; gabarit graphique : les gros multi-pipes pY type advanced-foundry).
- Débloqué vers py-science-pack-3 ; recette de construction : set composants mk03 complet
  (doc 02) + casting-unit 2 + alliage grade 3 (doc 04).
- Un seul tier — c'est le bâtiment lui-même qui est la marche à franchir.

### 2. Deux niveaux de moules au-dessus du sand-casting

```
investment-mould-<pièce> (cire perdue, consommé — comme sand-casting) :
  paraffin/wax[?, chaîne tar/oléochimie] 5 + quartz[?]/clay 10 + electronics-mk01 2 → 1

die-mould-<pièce> (permanent, catalyseur à retour probabiliste — pattern arqad-queen p=0.999) :
  investment-mould-<pièce> 1 + nbti-alloy 2 + mechanical-parts-03 1 → 1
  ... dans la coulée : die-mould en ingrédient + résultat probability = 0.95
```

Un moule **par famille de pièce** (pas par pièce) : `-parts`, `-frame`, `-drive`, `-shell` —
4 moules ×2 niveaux = 8 items, gérable. `electronics-mk01` trouve son grand puits ici
(doc 02).

### 3. Recettes de coulée (remplacements, pas alternatives)

Conformément à « rien d'optionnel » : au mk04, la voie assemblage est **remplacée** par la
coulée ; aux tiers inférieurs rien ne change.

```
composants mk04 (doc 02), ex. gearbox-mk04 :
  molten-steel-grade-4 40 (≥1500°) + molten-titanium 20 (≥1500°) + die-mould-drive
  → gearbox-mk04 ×4         [l'ancienne recette d'assemblage est retirée au mk04]

small-parts/mechanical-parts hauts :
  advanced-small-parts[= ASP, nom exact à vérifier dans pyHT] :
  molten-stainless-steel 30 + molten-aluminium 30 + nbti-alloy 2 + investment-mould-parts
  → ASP ×N (rendement supérieur à la voie assemblage, qui reste pour le mk03)

SSP (super steel parts [?]) : idem avec grade 4 + molten ≥1600° — exclusif Precision Foundry
```

La Precision Foundry avec ses 10-12 entrées permet des coulées multi-métaux (3-4 moltens
différents + 1-2 fluides de procédé : oxygen, coolant, vacuum) — le mur logistique est le
*plombing*, très pY.

### 4. Verrous croisés

- Les coulées exigent des moltens à `minimum_temperature` élevée (doc 05) et des grades 3-4
  (doc 04) → le casting est le consommateur final qui rend toute la pile métallurgie
  obligatoire.
- Le spacemod rebalance du mod route ses composants massifs (drydock structural…) vers les
  pièces coulées → le end-game spatial tire toute la chaîne.

## Risques

- Beaucoup de fluides chauds vers un seul bâtiment : prévoir les recettes de maintien en
  température (Ladle Furnace, doc 05) sinon frustration tuyauterie.
- Retirer les recettes d'assemblage mk04 casse des usines existantes en cours de partie →
  changelog explicite + migration note (c'est un mod de rebalance, assumé).
