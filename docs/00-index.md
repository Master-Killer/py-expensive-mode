# py-expensive-mode — documents de conception

Un document par concept. Les faits marqués « vérifié » ont été contrôlés dans les sources des
mods pY (clonées depuis github.com/pyanodon) ; les noms marqués **[à vérifier]** restent à
confirmer avant implémentation.

## Principes (rappel)

1. Cher = dépendances entre chaînes, pas multiplication des coûts.
2. **Rien d'optionnel** — le choix porte sur *comment* payer, jamais *si*.
3. **Dépendance intra-niveau** — tout bâtiment mkN dépend d'éléments étrangers de tier N/N−1.
4. Variété esprit pY — jamais deux fois la même solution.
5. Cible mid/end-game.

## Documents

| Doc | Concept | Dépend de |
|---|---|---|
| [01-toile-intra-niveau](01-toile-intra-niveau.md) | La toile de dépendances par tier + outillage de vérification | — (chantier n°1) |
| [02-composants-mk](02-composants-mk.md) | Audit et extension des composants shaft/gearbox/… et mechanical-parts | 01 |
| [03-metallurgie-reduced-sintered](03-metallurgie-reduced-sintered.md) | Une route industrielle réelle par métal, 5 nouveaux bâtiments, sous-produits croisés | — |
| [04-alliages](04-alliages.md) | Grades de propreté 1-4, métallurgie secondaire (LF/VD/ESR/VAR), AOD | 03 |
| [05-temperatures](05-temperatures.md) | Températures des moltens, minimums obligatoires, trempe/chauffe | 03, 04 |
| [06-casting-avance](06-casting-avance.md) | Precision Foundry, moules à 3 niveaux, coulée des pièces mk04 | 04, 05 |
| [07-vivant-nourriture](07-vivant-nourriture.md) | Bâtiments d'élevage en burner-nourriture, chaînes qualité | — |
| [08-alien-interconnexions](08-alien-interconnexions.md) | Zipir↔Xyhiphoe, gelée royale, vonix→wyrmhole, amorçages croisés | 07 |
| [09-montures-armures](09-montures-armures.md) | Boucle mech parts → armures → selles → montures → tier supérieur | 01, 02 |
| [10-science-packs](10-science-packs.md) | Packs consommés par la famille `earth-*-sample` (data-array), étendue aux 5 packs et 2 espèces non couvertes | 07, 08 |
| [11-turd-obligatoire](11-turd-obligatoire.md) | Items-serrures à trois clés, rocket parts escaladantes | — |
| [12-chocs-carburant](12-chocs-carburant.md) | Paliers de choc solide/liquide/chaleur, biomasse vs fossile | 03, 04 |
| [13-filieres-energie](13-filieres-energie.md) | Chaque filière pyAE devient un passage obligé | 01, 03, 11 |

Historique : [IDEES.md](../IDEES.md) (tri initial), [PROPOSITIONS.md](../PROPOSITIONS.md)
(synthèse v1 — remplacée par ces documents pour le détail).

## Ordre d'attaque

1. Outillage de vérification (01 §vérification) — préalable à tout.
2. Toile intra-niveau (01) + composants/mechanical-parts (02).
3. Vivant (07, 08) — indépendant de la métallurgie, parallélisable.
4. Métallurgie : 03 (métaux) → 04 (alliages) → 05 (températures) → 06 (casting).
5. Science packs (10), montures (09), chocs (12).
6. TURD & rocket parts (11), filières énergie (13).
7. Hard mode & modules : voir PROPOSITIONS.md §9-10 — inchangés, priorité basse.
