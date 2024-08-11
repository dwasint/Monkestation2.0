/proc/count_lists()
	var/list_count = 0
	for(var/list/list)
		list_count++

	var/file = file("data/list_count/[GLOB.round_id].txt")

	WRITE_FILE(file, list_count)


SUBSYSTEM_DEF(memory_stats)
	name = "Mem Stats"
	init_order = INIT_ORDER_AIR
	priority = FIRE_PRIORITY_AIR
	wait = 5 MINUTES
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME


/datum/controller/subsystem/memory_stats/fire(resumed)
	. = ..()
	var/memory_summary = call_ext("auxmemorystats", "get_memory_stats")()
	var/file = file("data/mem_stat/[round_id]-memstat.txt")

	WRITE_FILE(file, memory_summary)
