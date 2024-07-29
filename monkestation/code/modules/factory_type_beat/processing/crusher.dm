/obj/machinery/bouldertech/crusher
	name = "crusher"
	desc = "Crushes clumps of ore into dirty dust which needs to be enriched."
	allows_boulders = FALSE
	holds_minerals = TRUE
	processable_materials = list(
		/datum/material/iron,
		/datum/material/titanium,
		/datum/material/silver,
		/datum/material/gold,
		/datum/material/uranium,
		/datum/material/mythril,
		/datum/material/adamantine,
		/datum/material/runite,
		/datum/material/glass,
		/datum/material/plasma,
		/datum/material/diamond,
		/datum/material/bluespace,
		/datum/material/bananium,
		/datum/material/plastic,
	)

/obj/machinery/bouldertech/crusher/process()
	if(!anchored)
		return PROCESS_KILL
	var/boulders_concurrent = boulders_processing_max ///How many boulders can we touch this process() call
	for(var/obj/item/potential_boulder as anything in boulders_contained)
		if(QDELETED(potential_boulder))
			boulders_contained -= potential_boulder
			break
		if(boulders_concurrent <= 0)
			break //Try again next time

		if(!istype(potential_boulder, /obj/item/boulder))
			process_clump(potential_boulder)
			continue

/obj/machinery/bouldertech/crusher/proc/process_clump(obj/item/processing/clumps/clump)
	for(var/datum/material/material as anything in clump.custom_materials)
		var/quantity = clump.custom_materials[material]
		var/obj/item/processing/dirty_dust/dust = new(get_step(src, export_side))
		dust.custom_materials += material
		dust.custom_materials[material] = quantity

	qdel(clump)
	playsound(loc, 'sound/weapons/drill.ogg', 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	update_boulder_count()

/obj/machinery/bouldertech/crusher/CanAllowThrough(atom/movable/mover, border_dir)
	if(!anchored)
		return FALSE
	if(boulders_contained.len >= boulders_held_max)
		return FALSE
	if(istype(mover, /obj/item/processing/clumps))
		return TRUE
	return ..()

/obj/machinery/bouldertech/crusher/return_extras()
	var/list/boulders_contained = list()
	for(var/obj/item/processing/clumps/boulder in contents)
		boulders_contained += boulder
	boulders_contained += return_extras()
	return boulders_contained

/obj/machinery/bouldertech/crusher/check_extras(obj/item/item)
	if(istype(item, /obj/item/processing/clumps))
		return TRUE
	return FALSE
