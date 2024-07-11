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
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_TINY
	var/using = FALSE
	var/scan = TRUE
	var/cooldown
	var/obj/item/stock_parts/scanning_module/scanner //used for upgrading!

/obj/item/extrapolator/Initialize(mapload)
	. = ..()
	scanner = new(src)

/obj/item/extrapolator/Destroy()
	qdel(scanner)
	scanner = null
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


/obj/item/extrapolator/attack(atom/AM, mob/living/user)
	return

/obj/item/extrapolator/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag && !scan)
		return
	if(scanner)
		if(!target.extrapolator_act(user, src, scan))

			if(scan)
				to_chat(user, "<span class='notice'>the extrapolator fails to return any data</span>")
			else
				to_chat(user, "<span class='notice'>the extrapolator's probe detects no diseases</span>")
	else
		to_chat(user, "<span class='warning'>the extrapolator has no scanner installed</span>")
