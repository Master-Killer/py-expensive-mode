# Science packs — chaînage N ← N−1

## Existant vérifié

Aucun pack ne consomme de pack. Les recettes pY sont déjà riches et sortent en lots
(`py-science-pack-2` : moss 400 + zipir-eggs 15 + arqad-honey 600 + … → **18 packs**) ;
pyCP remanie les packs vanilla (production-science-pack : speed-module-2 +
efficiency-module-2 + uranium-fuel-cell + coal-briquette + electric-engine-unit…).

Ordre de progression du pack : `automation → py1 → logistic → military → py2 → chemical →
py3 → production → py4 → utility → space`.

## Proposition

Chaque pack de rang N consomme le pack de rang N−1, facteur k **par pack produit** (attention
aux tailles de lot : la recette py2 sort 18 packs → ingrédient = ceil(18×k) arrondi).

Le danger est la cascade : un facteur k sur 10 étages coûte k^10 en packs rouges. Avec
k = 0.5, le coût cumulatif en amont reste < 1 pack rouge par pack final — l'objectif n'est
pas de gonfler le coût de recherche mais de **forcer toutes les chaînes de science à rester
en production simultanée** (plus de « je démonte la py1 quand j'ai la py3 »).

| Réglage | k | Effet |
|---|---|---|
| off | 0 | vanilla |
| défaut | 0.5 | maintien des chaînes, coût cumulé borné |
| ton « 3 ASP → 6 SP » | 2 sur les étages visés | pénurie réelle, cumul exponentiel — réservé aux derniers étages (utility → space), jamais sur toute la chaîne |

Implémentation :

```lua
local order = {"automation-science-pack", "py-science-pack-1", "logistic-science-pack",
    "military-science-pack", "py-science-pack-2", "chemical-science-pack",
    "py-science-pack-3", "production-science-pack", "py-science-pack-4",
    "utility-science-pack", "space-science-pack"}
local k = settings.startup["pyem-science-chain-factor"].value
for i = 2, #order do
    local r, prev = RECIPE(order[i]), order[i-1]
    local batch = r:get_result_amount(order[i])  -- helper à écrire
    r:add_ingredient {type = "item", name = prev, amount = math.max(1, math.ceil(batch * k))}
end
```

Points durs :

- **[à vérifier]** noms exacts (`py-science-pack-1..4` — vu `py-science-pack-1/2` dans
  pyCP/pyAL) et l'insertion du military (optionnel dans certains arbres ?).
- pypostprocessing recalcule les coûts de technos à partir des packs : chaîner les packs ne
  déplace pas les technos (les recettes de packs ne débloquent rien), mais vérifier que
  l'auto-tech ne compte pas les packs-ingrédients dans les prérequis de science — test dédié.
- `space-science-pack` : ingrédient `utility` ×k, en plus du rebalance spacemod du mod (le
  patch ajoute déjà le space pack aux technos SpaceX — cohérent).
