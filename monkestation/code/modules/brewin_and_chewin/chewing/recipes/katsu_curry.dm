/datum/chewin_cooking/recipe/katsu
	cooking_container = DF_BASKET
	product_type = /obj/item/food/katsu_fillet
	recipe_guide = "Put raw cutlets with some reispan bread slices in a fryer, fry for 20 seconds."
	step_builder = list(
		list(CHEWIN_ADD_ITEM, /obj/item/food/meat/rawcutlet, qmod=0.5),
		list(CHEWIN_ADD_ITEM, /obj/item/food/breadslice/reispan, qmod=0.5),
		list(CHEWIN_USE_FRYER, J_HI, 20 SECONDS)
	)

/datum/chewin_cooking/recipe/katsu
	cooking_container = BOWL
	product_type = /obj/item/food/salad/katsu_curry
	recipe_guide = "Put raw cutlets with some reispan bread slices in a fryer, fry for 20 seconds."
	step_builder = list(
		list(CHEWIN_ADD_ITEM, /obj/item/food/butter, qmod=0.5),
		list(CHEWIN_USE_STOVE, J_LO, 10 SECONDS),

		list(CHEWIN_ADD_REAGENT_OPTIONAL, /datum/reagent/consumable/soysauce, 5, base=3),

		list(CHEWIN_ADD_ITEM, /obj/item/food/boiledrice, qmod=0.5),
		list(CHEWIN_ADD_REAGENT, /datum/reagent/consumable/nutriment/soup/curry_sauce, 5, base=3),

		CHEWIN_BEGIN_EXCLUSIVE_OPTIONS,
		list(CHEWIN_ADD_PRODUCE_OPTIONAL, /obj/item/food/grown/chili, qmod=0.2, reagent_skip=TRUE, prod_desc = "Extra spicy!"),
		list(CHEWIN_ADD_PRODUCE_OPTIONAL, /obj/item/food/grown/pineapple, qmod=0.2, reagent_skip=TRUE, prod_desc = "Mild and Sweet."),
		CHEWIN_END_EXCLUSIVE_OPTIONS,

		list(CHEWIN_USE_STOVE, J_LO, 20 SECONDS),
	)
