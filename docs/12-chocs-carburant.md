# Chocs de carburant (solide, liquide, chaleur)

Pendant du choc électrique des centrifugeuses/accélérateurs : des paliers où une machine
centrale exige soudain un flux massif de combustible d'un type donné.

## Deux implémentations, à panacher

1. **Combustible en ingrédient de recette** — lisible dans les planners ; précédent pY :
   `production-science-pack` contient coal-briquette 5 + uranium-fuel-cell 1.
2. **Conversion burner de la machine** — vrai choc logistique (alimenter physiquement) ;
   précédents pY : auog-generator (catégorie `auog`), caravanes (nourriture), et pyhardmode
   fait des burners des producteurs de chaleur.

## Les paliers proposés

| Choc | Machine | Implémentation | Combustible |
|---|---|---|---|
| Solide 1 (fossile) | **BOF** (pyrawores) | ingrédient : les 5 recettes molten-X gagnent coke ×2-5 (réaliste : la charge d'un convertisseur contient du carbone — et ça remplace le borax omniprésent par un duo borax+coke) | coke, coal-briquette |
| Solide 2 (fossile) | **Sinter Unit** | burner — le sinter réel brûle du poussier de coke dans la charge ; cohérent avec la refonte doc 03 (coke-dust en ingrédient) → ici plutôt burner pour le four lui-même | coke |
| Solide biomasse | **bio-reactor / biofactory** (pyAL) | burner, nouvelle catégorie `pyem-biofuel` | biomass, log, fawogae **[liste à arbitrer avec pyhardmode qui nerfe la biomasse]** |
| Liquide | **advanced-foundry** (pyFE) et/ou Remelting Furnace (doc 04) | ingrédient fluide : diesel/lfo ×100-300 par fusion | diesel, lfo |
| Chaleur | **CVP + Ladle Furnace** (docs 03-04) | `heat` energy source (pattern pyhardmode : incubator, simik den…) | heat pipes |

Catégories : créer `pyem-biofuel` et `pyem-fossil`, **ajoutées** aux items concernés sans
retirer `chemical` (aucun burner existant ne casse) ; les nouvelles machines n'acceptent que
la catégorie voulue.

## Différenciation biomasse/fossile

Deux économies de combustible parallèles qui ne se substituent pas :

- fossile : coke/briquettes — tirées par la métallurgie (BOF, sinter, anodes carbone doc 03) ;
- biomasse : tirée par le vivant (bio-reactor) et les powerplants biomasse (pyAE mk01-04,
  qui existent déjà et rejoignent la toile doc 01).

Le joueur ne peut plus router « tout ce qui brûle » vers le même bus énergie.

## Séquençage

D'abord le BOF (ingrédient, zéro risque technique, effet immédiat sur toute la métallurgie),
puis le sinter en burner (premier vrai choc logistique), puis chaleur avec les nouveaux
bâtiments. Le choc liquide vient avec la refonte alliages. Chaque palier doit tomber à ~1
palier de science d'écart, comme les chocs électriques.
