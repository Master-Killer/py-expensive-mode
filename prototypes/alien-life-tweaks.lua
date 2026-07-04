-- Alien Life Modules Tweaks

-- Arqad MK02
RECIPE("navens-mk02-breeder"):add_ingredient_amount("xyhiphoe-mk02", 9)

RECIPE("arqad-mk02-breeding"):replace_ingredient("ulric", "ulric-mk02")

-- Arqad MK03
RECIPE("navens-mk03-breeder"):add_ingredient_amount("xyhiphoe-mk03", 9)

RECIPE("arqad-mk03-breeding"):replace_ingredient("korlex", "korlex-mk03")
RECIPE("arqad-mk03-maturing"):replace_ingredient("dhilmos-pup", "dhilmos-mk02")

-- Arqad MK04
RECIPE("navens-mk04-breeder"):add_ingredient_amount("xyhiphoe-mk04", 9)

RECIPE("arqad-mk04-breeding"):replace_ingredient("phadai", "phadai-mk03")
RECIPE("arqad-mk04-maturing"):replace_ingredient("xyhiphoe-cub", "navens-mk04", 13)