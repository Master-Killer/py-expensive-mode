# Refonte des alliages — grades de propreté et métallurgie secondaire

## Constat (vérifié dans les sources)

Les alliages pY sont plats — une seule recette, des plaques en entrée :

```
nbti-alloy  (advanced-foundry, pyFE) : niobium-plate 5 + steel-plate 10        → 2
nxsb-alloy  (py-rawores-smelter)     : sb-oxide 10 + nexelit-plate 10          → 3
pbsb-alloy  (py-rawores-smelter)     : lead-plate 6 + sb-oxide 1               → 1
stainless   (py-rawores-smelter)     : molten-steel 100 + S + Cr 7 + Cu 2 + Ni 5 + Nb 2 → molten 50
super-alloy (advanced-foundry, pyFE) : steel 50 + Cr 20 + Mo-oxide 5 + V-oxide 8 + nexelit 5
                                       + fuelrod + helium + sand-casting + limestone → 5
```

`super-alloy` et `stainless` sont déjà corrects en variété ; le problème est l'absence de
**profondeur** : aucun alliage n'a d'étages, alors que les métaux purs en ont cinq. Et un
détail qui pique : le NbTi (supraconducteur réel Nb-Ti) est fabriqué… sans titane.

## Mécanique centrale : les grades de propreté (1 → 4)

Dans l'industrie réelle, un même alliage existe en plusieurs niveaux de propreté selon sa
route de fusion : fusion à l'air < fusion + poche (LF) < + dégazage sous vide (VD) < + refusion
(ESR/VAR). Les applications critiques (aéronautique, nucléaire) exigent le « triple melt »
VIM + ESR + VAR. C'est exactement la structure « grade 1/2/3/4 » de tes notes, avec un
habillage réaliste et une vraie logique de progression :

| Grade | Route | Bâtiment | Usage dans le mod |
|---|---|---|---|
| 1 | fusion simple (recette actuelle) | smelter / advanced-foundry | bâtiments mk01, recettes actuelles inchangées |
| 2 | + traitement en poche | **Ladle Furnace** (nouveau) | bâtiments mk02, composants mk02 |
| 3 | + dégazage sous vide | **Vacuum Degasser** (nouveau) | bâtiments mk03, small/mechanical-parts-03 |
| 4 | + refusion sous laitier/arc | **Remelting Furnace** (nouveau, ESR/VAR) | bâtiments mk04, spacemod, casting avancé |

### Les trois nouveaux bâtiments (métallurgie secondaire)

1. **Ladle Furnace (poche de traitement)** — accepte les métaux fondus, les maintient/ajuste
   en température (c'est LE bâtiment de trempe/chauffe du doc 05), désulfure :
   ```
   <molten-X> 100 (T ≥ seuil) + lime 2 + nitrogen[?] 20 → <molten-X-grade-2>[nouveau fluide ou item] 95
   ```
2. **Vacuum Degasser** — consomme le fluide `vacuum` (pyPH **[à vérifier]**) :
   ```
   grade-2 95 + vacuum 50 → grade-3 90 + flue-gas 10   (retrait H/N/O)
   ```
3. **Remelting Furnace** — électrode consommable + laitier (ESR) ou arc sous vide (VAR) :
   ```
   grade-3 90 + molten-salt 30 (T=1000, existe déjà dans pyAE) + electrode-graphite[nouveau] 1
   → grade-4 85
   ```

Chaque étape perd ~5 % de matière (yield réaliste) : le grade 4 coûte ~1.18× le grade 1 en
métal, plus les consommables, plus les bâtiments — cher mais pas absurde.

**Rendre les grades obligatoires** (principe « rien d'optionnel ») : ce sont les *consommateurs*
qui exigent le grade — les recettes de bâtiments mkN et de composants mkN (doc 01/02)
remplacent leurs plaques par du grade N. Pas de recette alternative : un `controler-mk03`
demandera du grade 3, point.

## Refonte par alliage (chaînes concrètes)

### Acier inoxydable — convertisseur AOD

L'AOD décarbure en soufflant argon + oxygène, ce qui évite d'oxyder le chrome (procédé réel
de 75+ % de l'inox mondial). Remplace la recette smelter actuelle :

```
AOD Converter (4e nouveau bâtiment, ou catégorie du Ladle Furnace) :
  molten-steel 100 (T ≥ 1500°) + reduced-chromium 4 + sintered-nickel 2 + oxygen 60 + argon[?] 40
  → molten-stainless-steel 70 + flue-gas 30
```

→ consomme les étages *reduced/sintered* de la refonte doc 03 (et non des plaques) : les deux
refontes se verrouillent mutuellement. L'argon : pY a-t-il un fractionnement d'air complet ?
**[à vérifier]** — sinon le créer (air liquide → O₂/N₂/Ar au Distilator), c'est un intrant
réaliste réutilisable partout (VD, VIM, atomisation).

### NbTi — le vrai supraconducteur

```
Remelting Furnace (VAR, sous vide) :
  molten-titanium 40 + niobium-plate 5 + vacuum 60 → nbti-alloy 4
```

Corrige l'aberration (plus d'acier), crée le lien titane→supraconducteurs, et comme `sc-wire`
et les aimants pyFE en dépendent, tout le end-game fusion exige désormais la chaîne Kroll
(doc 03). C'est le genre de verrou transversal qu'on cherche.

### Super-alloy — triple melt

La recette actuelle (riche) devient le **grade 1**, et le spacemod/les mk04 exigent le
grade 4 via la chaîne VIM → ESR → VAR :

```
super-alloy (recette pyFE actuelle)            = super-alloy-grade-1
Ladle/VIM :  grade-1 5 + helium 20             → grade-2 5   (VIM : fusion à induction sous vide)
Remelting (ESR) : grade-2 5 + molten-salt 30   → grade-3 5
Remelting (VAR) : grade-3 5 + vacuum 80        → grade-4 4
```

### Duralumin — durcissement structural

Le duralumin réel se durcit par mise en solution + trempe + vieillissement — trois passes
thermiques, parfaites pour la mécanique de température :

```
smelter : molten-aluminium 80 + reduced-copper 1 + sintered-zinc 1 → duralumin-brut[nouveau] 4
Ladle Furnace : duralumin-brut 4 (chauffe 500°) + water 100 (trempe) → duralumin-w[nouveau] 4
four (vieillissement, recette lente 120 s) : duralumin-w 4 → duralumin 4
```

### Alliages antimoine (nxsb, pbsb, fenxsb) et intermétalliques

Garder leurs recettes comme grade 1 ; leur donner un grade 2-3 seulement (pas 4) via le Ladle
Furnace — tous les alliages n'ont pas besoin de la même profondeur, la variété prime
(fenxsb/ns-material/intermetallics vivent dans recipes-intermetallics.lua de pyAE, à traiter
dans le même lot).

## Ordre d'implémentation

1. Fractionnement d'air (argon) + fluide vacuum vérifié — les deux consommables transverses.
2. Ladle Furnace seul, avec grades 2 sur acier/duralumin → valider l'UX fluides-à-grades
   (décision clé : grades en *fluides* distincts ou en *items* lingots — prototype des deux ;
   les fluides×températures×grades multiplient les tuyaux, les items simplifient).
3. VD + Remelting, grades 3-4 sur super-alloy/NbTi/stainless-AOD.
4. Basculer les consommateurs (bâtiments mkN, composants, spacemod) grade par grade.

## Sources

- [Principles and Functions of EAF, AOD, LF, and VD Furnaces — Fushun Special Steel](https://www.fushunspecialsteel.com/principles-and-functions-of-eaf-aod-lf-and-vd-furnaces/)
- [AOD Refining vs VOD Refining — SME Group](https://www.sme-group.com/blog/aod-refining-vs-vod-refining) (décarburation sans oxyder le chrome)
- [Steel — Vacuum Treatment — Britannica](https://www.britannica.com/technology/steel/Vacuum-treatment)
- [VIM, ESR, VAR — Wuden Alloy](https://www.wudenalloy.com/news/3-smelting-processes-for-nickelbased-alloy%EF%BC%9AVIM.html) ; [Advances in Triple Melting Superalloys — TMS](https://www.tms.org/Superalloys/10.7449/1994/Superalloys_1994_39_48.pdf)
- [Secondary metallurgy — Tenova](https://tenova.com/sites/default/files/files/solutions/2021/brochure_Secondary_metallurgy.pdf)
