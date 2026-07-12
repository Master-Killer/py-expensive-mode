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

## Dualité carburant *liquide* fossile/bio

Étendre la dualité aux liquides : donner une énergie aux fluides biologiques (blood,
simik-blood, bio-oil, fish-oil, ethanol, molasses… — *arthurian-blood n'existe pas comme
fluide* ; le sang générique `blood` couvre le rendering des arthurians) et créer une économie
de carburant liquide bio incompatible avec la fossile, comme coke vs biomasse côté solide.

### Verdict moteur (vérifié dans les sources)

- **`fuel_value` sur les fluides : oui.** pY le fait déjà — pycoalprocessing/data.lua l.177-188
  (crude-oil, tar, syngas, methanol…) et pypetroleumhandling/data.lua l.163+ (fuel-oil, bitumen,
  naphtha, btx…). Les fluides bio de pyAL n'en ont aucun aujourd'hui.
- **Pas de fuel categories pour les fluides.** `fuel_category` n'existe que sur les items ; le
  mécanisme exact de la dualité solide (deux catégories, chaque burner n'en accepte qu'une)
  **ne se transpose pas**. Une `FluidEnergySource` n'a qu'un seul fluidbox carburant avec au
  plus **un** fluide en `filter` ; sans filtre, elle brûle **tout** fluide ayant une fuel_value.
- **Deux familles de brûleurs dans pY** :
  - *filtrés, un fluide par tier* : oil-powerplant mk1-4 (kerosene/fuel-oil/diesel/gasoline),
    gas-powerplant mk1-4 (natural-gas → pure-natural-gas) ;
  - *non filtrés* (brûlent n'importe quel fluide-carburant) : smelter, glassworks,
    oil-boiler, salt/sulfur/antimony mines.

### Conséquence structurante

Donner une fuel_value à un fluide bio le rend **immédiatement brûlable dans tous les brûleurs
non filtrés** (smelter, glassworks…). L'incompatibilité ne peut donc pas être une propriété du
fluide ; elle s'obtient par **filtres single-fluid des deux côtés**, ce qui impose une
**convergence** : les fluides bio se raffinent en UN fluide-carburant commun (nouveau fluide
« liquid biofuel » — pas « biofluid », déjà pris par le réseau vessels/ducts de pyAL), via des
recettes de rendu aux rendements variés par source (sang pauvre, bio-oil riche… très pY).
Miroir exact de coke/briquette côté solide.

### Design proposé

| Élément | Concrétisation |
|---|---|
| Fluide de convergence | `liquid-biofuel` (ou élire bio-oil), seul fluide bio avec fuel_value « propre » |
| Recettes de convergence | blood/simik-blood/fish-oil/ethanol/molasses → liquid-biofuel, rendements différenciés |
| Bâtiments duals | variantes clonées filtrées : fossile filter=diesel (ou fuel-oil), bio filter=liquid-biofuel — pattern oil-powerplant, clonage en data-final-fixes |
| Brûleurs non filtrés existants | à trancher : soit leur poser un filtre fossile (gros changement gameplay), soit assumer qu'ils acceptent aussi le biofuel (fuite contrôlée, un seul fluide) |
| fuel_value sur les fluides bio bruts | optionnel, « saveur » : les rend brûlables dans les non-filtrés à faible rendement — décision délibérée, pas un accident |

### Effets de bord à gérer

- **Fuel canisters auto-générés** : pycoalprocessing crée un canister 10MJ (catégorie `jerry`)
  pour *chaque* fluide à fuel_value (fuel-canister-recipes.lua) → un fluide bio énergisé gagne
  son canister, qui fuit dans l'économie `jerry`. Utiliser `skipped_fluids` ou assumer.
- Le nom « biofluid » est pris (logistique vessels de pyAL) — nommer `pyem-liquid-biofuel`.
- Vérifier YAFC/Helmod/Factory Planner : FP ne gère les fluid burners que via `burns_fluid`
  (ok pour ce design).

## Séquençage

D'abord le BOF (ingrédient, zéro risque technique, effet immédiat sur toute la métallurgie),
puis le sinter en burner (premier vrai choc logistique), puis chaleur avec les nouveaux
bâtiments. Le choc liquide vient avec la refonte alliages. Chaque palier doit tomber à ~1
palier de science d'écart, comme les chocs électriques.
