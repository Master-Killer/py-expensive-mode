# Notes de conception — py-expensive-mode

Document de travail : idées triées par thème, avec pistes de concrétisation, estimation
d'effort (S/M/L/XL) et priorité suggérée. L'implémenté en v0.1.0 est rappelé en §2.

> Les propositions détaillées et concrètes (noms d'items réels, croquis de recettes,
> mécanismes vérifiés dans les sources pY) sont dans [PROPOSITIONS.md](PROPOSITIONS.md).

---

## 1. Vision et principes directeurs

À expliciter en tête de README à terme, car tout le tri en découle :

1. **Cher ≠ multiplier les coûts.** Le mod rend le jeu cher en créant des *dépendances entre
   chaînes* : le niveau N consomme le niveau N−1 en quantité croissante (4→3→2→1 au lieu de
   1→1→1→1). C'est déjà le cœur du mod (`pyem.recipe_chain` / `pyem.recipe_graph`).
2. **Revaloriser le contenu pY sous-utilisé.** Electronics MK1, nacelles/yaw drives, armures,
   créatures domestiques, montures, vivant MK2-4, les générateurs de pyAE… Chaque item orphelin
   devient un ingrédient obligatoire quelque part.
3. **Dans l'esprit pY : de la variété, pas de recette-type.** Quand un problème se pose à
   plusieurs endroits (ex. nourriture manquante pour un animal MK), ne pas appliquer la même
   solution partout.
4. **Cible : le mid/end-game.** Ne pas rendre l'early game plus punitif qu'il ne l'est ;
   l'explosion de coût doit arriver quand la base sait déjà produire.
5. **Chaque grande famille de chaînes doit être sollicitée** : minerais, vivant, small/mech
   parts, intermétalliques, circuits, pétrole/bitume/goudron.
6. **Rien d'optionnel.** Une recette alternative « plus chère mais plus productive » est une
   optimisation, pas un coût : toute dépendance ajoutée est obligatoire. Le choix ne porte
   que sur *comment* payer (TURD, craquage), jamais sur *si* on paye.
7. **Réintroduire la dépendance intra-niveau.** Au MK1 les machines dépendent les unes des
   autres (geothermal ← mining drills, MOX ← réacteur du même tier…) ; au MK2+ tout devient
   « machine N−1 + plaques + circuits ». Chaque bâtiment mkN doit de nouveau dépendre
   d'autres machines/composants *étrangers* de son niveau (ou du niveau inférieur, mais pas
   seulement de lui-même). Voir PROPOSITIONS.md §1.

---

## 2. Déjà implémenté (v0.1.0)

- Chaînes N→N−1 : montures (+TURD), armures (avec packing), éoliennes complètes (turbine,
  nacelle, rotor, pales, tour, anémomètre, yaw drive, vanes), citernes, coffres/entrepôts,
  caravanes, outposts/wyrmhole.
- Tweaks alien life : breeding/maturing arqad MK02-04 exigent des créatures de rang supérieur,
  navens breeders exigent des xyhiphoe MK.
- Rebalance SpaceX complet + fusion generator (SpaceModExpensivePatch).

---

## 3. Idées triées par thème

### 3.1 Extension des chaînes de dépendance — *le cœur, à continuer*

| Idée | Concrétisation | Effort | Priorité |
|---|---|---|---|
| Rééquilibrer les ratios science packs (3 ASP → 6 SP, 3 SSP → 9 ASP…) | `add_ingredient_amount` sur les recettes de packs. **Attention** : multiplicateur global sur toute la recherche → à mettre derrière un startup setting avec un facteur réglable. | S | Haute |
| Montures comme « mechanical parts » : progression mech part N → armure N → monture N → mech part N+1 | Version obligatoire (pas d'alternative) : armures packées dans les recettes de montures, montures dans les **bâtiments** mk3-4 (pas dans les items de masse), et monture-catalyseur à retour probabiliste dans les mechanical-parts (elle « actionne » la chaîne et s'use). Détail : PROPOSITIONS.md §3. | M | Haute |
| Nouvelles cibles de chaînes : beacons AM/FM, véhicules py (aircrafts), équipement de grille (batteries MK, exosquelettes), robots logistiques/construction | Mêmes helpers `recipe_chain`/`recipe_graph`. Faire l'inventaire des familles à MK dans pyAL/pyAE et cocher ce qui n'a pas encore de chaîne. | S par famille | Moyenne |
| Chaîne sur les science packs eux-mêmes (le pack N contient des packs N−1) | Variante du rééquilibrage des ratios ci-dessus ; choisir l'un OU l'autre, pas les deux. | S | Basse |

### 3.2 Revalorisation des items sous-utilisés

| Idée | Concrétisation | Effort | Priorité |
|---|---|---|---|
| Forcer l'usage de *chaque* filière énergie de pyAE (chaque joueur n'en utilise qu'un sous-ensemble) | Chaque filière débloque/produit un **intermédiaire unique** requis en end-game : les éoliennes sont déjà couvertes (nacelles en chaîne) ; pour le solaire/geothermal/etc., exiger leurs composants emblématiques (miroirs, échangeurs, mâts…) dans les composants SpaceX ou dans les recettes capstone (§3.8). Le rebalance SpaceX est le **puits idéal** déjà en place : y injecter nacelles, yaw drives, composants géothermiques, Electronics MK1 en masse. | S | Haute |
| Electronics MK1 utilisés tard | Les garder comme ingrédient « bête mais massif » dans les recettes chères (contrôleurs de moules §3.4, composants SpaceX). | S | Haute |
| Vivant MK2-4 au-delà des modules | Voir §3.5 ; règle générale : chaque créature MK doit apparaître dans ≥1 recette hors module (amorçage d'une autre créature, abats MK, nourriture MK, gelée royale…). | M | Haute |

### 3.3 Températures (à la Industrial Revolution 3)

Faisable **entièrement en data stage** : les ingrédients fluides acceptent
`minimum_temperature`/`maximum_temperature`, les produits fluides une `temperature` fixe.

| Idée | Concrétisation | Effort | Priorité |
|---|---|---|---|
| Métaux fondus à températures croissantes (fer : 100° processed / 200° unslimed / 300° pulp / 400° reduced / 500° sintered) | Modifier la température de sortie des recettes de fonte existantes par niveau. Côté « BOF MKn n'accepte que ≤ n×100° » : les machines n'ont pas de cap de température, mais les **recettes** oui → recette de plaques par palier avec `maximum_temperature`, assignée à la crafting category du BOF du bon tier (pY sépare déjà les categories par MK). Productivité croissante intégrée dans la recette : 100 fer@100° → 50 plaques ; 100 fer@500° → 150 plaques. Fer = cas spécial à 5 niveaux, assumer l'asymétrie (esprit pY). | M | Haute |
| Alliages avancés exigeant du métal plus chaud | Une fois le point précédent en place : `minimum_temperature` sur l'ingrédient fondu des alliages selon leur position dans l'arbre. | S (après le précédent) | Moyenne |
| Recette exigeant une fenêtre 50°<T<60° alors qu'on ne produit que <20° et >100° | Recettes de **trempe/mélange explicites** : `1 chaud@100° + 1 froid@20° → 2 tiède@55°` (Factorio ne calcule pas les températures de mélange, il faut des recettes fixes). Chaque branche (chaude/froide) avec des ingrédients assez différents pour créer des pénuries asymétriques. Éventuellement décliner par tranches de 10° — mais commencer par UNE fenêtre pour valider l'UX. | M | Moyenne |
| Bascule automatique avec/sans sous-produit selon T° (comme un four) | La sélection automatique de recette des fours se fait par ingrédient, pas par température — la bascule auto est **incertaine, à prototyper**. Repli simple : deux recettes à plages disjointes, choix manuel du joueur. | M (spike) | Basse |

**Garde-fou** : la prolifération de températures de fluides complique la logistique (barils,
trains fluides) et les outils (Factory Planner les gère, mais vérifier YAFC/Helmod).

### 3.4 Métaux, alliages, casting

| Idée | Concrétisation | Effort | Priorité |
|---|---|---|---|
| Varier les niveaux *reduced* et *sintered* (aujourd'hui uniformes et plats, alors que le niveau précédent est riche) | Par métal, ajouter 1-2 ingrédients spécifiques au niveau reduced/sintered, en piochant dans une famille différente à chaque métal (un métal pioche dans le vivant, un autre dans le pétrole, un autre dans les circuits) → variété esprit pY sans refonte. | M | Haute |
| Alliages plus profonds (grades 1-4, pulpes, au lieu de simples plaques) | Nouvel étage d'intermédiaires « grade n » par alliage majeur ; bon terrain pour les températures intermédiaires du §3.3. À faire APRÈS le chantier températures pour ne pas retoucher deux fois. | L | Moyenne |
| Casting avancé : produire directement ASP/SSP (et autres pièces complexes) depuis des métaux fondus | Nouveau bâtiment à 10-12 entrées fluides (supporté par le moteur ; s'inspirer des foundries à multiples fluid boxes). **Moules** : un item moule cher par pièce, consommé et restitué avec probabilité (~90 %) — pattern catalyseur déjà courant dans pY. Le moule est le puits parfait pour Electronics MK1 + mech parts + armures packées. | XL | Moyenne (gros morceau signature) |

### 3.5 Vivant / Alien life

| Idée | Concrétisation | Effort | Priorité |
|---|---|---|---|
| Bâtiments d'élevage fonctionnant à la nourriture au lieu de l'électricité | Précédent direct dans pY : **les caravanes brûlent déjà de la nourriture comme carburant**. Passer l'`energy_source` des bâtiments d'animaux en `burner` avec une fuel category `animal-food` ; donner une `fuel_value` aux nourritures. Basique pour MK1-2, qualité pour MK3-4. | M | Haute |
| Nourritures de qualité requièrent les standards | Simple chaîne : `pyem.recipe_chain` sur les paires standard→qualité. | S | Haute |
| Animal MK sans nourriture débloquée à sa techno | Panacher volontairement (esprit pY) : a) créer une nourriture « basique », b) déplacer le déblocage, c) worker's food (la plus complexe dispo à ce stade), d) abats MK d'une autre créature. Décider cas par cas, en regardant ce que fait le TURD de la créature. | M | Haute |
| Interconnexion Zipir ↔ Xyhiphoe (toujours débloqués ensemble) | Larve de Xyhiphoe mange du Zipir, œufs de Zipir demandent des Xyhiphoe ; les deux consomment coquilles + sang d'arthropode (ou le sang passe par les poissons/Navens). Aux MK2+, amorçage croisé : plutôt que « l'amorçage Zipir MK2 demande du Xyhiphoe MK2 » (cercle vicieux), **une recette d'amorçage double** qui sort coquilles MK2 + sang MK2, l'un amorçant Xyhiphoe MK2, l'autre Zipir MK2 — incontournable et pas exploitable pour sauter l'étape. | M | Haute |
| Wyrmhole exige un Vonix MK4 obtenu par une mauvaise recette d'amorçage | Ajouter une vraie chaîne Vonix MK (breeding/maturing) OU assumer l'amorçage comme coût one-shot du wyrmhole (il est déjà dans le `recipe_graph`). À trancher. | S-M | Moyenne |
| Gelée royale : consommer une arqad queen entière | L'exiger dans les recettes d'amorçage arqad MK (cohérent avec les tweaks arqad déjà en place dans `alien-life-tweaks.lua`). | S | Haute |
| Worker's food : recette « du diable » pour la deluxe, ingrédients MK2-3 dans les niveaux 1-2 | Réintroduire l'ancienne recette deluxe ; pour les niveaux 1-2, n'ajouter les ingrédients MK qu'en *seconde recette alternative plus productive* si on veut éviter un mur en milieu de partie. | S | Moyenne |
| Recettes d'amorçage (cDNA, artificial blood…) à chaque étage de recette | En faire une règle de design transverse : chaque nouvel étage introduit par le mod (grades d'alliage, intermédiaires capstone…) a sa recette d'amorçage chère et inefficace. | — (règle) | — |

### 3.6 Modules & TURD

| Idée | Concrétisation | Effort | Priorité |
|---|---|---|---|
| Familles de modules aux profils différents (+vite / −vite+prod / +vite+prod / +efficace) | Nouvelles catégories de modules + compat beacons (pY restreint déjà les modules par machine, s'appuyer dessus). Gros travail d'équilibrage, et pyAL a déjà SES modules-créatures : risque de dilution. | L | Basse |
| TURD obligatoire : chaque choix débloque une variante d'un élément indispensable | La version data-stage propre : un item indispensable X avec **trois recettes**, chacune débloquée par une des trois voies TURD (l'une explose les volumes, les deux autres complexifient différemment, façon Bhoddos/Yotoi). Pas besoin de scripting « au moins un TURD choisi ». | M | Haute |
| Parties de fusée escaladantes (via TURD) : Module MK1→2→3, rocket fuel→nuclear fuel | Même mécanisme : les voies TURD remplacent les ingrédients des rocket parts. Synergie directe avec le rebalance SpaceX existant. | M | Moyenne |

### 3.7 Chocs de ressources (pendant du choc électrique des centrifugeuses)

| Idée | Concrétisation | Effort | Priorité |
|---|---|---|---|
| Choc carburant solide 1 : BOF ; choc 2 : sinter plant | Passer ces machines en `burner` (ou ajouter le combustible en ingrédient de recette, plus lisible dans les planners). Différenciation biomasse/fossile via des fuel categories distinctes → deux économies de combustible parallèles. | M | Haute |
| Choc carburant liquide, choc chaleur | Identifier les machines candidates (chaleur → lien direct avec la mécanique heat de pyhardmode, §3.9). | M | Moyenne |

### 3.8 Recettes « capstone » transversales

L'idée-force : un ensemble de recettes end-game qui **traverse toutes les familles** de chaînes,
chacune sollicitée selon son caractère propre :

- **Minerai** : explosion de complexité, 10-15 intermédiaires, gros sous-produits réutilisables.
- **Vivant** : très lent, peu productif, boosté par modules/nourriture/TURD.
- **Small parts** : volume de production élevé (ou nouvel ingrédient injecté dans les small parts).
- **Mech parts/circuits** : très grand nombre de recettes intermédiaires variées.
- **Pétrole** : choix de craquage engageants.

**Concrétisation** : créer une famille d'intermédiaires génériques à la IR3 (tige, câble,
piston, roue dentée, petit/grand cadre, poutre…), produits/sous-produits de plusieurs chaînes,
qui s'assemblent en 2-3 **produits finaux nouveaux** (équivalents étendus des small/mech
parts/circuits) — lesquels sont ensuite injectés dans les recettes chères existantes (SpaceX,
casting §3.4, bâtiments MK4). C'est le chantier qui donne son identité au mod ; le découper en
lots : d'abord les intermédiaires + un seul produit final, injecté à un seul endroit.

À la même enseigne : **bâtiment de « minage » à modules** (ex. un pâturage) — une mining drill
avec slots à modules posée sur une ressource artificielle/placée, dont le rendement dépend des
modules-créatures insérés. Effort L (nouvelle entité + ressource), mais très pY.

### 3.9 Hard mode

Intégrer les mécaniques de pyhardmode : chaleur, macguffin, recettes modifiées.
**Concrétisation** : commencer par une dépendance optionnelle + couche de compat (les deux mods
cohabitent), et ne porter les mécaniques en dur que si la cohabitation s'avère ingérable.
Effort L, priorité basse tant que le cœur n'est pas stabilisé.

---

## 4. Idées nouvelles (même esprit)

- **Sellerie/harnachement** : les montures exigent une selle + harnais (nouveaux items =
  armures packées + mech parts + cuir/produits animaux) → resserre le lien armure→monture déjà
  visé au §3.1.
- **Chaîne beacons AM/FM** : la grille AM×FM est l'archétype du contenu à moitié exploré par
  les joueurs ; `recipe_graph` où chaque combinaison supérieure demande les inférieures.
- **Retraitement obligatoire des sous-produits end-game** : les gros sous-produits des chaînes
  capstone (§3.8) ne se « ventent » pas, ils doivent repartir dans une autre famille (esprit
  tailings-pond → gas-vent déjà présent dans chains.lua).
- **Équipement de grille comme ingrédients** : exosquelettes, boucliers, batteries portables MK
  dans les recettes de montures/armures supérieures (aujourd'hui presque purement optionnels).
- **Amorçages « choix du diable » systématiques** : à chaque étage MK2+, l'amorçage propose deux
  recettes — une rapide qui consomme un item TURD d'une AUTRE créature, une lente autonome.
  Généralisation du pattern amorçage croisé Zipir/Xyhiphoe.
- **Setting de pente** : exposer le facteur de profondeur des chaînes (le 4→3→2→1) en startup
  setting (ex. 1.0 = pY vanilla, 2.0 = défaut du mod, 3.0 = masochiste) — quasi gratuit vu que
  `recipe_graph` calcule déjà les quantités depuis la profondeur.

---

## 5. Feuille de route suggérée

1. **v0.2 — Quick wins data-stage** : ratios science packs (avec setting), gelée royale,
   interconnexion Zipir/Xyhiphoe + amorçages croisés, chaînes nourritures qualité→standard,
   injection des items pyAE sous-utilisés dans le rebalance SpaceX, setting de pente.
2. **v0.3 — Vivant** : bâtiments d'élevage à la nourriture, nourritures MK par animal
   (solutions panachées), worker's food.
3. **v0.4 — Températures & chocs** : métaux fondus à paliers + recettes BOF par tier,
   choc carburant solide BOF/sinter plant.
4. **v0.5 — Variété métallurgique** : reduced/sintered variés, premiers grades d'alliages.
5. **v0.6 — Capstone & casting** : intermédiaires IR3-like, premier produit final, bâtiment de
   casting + moules.
6. **v0.7 — TURD obligatoire & rocket parts**, familles de modules si l'appétit reste.
7. **v1.0 — Hard mode**.

---

## 6. Risques & garde-fous

- **pypostprocessing recalcule l'arbre des technos** quand les ingrédients changent : chaque
  ajout d'ingrédient peut déplacer une techno de science pack. Tester l'arbre après chaque lot.
- **Dépendances circulaires** : les amorçages croisés (§3.5) et les progressions
  armure↔monture↔mech part (§3.1) sont les endroits où ça guette ; toujours passer par une
  recette d'amorçage ou une recette alternative, jamais par la recette principale.
- **Prolifération de températures** : chaque température = un « fluide » logistique de plus ;
  limiter aux paliers de 100° côté métaux, et à UNE fenêtre fine pour commencer (§3.3).
- **Modules maison** : c'est le sujet le plus coûteux en équilibrage pour le moins d'identité —
  le garder pour la fin, voire l'abandonner.
