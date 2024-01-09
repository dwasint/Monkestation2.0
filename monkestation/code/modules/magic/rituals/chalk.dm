/obj/item/ritual_chalk
	name = "ritual chalk"
	desc = "Used in the creation of large scale magic rituals."

	icon = 'monkestation/code/modules/magic/icons/items.dmi'
	icon_state = "ritual_chalk"

	var/chalk_choice = "Light"

	var/static/list/name_to_color = list()

/obj/item/ritual_chalk/Initialize(mapload)
	. = ..()
	if(!length(name_to_color))
		for(var/obj/effect/decal/cleanable/rune/rune as anything in subtypesof(/obj/effect/decal/cleanable/rune))
			name_to_color["[initial(rune.chalk_name)]"] = initial(rune.color)

/obj/item/ritual_chalk/AltClick(mob/user)
	. = ..()
	var/temp_choice = tgui_input_list(user, "Choose a ritual base.", "[src.name]", name_to_color)
	if(!temp_choice)
		return
	chalk_choice = temp_choice


/obj/item/ritual_chalk/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!user.CanReach(target))
		return
	if (isturf(target))
		if(!locate(/obj/effect/decal/cleanable/ritual) in target.contents)
			try_draw_ritual(user, target)
		else
			var/obj/effect/decal/cleanable/ritual/ritual = locate(/obj/effect/decal/cleanable/ritual) in target.contents
			try_modify_ritual(user, ritual)

/obj/item/ritual_chalk/proc/try_draw_ritual(mob/user, turf/target_turf)
	if(do_after(user, 3 SECONDS, target_turf))
		var/obj/effect/decal/cleanable/ritual/ritual = new(target_turf)
		ritual.color = name_to_color[chalk_choice]
		ritual.ritual_base = chalk_choice

/obj/item/ritual_chalk/proc/try_modify_ritual(mob/user, obj/effect/decal/cleanable/ritual/ritual)
	var/center = tgui_alert(user, "Is this for the center of the ritual?", "[src.name]", list("Yes", "No"))

	switch(center)
		if("No")
			modify_outside_ritual(user, ritual)
		if("Yes")
			modify_ritual_center(user, ritual)

/obj/item/ritual_chalk/proc/modify_outside_ritual(mob/user, obj/effect/decal/cleanable/ritual/ritual)
	return
/obj/item/ritual_chalk/proc/modify_ritual_center(mob/user, obj/effect/decal/cleanable/ritual/ritual)
	if(ritual.center_rune)
		return
	switch(chalk_choice)
		if("Life")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/life(get_turf(ritual))
		if("Ice")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/ice(get_turf(ritual))
		if("Fire")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/fire(get_turf(ritual))
		if("Light")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/light(get_turf(ritual))
		if("Electric")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/electric(get_turf(ritual))
		if("Earth")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/earth(get_turf(ritual))
		if("Water")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/water(get_turf(ritual))
		if("Air")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/air(get_turf(ritual))
		if("Darkness")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/dark(get_turf(ritual))
		if("Blood")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/blood(get_turf(ritual))
		if("Time")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/time(get_turf(ritual))
		if("Death")
			ritual.center_rune = new /obj/effect/decal/cleanable/rune/death(get_turf(ritual))
