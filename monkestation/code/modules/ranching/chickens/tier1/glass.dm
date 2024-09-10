/mob/living/basic/chicken/glass
	icon_suffix = "glass"

	breed_name = "Glass"
	egg_type = /obj/item/food/egg/glass
	mutation_list = list(/datum/mutation/ranching/chicken/wiznerd, /datum/mutation/ranching/chicken/stone)
	liked_foods = list(/obj/item/food/grown/rice = 2)

	book_desc = "Fragile as glass, but produces the chemical injected into its egg overtime."

/obj/item/food/egg/glass
	name = "Glass Egg"
	food_reagents = list()
	max_volume = 5
	icon_state = "glass"

	layer_hen_type = /mob/living/basic/chicken/glass

/obj/item/food/egg/glass/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/food/egg/glass/process(seconds_per_tick)
	if(!length(glass_egg_reagents)) // this causes only second gen to work
		return

	var/amount_left = max_volume - reagents.total_volume

	var/amount_to_add = min(amount_left, max_volume * 0.1)

	var/minimum_injection = 0
	for(var/datum/reagent/listed as anything in glass_egg_reagents)
		minimum_injection += glass_egg_reagents[listed] * 0.1

	var/multiplier = 1
	if(minimum_injection < amount_to_add)
		multiplier = minimum_injection / amount_to_add

	for(var/datum/reagent/listed_reagent as anything in glass_egg_reagents)
		reagents.add_reagent(listed_reagent, glass_egg_reagents[listed_reagent] * multiplier)
