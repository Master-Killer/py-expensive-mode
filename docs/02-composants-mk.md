# Composants MK (shaft, gearbox, brake, controler, utility-box, electronics)

## Audit d'usage réel (correction d'un constat antérieur)

Les 6 familles existent en mk01→04 complets (pyAE, items-wind.lua). Elles ne sont **pas**
limitées à l'éolien : ce sont les briques des `mechanical-parts` — vérifié dans
pyalternativeenergy/prototypes/recipes/recipes.lua :

```
mechanical-parts-01 : shaft-mk01 + gearbox-mk01 + brake-mk01 + controler-mk01
                      + utility-box-mk01 + small-parts-01 25 + steel-plate 15 + rubber 3
                      → 3
mechanical-parts-02 : mechanical-parts-01 6 (!) + le set mk02 complet + electronics-mk02
                      + kevlar + nxsb-alloy + rayon + heavy-oil → …
```

Points notables :

- **Les mechanical-parts se chaînent déjà entre tiers** (mp-02 ← 6× mp-01) — le pattern
  N→N−1 du mod existe nativement ici, avec un facteur 6.
- Répartition des références aux composants : ~50 dans pyAE (éolien, mechanical-parts,
  hydraulic-systems, miroirs...), 1-2 dans pyAL, ~0 ailleurs. Les *autres* mods ne les
  consomment qu'indirectement, via `mechanical-parts-0N` et `small-parts-0N`.
- pyAE injecte déjà `electronics-mk02/03/04` dans les circuits vanilla
  (base-updates.lua:502+) et `electronics-mk01`+`gearbox-mk01`+`controler-mk01` dans
  fast-inserter-2 : le geste « composant éolien → item générique » est un pattern pyAE
  officiel qu'on prolonge, pas une invention du mod.

**Conséquence pour le design** : inutile de créer des intermédiaires « à la IR3 » (tige,
piston…) ni même un produit assemblé nouveau — `mechanical-parts-0N` EST l'assemblage
drivetrain+contrôle. Le travail consiste à élargir la *consommation directe* des composants
et des mechanical-parts.

## Propositions

### 1. Composants comme monnaie de la toile intra-niveau

C'est le pool de donneurs du doc 01 : chaque bâtiment mkN (N ≥ 2) reçoit 2 composants mkN de
familles étrangères. Granularité fine (un composant ≈ 1/10e de mechanical-part) → on peut
doser sans doubler le coût des bâtiments.

### 2. Mechanical-parts dans les bâtiments hauts

Aujourd'hui les bâtiments mk02-04 consomment `small-parts-0N` mais quasi jamais
`mechanical-parts-0N` (usage vérifié : uranium-drill, sut, miroirs, éolien — une poignée).
Règle : tout bâtiment mk03 reçoit `mechanical-parts-03` ×2-5, tout mk04 `mechanical-parts-04`
×2-5. Comme mp-0N contient 6× mp-0(N−1), la profondeur réelle est énorme sans rien inventer.

### 3. Casting des composants (lien doc 06)

Les composants mk03-04 gagnent une *seconde* voie de fabrication — non, principe « rien
d'optionnel » : leur recette actuelle est **remplacée** au mk04 par la coulée de précision
(molten grade 4 ≥ 1500° + moule) — le composant mk04 devient le premier consommateur
obligatoire du casting avancé.

### 4. Électronique mk01

`electronics-mk01` reste le plus orphelin du set (nacelle, fast-inserter-2). Puits proposés :
moules du casting (doc 06), Refining Cell et CVP (doc 03, bâtiments à instrumenter), et les
recettes d'armures packées (doc 09).

## Volumes indicatifs

| Cible | Ajout | Quantité |
|---|---|---|
| bâtiment mk02 | 2 composants mk02 étrangers | 5-10 chacun |
| bâtiment mk03 | 2 composants mk03 + mechanical-parts-03 | 5-10 / 2 |
| bâtiment mk04 | 2 composants mk04 + mechanical-parts-04 | 5-10 / 3 |
| nouveaux bâtiments docs 03-04 | set complet du tier de leur techno | 10-20 |
