/**
* Respond to our atom being checked by a virus extrapolator
*
* Default behaviour is to send COMSIG_ATOM_EXTRAPOLATOR_ACT and return FALSE
*/
/atom/proc/extrapolator_act(mob/user, obj/item/extrapolator/E, scan = TRUE)
	if(SEND_SIGNAL(src, COMSIG_ATOM_EXTRAPOLATOR_ACT, user, E, scan))
		return TRUE
	return FALSE

/obj/item/extrapolator
	name = "virus extrapolator"
	icon = 'monkestation/icons/obj/device.dmi'
	icon_state = "extrapolator_scan"
	desc = "A scanning device, used to extract genetic material of potential pathogens"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	var/using = FALSE
	var/scan = TRUE
	var/cooldown
	var/obj/item/stock_parts/scanning_module/scanner //used for upgrading!

	var/list/stored_varient_types = list()

	var/datum/weakref/user_data

/obj/item/extrapolator/Initialize(mapload)
	. = ..()
	scanner = new(src)

/obj/item/extrapolator/Destroy()
	qdel(scanner)
	scanner = null
	user_data = null
	return ..()

/obj/item/extrapolator/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/scanning_module))
		if(!scanner)
			if(!user.transferItemToLoc(W, src))
				return
			scanner = W
			to_chat(user, "<span class='notice'>You install a [scanner.name] in [src].</span>")
		else
			to_chat(user, "<span class='notice'>[src] already has a scanner installed.</span>")

	else if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(scanner)
			to_chat(user, "<span class='notice'>You remove the [scanner.name] from \the [src].</span>")
			scanner.forceMove(drop_location())
			scanner = null
	else
		return ..()

/obj/item/extrapolator/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		if(!scanner)
			. += "<span class='notice'>The scanner is missing.</span>"
		else
			. += "<span class='notice'>A class <b>[scanner.rating]</b> scanning module is installed. It is <i>screwed</i> in place.</span>"

	. += span_notice("List of Stored Varients.")
	for(var/datum/symptom_varient/varient as anything in stored_varient_types)
		. += span_notice("[initial(varient.name)] : [stored_varient_types[varient]]")


/obj/item/extrapolator/attack(atom/AM, mob/living/user)
	return

/obj/item/extrapolator/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag && !scan)
		return
	if(isliving(target))
		user_data = WEAKREF(target)
	if(scanner)
		if(!scan)
			if(length(stored_varient_types))
				try_disease_modification(user, target)
		switch(target.extrapolator_act(user, src, scan))
			if(FALSE)
				if(scan)
					to_chat(user, "<span class='notice'>the extrapolator fails to return any data</span>")
			if(TRUE)
				to_chat(user, span_notice("You store [target]'s blood sample in [src]."))

	else
		to_chat(user, "<span class='warning'>the extrapolator has no scanner installed</span>")

/obj/item/extrapolator/attack_self(mob/user)
	. = ..()
	if(scan)
		var/atom/resolved_target = user_data?.resolve()
		if(!resolved_target)
			return
		resolved_target?.extrapolator_act(user, src, scan)

/obj/item/extrapolator/attack_self_secondary(mob/user, modifiers)
	. = ..()
	playsound(src, 'sound/machines/click.ogg', 50, 1)
	if(scan)
		icon_state = "extrapolator_sample"
		scan = FALSE
		to_chat(user, "<span class='notice'>You remove the probe from the device and set it to inject genes into diseases or symptoms</span>")
	else
		icon_state = "extrapolator_scan"
		scan = TRUE
		to_chat(user, "<span class='notice'>You put the probe back in the device and set it to SCAN</span>")


/obj/item/extrapolator/proc/try_disease_modification(mob/user, atom/target)
	if(!isliving(target) && !istype(target, /obj/item/weapon/virusdish))
		return
	var/list/named_list = list()
	for(var/datum/symptom_varient/varient as anything in stored_varient_types)
		named_list |= initial(varient.name)

	var/choice = tgui_input_list(user, "Stored Varients", src.name, named_list)

	if(!choice)
		return

	var/datum/symptom_varient/new_varient
	for(var/datum/symptom_varient/listed_varient as anything in stored_varient_types)
		if(initial(listed_varient.name) != choice)
			continue
		new_varient = listed_varient

	if(istype(target, /obj/item/weapon/virusdish))
		var/obj/item/weapon/virusdish/dish = target
		if(!dish.contained_virus)
			return
		try_symptom_change(user, dish.contained_virus, new_varient)

	else
		var/mob/living/living = target
		if(!length(living.diseases))
			return

		var/datum/disease/disease_choice = tgui_input_list(user, "Choose a disease to splice", src.name, living.diseases)
		if(!disease_choice)
			return

		try_symptom_change(user, disease_choice, new_varient)

/obj/item/extrapolator/proc/try_symptom_change(mob/user, datum/disease/advanced/choice, datum/symptom_varient/new_varient)
	var/datum/symptom/symptom = tgui_input_list(user, "Choose a symptom to modify", src.name, choice.symptoms)
	if(!symptom)
		return
	if(symptom.attached_varient)
		say("ERROR: Symptom is already a varient strain!")
		return

	stored_varient_types[new_varient]--
	if(stored_varient_types[new_varient] <= 0)
		stored_varient_types -= new_varient

	new_varient = new new_varient(symptom, choice)

	symptom.attached_varient = new_varient
	symptom.update_name()

/obj/item/extrapolator/proc/generate_varient()
	var/list/weighted_list = list()
	for(var/datum/symptom_varient/varient as anything in subtypesof(/datum/symptom_varient))
		weighted_list[varient] = initial(varient.weight)

	var/datum/symptom_varient/varient = pick_weight(weighted_list)


	if(!(varient in stored_varient_types))
		stored_varient_types[varient] = 1
	else
		stored_varient_types[varient]++


//TODO: Add a UI for the splicing instead of a series of tgui inputs this would make it far nicer
