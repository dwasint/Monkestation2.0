PROCESSING_SUBSYSTEM_DEF(magic)
	name = "Magic"
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING

	wait = 1 SECOND
	priority = 10
	init_order = -96

/datum/controller/subsystem/processing/magic/Initialize()
	. = ..()

	generate_initial_leylines()

	return SS_INIT_SUCCESS
