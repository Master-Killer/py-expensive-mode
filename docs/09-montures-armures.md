# Montures, armures, mechanical parts — la boucle obligatoire

## Existant (dans le mod)

- Chaînes déjà en place : montures (`phadaisus ← spidertron ← dingrido ← crawdad`), TURD
  mounts, armures (`power-armor-mk2 ← … ← light-armor`) avec le packing (stack 1 → item
  packé utilisable en machine), animaux de trait (`work-o-dile ← thikat ← digosaurus`).
- Les montures consomment des entrepôts buffer (crawdad ← py-shed-buffer, etc.).

## Cible : mech parts N → armure N → monture N → (bâtiments et parts N+1)

### 1. Armures ← mechanical parts + composants (alignement bas)

Les recettes d'armures gagnent les composants de leur rang (doc 02) :
`heavy-armor` += mechanical-parts-01 2 ; `modular-armor` += mechanical-parts-02 2 +
utility-box-mk02 ; `power-armor` += mechanical-parts-03 2 + controler-mk03 ;
`power-armor-mk2` += mechanical-parts-04 2 + electronics-mk04 5.

### 2. Montures ← armures packées (harnachement)

Plutôt que l'armure brute, un item intermédiaire qui donne du sens (et un puits au cuir/
produits animaux) :

```
"saddle-mk0N" [nouveau, 3 items] :
  <armure du rang> packée 1 + kevlar/rubber + guts/skin[?] 5 + mechanical-parts-0N 1 → 1

crawdad    += saddle-mk02 1        (armure de référence : heavy-armor)
dingrido   += saddle-mk03 1        (modular-armor)
phadaisus  += saddle-mk04 1        (power-armor)
spidertron += saddle-mk04 1 + power-armor-mk2 packée 1
```

Alignement techno **[à vérifier]** : les montures sortent aux `domestication-mkN` — si une
armure arrive trop tard pour son rang, descendre d'un rang (jamais l'inverse).

### 3. Montures → l'étage supérieur (fermeture de la boucle)

Deux canaux, tous deux obligatoires :

- **Bâtiments** (via la toile, doc 01) : familles « plein air » de tier 3-4 —
  `fluid-drill-mk03` += crawdad 1, `ree-mining-drill-mk04` += dingrido 1, `micro-mine-mk04`
  += 1 animal de trait, outposts (déjà couverts par le recipe_graph du mod).
- **Mechanical parts hauts** en catalyseur à retour probabiliste (pattern arqad-queen) :

```
RECIPE("mechanical-parts-03")
    :add_ingredient {type = "item", name = "crawdad", amount = 1}
    :add_result {type = "item", name = "crawdad", amount = 1, probability = 0.98,
                 ignored_by_productivity = 1, ignored_by_stats = 1}
-- mechanical-parts-04 : idem avec dingrido, probability 0.98
```

  La bête « actionne » la ligne et s'use (2 %/craft, réglable). `ignored_by_productivity`
  obligatoire, sinon les modules de prod dupliquent des montures.

### Boucle résultante (sans cycle dans l'arbre)

```
mechanical-parts-01/02 ──→ armures ──→ saddles ──→ montures
        ↑                                             │
        └── mechanical-parts-03/04 (catalyseur) ←─────┘──→ bâtiments mk3-4
```

Le sens des flèches monte toujours dans l'arbre des technos (parts basses → armures →
montures → parts hautes/bâtiments hauts) : pas de circularité, la vérification du doc 01
(§ordre technologique) le garantit mécaniquement.

## Volumes

Une monture par bâtiment concerné, 1-2 % d'usure par craft de parts : la production de
montures requise reste artisanale (quelques-unes/heure) mais permanente — c'est le but :
maintenir la chaîne élevage+armures+entrepôts en vie toute la partie.
