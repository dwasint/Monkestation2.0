/datum/brewing_recipe/custom_recipe
	reagent_to_brew = /datum/reagent/consumable/ethanol/custom_brew
	var/bottle_name
	var/bottle_desc
	var/glass_name
	var/glass_desc

	///list of reagents we transfer PER UNIT so if its 30% ethanol put /datum/reagent/consumable/ethanol = 0.3
	var/list/reagent_data = list()
	var/made_by


/datum/reagent/consumable/ethanol/custom_brew
	name = "EVIL WIZARD POTION"
	can_merge = FALSE

/datum/reagent/consumable/ethanol/custom_brew/on_mob_add(mob/living/L, amount)
	. = ..()
	if(!isliving(L))
		return
	if(!("reagents" in data))
		return
	for(var/datum/reagent/reagent as anything in data["reagents"])
		var/multiplier = trans_volume * data["reagents"][reagent]
		L.reagents.add_reagent(reagent, multiplier)
	L.reagents.remove_all_type(/datum/reagent/consumable/ethanol/custom_brew, trans_volume)
