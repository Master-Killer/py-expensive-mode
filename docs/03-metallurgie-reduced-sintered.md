# Refonte des étages reduced/sintered — une route réelle par métal

## Constat (vérifié dans pyrawores)

Les deux derniers étages sont du copier-coller sur les ~10 métaux :

```
reduction-<métal> (DRP)  : high-grade-<métal> 1 + sodium-sulfate 2 + diesel 50      → reduced-<métal> 1
sinter-<métal>-2 (sinter): reduced-<métal> 1  + lime 3           + syngas 100       → sintered-<métal> 2
```

Seules exceptions : chrome (`chromite-sand` 15 + `sodium-hydroxide` + light-oil), aluminium
(`iron-oxide` 2 au lieu du sodium-sulfate), nexelit (ratios), et l'acier qui a son
`sponge-iron` séparé (iron-oxide + sodium-sulfate + light-oil, catégorie drp → EAF).
C'est d'autant plus plat que l'étage précédent (high-grade) est riche et varié par métal
(pulps, flottation, filtres, leaching…).

**Principe de la refonte** : chaque métal reçoit sa vraie route industrielle, avec
sous-produits croisés entre chaînes de métaux (l'esprit pY par excellence : le déchet de l'un
est l'intrant de l'autre). Les deux technos (`<métal>-mk04` pour reduced, `-mk05` pour
sintered) et les items finaux `reduced-X`/`sintered-X` sont conservés — on remplace le
*chemin*, pas les points d'arrivée, pour ne pas casser les recettes BOF/EAF en aval
(`molten-X-02` ← reduced, `molten-X-01` ← sintered).

## Nouveaux bâtiments mutualisés (5)

Un bâtiment par *type de traitement*, chacun servant plusieurs métaux — pas un bâtiment par
métal :

| Bâtiment | Type de traitement | Métaux servis |
|---|---|---|
| **Chlorination & Vapor Plant** (CVP) | chimie en phase vapeur : chloration, carbonylation, décomposition thermique | Ti (Kroll), Ni (Mond), Zr plus tard |
| **Refining Cell** | électro-raffinage / électro-extraction (anodes → cathodes) | Cu, Zn, Al ; réutilise l'`electrolyzer` pyrawores comme MK inférieur |
| **Thermite Furnace** (four à arc immergé) | réductions alumino/silico-thermiques, ferro-alliages | Cr, plus tard FeNb/FeV pour les alliages (doc 04) |
| **Cupellation Retort** | séparations pyrométallurgiques Pb/Zn/Ag, distillation de crasses | Pb, Ag, Zn (boucle Parkes) |
| **Powder Plant** (atomiseur + presse HIP) | métallurgie des poudres : atomisation, compaction, frittage sous pression | tous les `sintered-X`, poudre d'Al pour la thermite |

Chaque bâtiment existe en un seul tier (cher), positionné vers iron-mk04/mk05 dans l'arbre.
Les composants MK de pyAE (gearbox, controler, electronics — voir doc 02) et les alliages
grades (doc 04) fournissent leurs recettes de construction → dépendance intra-niveau gratuite.

## Chaînes par métal

Notation : `[nouveau]` = item/fluide à créer ; `[?]` = nom exact à vérifier dans les sources.
Les quantités sont indicatives, à calibrer sur les ratios actuels (1 high-grade → 1 reduced →
2 sintered) pour ne pas changer l'économie globale, seulement sa complexité.

### Fer — sinter réaliste avec boucle de fines

Le vrai sinter (agglomération sur grille) consomme du poussier de coke (3-5 % de la masse),
du calcaire, et surtout **20-40 % de fines de retour** — un flux qui boucle sur lui-même.

```
DRP (reduced, inchangé dans l'esprit — c'est du DRI au gaz) :
  high-grade-iron 1 + syngas 150 → reduced-iron 1 + flue-gas 100
  variante H2 (débloquée plus tard, meilleur rendement, pas de flue-gas) :
  high-grade-iron 1 + hydrogen 200 → reduced-iron 1 + steam 50

Sinter Unit (sintered) :
  reduced-iron 2 + coke-dust[?] 1 + limestone 3 + sinter-fines[nouveau] 1
  → sintered-iron 4 + sinter-fines 1 + flue-gas 60
```

La boucle `sinter-fines` s'auto-amorce (première recette d'amorçage : reduced-iron →
sinter-fines, lente) puis tourne en circuit fermé — le joueur doit dimensionner le retour.
C'est le pattern d'amorçage cher à tes notes, appliqué au minerai.

### Cuivre — flash smelting, électro-raffinage et boues anodiques

La route réelle : concentré → matte → blister → anodes → **électro-raffinage** ; les impuretés
tombent en **boues anodiques** riches en argent/or (5-10 kg par tonne de cathode).

```
Smelter (flash smelting) :
  high-grade-copper 2 + oxygen 100 → copper-matte[nouveau] 1 + so2[?] 100
BOF (conversion) :
  copper-matte 1 + oxygen 60 → blister-copper[nouveau] 1 (= remplace reduced-copper*)
Casting Unit :
  blister-copper 2 + sand-casting 1 → copper-anode[nouveau] 2
Refining Cell :
  copper-anode 2 + sulfuric-acid 40 → sintered-copper 4 + anode-slime[nouveau] 1
Cupellation Retort (valorisation des boues) :
  anode-slime 5 + lead-plate 2 → silver-ore[?] 3 + gold-ore[?] 1 + tailings 20
```

\* garder l'item `reduced-copper` avec « blister copper » en locale FR/EN pour ne rien casser.
Le SO₂ part vers l'acide sulfurique (chaîne existante) : le cuivre devient producteur net
d'acide, consommé par… son propre raffinage et le zinc. Les boues anodiques créent la première
**dépendance minerai→minerai** (cuivre → argent/or).

### Nickel — procédé Mond (et démonstrateur des températures)

Le nickel réagit avec le CO à 50-60 °C pour former le gaz Ni(CO)₄, qui se décompose en nickel
pur à 220-250 °C en rendant le CO. C'est le cas d'usage parfait de la mécanique de
température (doc 05) : **même fluide, deux fenêtres**.

```
CVP (carbonylation) :
  reduced-nickel 1 + carbon-monoxide[?] 100 (T ≤ 60°) → nickel-carbonyl[nouveau, gaz] 100
CVP (décomposition) :
  nickel-carbonyl 100 (T ≥ 220°) → sintered-nickel 2 + carbon-monoxide 95
```

Le CO tourne en boucle avec 5 % de pertes ; le chauffage du carbonyl entre les deux recettes
passe par le heat-exchanger pyAE (recette de chauffe explicite) — première consommation
obligatoire de la mécanique de trempe/chauffe.

### Titane — procédé Kroll (variante sodium : Hunter)

Route réelle : chloration du minerai avec coke + chlore → TiCl₄, purifié par distillation,
réduit au magnésium (ou sodium — pY n'a pas de magnésium métal **[à vérifier]**, le sodium
existe via ses sels), puis distillation sous vide de l'éponge.

```
CVP (chloration) :
  grade-4-ti 2 + coke 3 + chlorine[?] 100 → ticl4[nouveau] 80 + flue-gas 40
Distilator pyCP (purification) :
  ticl4 80 → ticl4-pure[nouveau] 60 + residues → tar
CVP (réduction Hunter) :
  ticl4-pure 60 + sodium[?] 8 → titanium-sponge[nouveau] 2 + salt 10
  (le sel retourne à l'électrolyse → chlore + sodium : boucle fermée, très pY)
Powder Plant (vacuum distillation + pressage) :
  titanium-sponge 2 + vacuum[?, fluide pyPH] 50 → reduced-ti 1
Powder Plant (HIP) :
  reduced-ti 1 + nitrogen[?] 50 → sintered-ti 2
```

### Chrome — aluminothermie

```
Powder Plant (atomisation) :
  molten-aluminium 50 → aluminium-powder[nouveau] 10
Thermite Furnace :
  chromium-oxide[?] 6 + aluminium-powder 2 + iron-oxide 1 (amorce)
  → reduced-chromium 2 + alumina[?] 3 + heat/flue-gas
```

L'alumine sous-produit retourne dans la chaîne aluminium (grade-2 équivalent) : deuxième
dépendance minerai→minerai. `sintered-chromium` passe par le Powder Plant comme le titane.

### Aluminium — Hall-Héroult avec anodes carbone

```
Anodes : coke 4 + pitch[?, chaîne tar pyCP] 2 → carbon-anode[nouveau] 2
Refining Cell (électrolyse en bain de cryolite) :
  alumina[?] 4 + carbon-anode 1 + cryolite[nouveau ou fluorite ?] 1
  → reduced-aluminium 2 + co2 60   (l'anode est consommée — vrai puits de coke)
Powder Plant : reduced-aluminium → aluminium-powder → (presse+frittage) sintered-aluminium
```

La poudre d'Al sert à la fois au frittage ET à la thermite du chrome : l'aluminium devient un
métal-carrefour.

### Plomb & Argent & Zinc — le triangle Parkes

Le procédé Parkes désargente le plomb fondu avec du zinc (l'argent y est 3000× plus soluble),
la croûte Ag-Zn est écumée, le zinc récupéré par distillation sous vide.

```
Sinter Unit (grillage) : high-grade-lead 2 + oxygen 60 → lead-sinter[nouveau] 2 + so2 80
BOF (blast) :            lead-sinter 2 + coke 2 → reduced-lead 2 (bullion) + copper-dross[nouveau] 1
Cupellation Retort (Parkes) :
  reduced-lead 4 + zinc-plate 1 → sintered-lead 4 (raffiné) + ag-zn-crust[nouveau] 1
Cupellation Retort (récupération) :
  ag-zn-crust 2 + vacuum[?] 40 → reduced-silver 1 + zinc-plate 1 (retour ~50 %)
Cupellation Retort (coupellation) :
  reduced-silver 2 + lead-plate 1 + oxygen 40 → sintered-silver 2 + litharge[nouveau] 1
  (litharge = PbO, retourne dans la chaîne plomb)
```

Le zinc lui-même : grillage → so2, lixiviation à l'acide sulfurique (celui du cuivre !) →
électro-extraction en Refining Cell → `sintered-zinc`. Le `copper-dross` du blast retourne
dans la chaîne cuivre. **Pb, Zn, Ag, Cu forment un cycle fermé de sous-produits croisés** —
le cœur « chaque chaîne alimente les autres » de tes notes.

### Étain, Nexelit

- Étain : fusion au four à réverbère (smelter) + liquation ; sous-produit `hardhead` (Fe-Sn)
  qui retourne au BOF fer — petit lien croisé bon marché.
- Nexelit (fictif) : lui inventer une route « résonance » py-style — électrolyse en sel fondu
  en Refining Cell avec `molten-salt` à 1000° (le fluide chaud existe déjà dans pyAE,
  recipes.lua:771) : lien direct avec la mécanique température, et consommateur obligatoire
  de la filière solaire à concentration (doc 13).

## Impact sur la difficulté (le but du mod)

- ~15 items/fluides nouveaux, 5 bâtiments nouveaux, ~30 recettes remplacées.
- Chaque métal end-game exige désormais 2-4 chaînes d'autres métaux (acide du Cu pour le Zn,
  poudre d'Al pour le Cr, Pb pour l'Ag, Zn pour le Pb…) → impossible de rusher un seul métal.
- Les boucles à retour partiel (fines de sinter, CO du Mond, zinc du Parkes, sel du Kroll)
  sont des usines qui doivent tourner *en équilibre* — la vraie difficulté pY.

## Sources

- [Iron Ore Sinter — ScienceDirect](https://www.sciencedirect.com/topics/chemical-engineering/iron-ore-sinter) (poussier de coke 3-5 %, fines de retour 20-40 %)
- [Direct reduced iron — Wikipedia](https://en.wikipedia.org/wiki/Direct_reduced_iron)
- [Mond process — Wikipedia](https://en.wikipedia.org/wiki/Mond_process) / [Britannica](https://www.britannica.com/technology/Mond-carbonyl-process) (50-60° formation, 220-250° décomposition)
- [Kroll process at OTC — J-STAGE](https://www.jstage.jst.go.jp/article/matertrans/58/3/58_MK201634/_html/-char/en) (chloration, distillation, réduction Mg, distillation sous vide)
- [Parkes process — Wikipedia](https://en.wikipedia.org/wiki/Parkes_process) / [Britannica](https://www.britannica.com/technology/Parkes-process) (Ag 3000× plus soluble dans Zn)
- [Flash smelting — Wikipedia](https://en.wikipedia.org/wiki/Flash_smelting) ; [Copper anode slime gold recovery — MDPI](https://www.mdpi.com/2227-9717/12/12/2686) (5-10 kg de boues/t de cathode)
