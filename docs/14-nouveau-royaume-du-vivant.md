# Un nouveau royaume du vivant — pièce maîtresse du mod

pY couvre déjà les trois royaumes classiques : **animaux** (crawdad, ulric, mukmoux…),
**végétaux** (moss, seaweed, ralesia, tuuphra…), **champignons** (bhoddos, yotoi, fungal
substrate…). L'ambition ici : ajouter **un quatrième (ou cinquième) royaume**, présent dès le
début, dont la chaîne de production réunit à elle seule les traits emblématiques de *toutes*
les grandes familles de recettes pY.

Ce document propose 3 royaumes candidats + 1 forme unifiée, tous bâtis sur un même squelette
structurel (§1). Chaque candidat s'appuie sur une biologie réelle qui, par chance, incarne
déjà l'un des archétypes — puis on ajoute la couche SF.

---

## 1. Le squelette commun (le « génome » du design)

Cahier des charges (tes mots) traduit en structure. La chaîne doit avoir **en même temps** :

| Trait demandé | Archétype source | Où on le place dans le squelette |
|---|---|---|
| recette très lente, peu productive | Vivant | Étage 0 (culture) |
| modules dédiés | Vivant | modules de royaume (§1.4) |
| nourriture dédiée | Vivant | Étage 0 (milieu nutritif, sous-chaîne propre) |
| TURD | Vivant | Étage 1 (spéciation / choix de lignée) |
| niveau de production conséquent | Small parts | Étage 4 (assemblage volumique) |
| très grand nombre d'intermédiaires, grande variété | Mech parts / circuits | Étage 3 (raffinage par fraction) |
| choix dans les recettes intermédiaires | Pétrole (craquage) | Étage 3 (fractions à débouchés multiples) |
| intermédiaires utiles ailleurs | Minerai | fractions exportées vers docs 03/04/06 |
| sous-produits en grande quantité | Minerai | à chaque étage (O₂, eau, boues, glycérol…) |
| nb d'intermédiaires croît par stade, 10-15 au total | Minerai | fan-out étage 2 → 3 |

### Les 5 étages

```
Étage 0  CULTURE (lent)         milieu nutritif + lumière/chaleur → biomasse brute
Étage 1  SPÉCIATION (TURD)      choix de lignée : 3 voies aux sorties signature
Étage 2  RÉCOLTE & FAN-OUT      1 biomasse → 4-6 fractions (silice, lipides, protéines…)
Étage 3  RAFFINAGE (variété +   chaque fraction → arbre de raffinage, avec CHOIX de débouché
          choix + export)        (comme le craquage) ; certains intermédiaires s'exportent
Étage 4  ASSEMBLAGE (volume)    fractions raffinées → produits finaux (nouveaux small/mech
                                 parts, bio-circuits…), gros débit requis
```

Le **fan-out étage 2→3** est ce qui donne les « 10-15 intermédiaires » : une biomasse se
scinde en fractions, chaque fraction a 2-4 étapes de raffinage, et les étapes se croisent
(une fraction en raffine une autre). L'export (étage 3) branche ce royaume sur toute la pile
métallurgie/casting/circuits des docs précédents — c'est ce qui le rend *central* et pas
juste un silo de plus.

### 1.4 Modules et nourriture — communs aux 3 candidats

- **Nourriture = milieu nutritif** : un fluide `milieu-<royaume>` composé de sels (nitrate,
  phosphate, oligo-éléments) + source de carbone. Chaque composant a sa micro-chaîne
  (nitrate ← ammoniac pyPH ; phosphate ← phosphate rock ; silice ← sand/quartz). C'est la
  « nourriture dédiée » du vivant, mais à la sauce chimique/mineral → premier pont vers les
  autres royaumes.
- **Modules de royaume** : familles à profils distincts (cf. doc PROPOSITIONS §3.6), ici
  thématisées : *photopériode* (+vitesse), *sélection dirigée* (+productivité, −vitesse),
  *symbiose* (+efficacité milieu), restreints aux bâtiments du royaume. Fabriqués à partir des
  fractions de haute valeur du royaume lui-même (pigments, enzymes) → boucle vivante.
- **Bâtiments à la nourriture** (doc 07) : les cuves de culture peuvent tourner en burner sur
  la biomasse du royaume ou sur worker's food, au choix TURD.

---

## 2. Candidat A — Les Diatomées (« Silibiontes »)

> Biologie réelle : ~30 000 espèces de microalgues à **coquille de silice** (frustule),
> responsables de ~20 % de la photosynthèse mondiale, productrices de **lipides** (biocarburant
> réel), aux frustules nanoporeux utilisés en nanotechnologie, et capables **d'incorporer du
> titane** dans leur silice. C'est l'archétype qui coche le plus de cases nativement.

**Pitch de jeu** : un tapis d'algues dorées qu'on cultive dès le début dans l'eau, et dont la
coquille de verre + l'huile + les pigments alimentent tout le mid/end-game.

### Étage 0 — Culture (lent, peu productif)
```
"bloom-sauvage" (bassin, 120 s, très peu productif) :
  water 200 + light[via lampe/soleil] + co2 20 → diatom-slurry 5 + oxygen 40
"culture-dirigée" (photobioréacteur, débloqué plus tard) :
  diatom-slurry 5 + milieu-diatom 50 + co2 40 → diatom-slurry 25 + oxygen 120
milieu-diatom (fluide) : silicic-acid 10 + nitrate 5 + phosphate 2 + water 100
```
Sous-produit massif dès le début : **oxygène** (débouché : BOF/AOD des docs 03/04, procédés
qui en réclament — le royaume devient fournisseur d'O₂ industriel).

### Étage 1 — Spéciation (TURD, 3 lignées)
```
souche FRUSTULE  : frustules épais → voie silice/structure/nano
souche LIPIDE    : gouttelettes d'huile → voie carburant/craquage
souche PIGMENT   : fucoxanthine → voie chimique/modules/science
```
Chaque lignée change la répartition des fractions à l'étage 2 (une souche donne surtout de la
fraction X). Comme un TURD Bhoddos : choix structurant, non réversible sans re-recherche.

### Étage 2 — Récolte & fan-out
```
centrifuge : diatom-slurry 25 → wet-biomass 10 + culture-water 15 (recyclée vers étage 0)
lyse       : wet-biomass 10 → frustule-brute 4 + algal-oil 3 + algal-protein 2 + pigment 1 + cell-debris 3
```
Une biomasse → 5 fractions. `cell-debris` = sous-produit volumineux → compost/fertilisant
(chaînes pyAL existantes).

### Étage 3 — Raffinage par fraction (variété + choix + export)

**Frustule (voie minerai/nano)** — grades de porosité, comme les grades d'alliage (doc 04) :
```
frustule-brute → (nettoyage acide) frustule-propre → (calcination) frustule-grade-1
  grade-1 →(tri) grade-2 nanoporeux →(dopage) grade-3 → grade-4 (gabarit nano)
exports : grade-1 = filtration-media (existe !) ; grade-2 = abrasif/polissage ;
          grade-4 = gabarit des bio-circuits (étage 4) et des moules d'investment (doc 06)
dopage titane : frustule + molten-titanium → frustule-Ti (semiconducteur) → circuits
```

**Lipide (voie pétrole/craquage — CHOIX)** — exactement le « choix des recettes de craquage »
de tes notes, mais biologique :
```
algal-oil → crude-algal-oil, puis AU CHOIX :
  (a) transestérification : + methanol → biodiesel + glycerol(sous-produit++)
  (b) hydrotraitement     : + hydrogen → green-diesel + naphta-bio
  (c) pyrolyse            : → aromatics-bio + char + syngas
Chaque voie a un rendement/ingrédient/sous-produit différent : arbitrage joueur permanent.
glycérol : gros sous-produit → nitroglycérine (explosifs) ou retour milieu nutritif.
```

**Pigment / Protéine (voie chimique + boucle vivante)** :
```
pigment → fucoxanthine → ingrédient des MODULES du royaume + science pack
algal-protein → single-cell-protein → nourriture (workers-food, créatures doc 07)
                                     + fertilisant (sous-produit)
```

### Étage 4 — Assemblage (volume, small/mech parts)
```
bio-circuit-mk0N : frustule-Ti + magnetite-bio[pont candidat C] + green-diesel → bio-circuit
nano-membrane    : frustule-grade-4 + polymère → membrane (filtres, piles, spacemod)
```
Débit requis élevé (small parts) : ces produits entrent en masse dans les circuits/small-parts
via des recettes de remplacement (doc 02), donc il faut *industrialiser* la culture.

### Bilan A
- Coche toutes les cases, avec l'appui biologique le plus solide.
- ~20 items, ~5 bâtiments (bassin, photobioréacteur mk1-4, centrifugeuse, four à frustules,
  craqueur lipidique, cuve de symbiose).
- Exports vers docs 03 (O₂, silice), 04 (frustule-Ti), 06 (gabarits/moules), 02 (bio-circuits).

---

## 3. Candidat B — Le Myxobiote (« moisissure-réseau », SF)

> Biologie réelle : *Physarum polycephalum*, myxomycète — **une branche à part de l'arbre du
> vivant, à côté des plantes, animaux et champignons** (donc littéralement un royaume neuf).
> Cellule géante (syncytium) à millions de noyaux, qui **résout des labyrinthes** et **optimise
> des réseaux** (elle a reproduit le métro de Tokyo). Cycle : spore → amibe → plasmode → réseau
> optimisé → sclérote (dormant) → sporange → spores.

**Pitch de jeu SF** : un organisme *calculateur*. On ne fabrique pas des pièces, on les **fait
pousser** en imposant au plasmode un problème de routage : il tend ses veines protoplasmiques
selon les gradients qu'on lui présente, et on récolte le réseau optimisé comme conduits/
circuits vivants. C'est l'archétype **mech parts/circuits** (foule d'intermédiaires, variété)
incarné par du vivant.

### Correspondance étages ↔ cycle de vie
```
Étage 0  spores + substrat-nutritif (avoine-like) → amibes (lent)
Étage 1  fusion → plasmode ; TURD = 3 « tempéraments » de plasmode (explorateur/bâtisseur/
         stockeur) qui changent la nature des veines produites
Étage 2  le plasmode colonise un SUBSTRAT-GABARIT (item consommé) → « réseau brut »
Étage 3  ON PRÉSENTE DES GRADIENTS (attractants) → le réseau se spécialise :
           attractant-métal   → veines conductrices (bio-fils)
           attractant-rigide  → veines lignifiées (bio-tringles/engrenages souples)
           attractant-fluide  → veines creuses (bio-tubes/valves)
         Choix + immense variété : chaque combinaison substrat×attractant = un intermédiaire.
Étage 4  récolte : veines → conduits/circuits ; sclérotes → ENZYMES (= modules) ;
         sporanges → spores (boucle de semence + sous-produit)
```

### Le mécanisme signature : la « résolution »
```
"culture-plasmode" (matrice de calcul, 300 s, très lent) :
  plasmode 1 + substrat-gabarit 1 + attractant-X 10 + substrat-nutritif 20
  → reseau-X-brut 4 + spores 1 (sous-produit) + exsudat 10 (sous-produit++)
"raffinage-veine" : reseau-X-brut → conduit-X-1 → conduit-X-2 → … (2-4 crans par type)
```
La variété vient du produit cartésien type×grade ; le « choix » vient de quel attractant on
nourrit (chaque attractant a un coût amont différent — l'un vient des métaux, l'un du bois,
l'un des fluides). L'`exsudat` est le gros sous-produit (retour milieu ou chimie).

### Bilan B
- Le plus SF et le plus « signature » ; c'est celui qui justifie le mieux le mot *ambition*.
- Colle parfaitement à l'archétype circuits (nombre d'intermédiaires quasi illimité par
  combinatoire), moins naturel pour l'archétype minerai (moins de sous-produits « matière »).
- Risque : le concept « calcul » est abstrait — bien le vendre par les visuels/la locale.
- ~25 items (beaucoup par combinatoire), 4 bâtiments (germoir, matrice de calcul, raffineur de
  veines, séchoir à sclérotes).

---

## 4. Candidat C — Les Lithobiontes (bactéries chimiolithotrophes, biomining)

> Biologie réelle : *Acidithiobacillus ferrooxidans*, chimiolithotrophe qui **mange le minerai
> sulfuré** et mobilise Li, P, V, Cr, Fe, Ni, Cu, Zn, Ga, As, Mo, W, Pb, U (biolixiviation
> industrielle réelle du cuivre et de l'uranium). Vit à pH 1-2, produit du Fe(III), et son
> déchet est le **drainage minier acide** (acide sulfurique + jarosite) en énormes quantités.

**Pitch de jeu** : le royaume qui **est** la chaîne minerai. On élève des micro-organismes qui
digèrent le minerai brut et excrètent des métaux séparés — une alternative *vivante* et très
lente à la métallurgie thermique des docs 03/04, avec des sous-produits acides colossaux.

### Étages
```
Étage 0  souche-lithobionte + milieu-acide (lent) → culture-lithobionte
         milieu-acide : sulfuric-acid 50 + nitrate 2 + co2 10   (elle fixe le CO₂)
Étage 1  TURD = spécialisation métabolique : souche FER / souche SOUFRE / souche URANIUM
         (chacune mobilise un spectre de métaux différent → change les fractions étage 3)
Étage 2  BIOLIXIVIATION (grande cuve, très lent) :
         crushed-ore[n'importe lequel] 20 + culture-lithobionte 5 + oxygen 40
         → leachate-riche 30 + jarosite 10 (sous-produit++) + culture 6 (retour)
Étage 3  EXTRACTION SÉQUENTIELLE (le fan-out minerai par excellence, 10-15 crans) :
         leachate-riche →(cémentation) fraction-Cu + leachate-2
         leachate-2     →(échange d'ions) fraction-Ni + leachate-3
         leachate-3     →(solvant) fraction-Zn + leachate-4 → … → leachate-final → acide recyclé
         chaque fraction → sel métallique → (électro-obtention, Refining Cell doc 03) → métal
Étage 4  les métaux bio-extraits ALIMENTENT la métallurgie (docs 03/04) : ils remplacent/
         complètent les grades de minerai — production de volume requise pour que ça vaille le
         coup face à la voie thermique.
```

### Ce qui le rend obligatoire (pas juste une alternative)
Principe « rien d'optionnel » (doc 00) : certains métaux **traces** (Ga, V, W, Mo — vérifiés
présents dans pY : molybdenum-oxide, vanadium-oxide) ne sont accessibles QUE par
biolixiviation à haut rendement. La voie thermique donne le gros du fer/cuivre ; la voie
vivante donne les métaux mineurs indispensables aux alliages (doc 04 : super-alloy réclame
Mo + V). Les deux voies coexistent sans se dupliquer.

### Bilan C
- L'archétype minerai le plus pur (fan-out, sous-produits massifs, intermédiaires exportés).
- Se marie *nativement* avec toute la pile métallurgie déjà rédigée — c'est le candidat le
  mieux intégré aux docs existants.
- Moins « mignon/créature » que A ou B (ce sont des bactéries en cuve), mais pY assume déjà les
  bactéries en fluides (`bacteria-1/2`).

---

## 5. Candidat D — Le royaume composite (symbiote conçu) : la forme maximale

> Biologie réelle : le **lichen** n'est pas un organisme mais une **symbiose** (champignon +
> algue + bactéries ; jusqu'à 168 génomes dans un seul thalle). L'endosymbiose est même
> l'origine des organelles (mitochondries, chloroplastes).

**Pitch ultime** : le nouveau royaume n'est pas donné, il est **assemblé par le joueur** en
fin de partie à partir des trois candidats. On conçoit un super-organisme : squelette de
Diatomée (silice), calcul du Myxobiote (réseau), métabolisme Lithobionte (extraction). C'est
la « voire carrément un nouveau royaume » poussée au maximum : un royaume *artificiel*.

```
"chimère-symbiotique" (labo de synthèse, end-game) :
  diatom-grade-4 + plasmode-sclérote + culture-lithobionte + cDNA-synthétique
  → symbiote-mk01
Puis chaîne MK propre (doc 08) : le symbiote monte en mk02-04, et chaque tier débloque une
fonction hybride (bio-usine autonome : mange le minerai, calcule ses circuits, coule ses
frustules). Débouché : composants spacemod / fusion generator.
```

D peut être la **capstone** de A+B+C plutôt qu'un 4e projet séparé : on développe A, B, C au
fil de la partie, puis D les fusionne. Ça donne un fil narratif à tout le mod.

---

## 6. Comparaison et recommandation

| Critère | A Diatomées | B Myxobiote | C Lithobiontes |
|---|---|---|---|
| Présent dès le début | ✅ (algue d'eau) | ✅ (spores) | ✅ (extrêmophile) |
| Archétype minerai (fan-out, sous-prod.) | ✅✅ | ◻ | ✅✅✅ |
| Archétype circuits (variété d'intermédiaires) | ✅ | ✅✅✅ | ✅ |
| Archétype pétrole (choix de craquage) | ✅✅✅ (lipides) | ✅ (attractants) | ✅ (extraction) |
| Archétype small parts (volume) | ✅✅ | ✅ | ✅✅ |
| Archétype vivant (lent, food, module, TURD) | ✅✅ | ✅✅✅ | ✅✅ |
| Intégration aux docs 03-06 | forte | moyenne | maximale |
| Facteur « waouh »/ambition | fort | maximal | moyen |
| Appui biologique | maximal | maximal (vrai royaume) | maximal |
| Charge d'art (sprites) | moyenne | forte (animations réseau) | faible |

**Recommandation** : partir de **A (Diatomées)** comme royaume principal — c'est celui qui
coche le plus de cases *en une seule chaîne* avec l'appui biologique le plus riche et une
charge d'art raisonnable — puis intégrer **C (Lithobiontes)** comme deuxième organisme du même
royaume « des micro-organismes » (les deux vivent en cuve/bassin, partagent milieu et
modules), C étant le pont vers la métallurgie. Garder **B (Myxobiote)** comme grande pièce
signature de milieu de partie (le concept SF calcul), et **D** comme capstone facultative qui
fusionne le tout. Nommer le royaume, par ex. **« les Protistes »** (le vrai 5e royaume
biologique) ou un néologisme pY-esque.

Cette combinaison A+C sous un même royaume donne, dès la première chaîne : culture lente à
milieu dédié + modules + TURD (vivant), fan-out à 10-15 intermédiaires et sous-produits massifs
(minerai), choix de craquage des lipides (pétrole), foule d'intermédiaires de raffinage
(circuits), débit élevé à l'assemblage (small parts), et exports partout (docs 02/03/04/06).

---

## 7. Intégration et « présent dès le début »

- **Amorçage précoce, montée tardive** : l'étage 0 est débloqué très tôt (un bassin d'algues
  dans les premières technos) et donne un petit bénéfice immédiat (oxygène, un peu de biomasse,
  une nourriture d'appoint). La complexité (étages 3-4, exports) n'arrive qu'au mid/end-game —
  conforme à la cible du mod (doc 00) : présent tôt, punitif tard.
- **Point d'entrée dans l'arbre** : se greffer sur les premières technos de vie de pyAL
  (là où arrivent moss/seaweed) sans casser leur déblocage ; le royaume est *parallèle*, pas
  substitué.
- **Nouveaux groupes d'items** : ajouter `py-alienlife-protista` (+ sous-groupes par organisme)
  au modèle de item-groups.lua ; codex/TURD sur le modèle des créatures existantes.
- **Dépendances** : pyAL (vivant, TURD, modules), pyrawores (silice/minerai/métaux),
  pyPH (méthanol, hydrogène, ammoniac pour le milieu et le craquage), pyCP (acide sulfurique).
- **Vérification** : ce royaume ajoute un très grand graphe de recettes → passer
  systématiquement par l'outillage cycle-check + ordre-technologique du doc 01 avant chaque
  lot ; commencer par l'étage 0-2 d'un seul organisme, valider l'arbre, puis étendre.

---

## Sources

- [Physarum polycephalum — a genuine branch of the tree of life beside plants, animals, fungi (PhyChip)](https://phychip.eu/objectives/about-physarum-polycephalum/) ; [cycle & réseaux (ScienceDirect)](https://www.sciencedirect.com/topics/agricultural-and-biological-sciences/physarum-polycephalum) ; [résolution de labyrinthe / réseau de Tokyo (arXiv review)](https://arxiv.org/pdf/1712.02910)
- [Diatomées : 30 000 espèces, ~20 % de la photosynthèse, frustules de silice (review PlantArchives)](https://www.plantarchives.org/article/diatom-and-its-expanding-research-horizon-a-review.pdf) ; [biosilice comme plateforme d'ingénierie (ACS)](https://pubs.acs.org/doi/10.1021/acsabm.9b00050) ; [incorporation de titane dans la silice (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4387253/) ; [biocarburant lipidique (Wiley)](https://onlinelibrary.wiley.com/doi/abs/10.1002/9781394174980.ch9)
- [Biolixiviation — A. ferrooxidans mobilise Li…U (MDPI Microorganisms)](https://www.mdpi.com/2076-2607/12/12/2407) ; [du génome aux applications industrielles (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2621215/)
- [Bactéries magnétotactiques / magnétosomes de magnétite (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9840458/) — pont bio-circuits
- [Archées méthanogènes extrêmophiles (LibreTexts)](https://bio.libretexts.org/Bookshelves/Microbiology/Microbiology_(Boundless)/08:_Microbial_Evolution_Phylogeny_and_Diversity/8.15:_Euryarchaeota/8.15C:_Methane-Producing_Archaea_-_Methanogens) — pont gaz/craquage
- [Lichen : symbiose multipartenaire, 168 génomes (ScienceDirect)](https://www.sciencedirect.com/science/article/pii/S0960982224017093) ; [évolution des symbioses lichéniques (Wiley)](https://nph.onlinelibrary.wiley.com/doi/full/10.1111/nph.18048)
