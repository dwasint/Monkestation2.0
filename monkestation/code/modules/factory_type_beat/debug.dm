/proc/count_lists()
#ifdef OPENDREAM
#else
	var/list_count = 0
	for(var/list/list)
		list_count++

	var/file = file("data/list_count/[GLOB.round_id].txt")

	WRITE_FILE(file, list_count)
#endif

/proc/save_types()
#ifdef OPENDREAM
#else
	var/datum/D
	var/atom/A
	var/list/counts = new
	for(A) counts[A.type] = (counts[A.type]||0) + 1
	for(D) counts[D.type] = (counts[D.type]||0) + 1

	var/F = file("data/type_tracker/[GLOB.round_id]-stat_track.txt")
	for(var/i in counts)
		WRITE_FILE(F, "[i]\t[counts[i]]\n")
#endif

/proc/save_datums()
#ifdef OPENDREAM
#else
	var/datum/D
	var/list/counts = new
	for(D) counts[D.type] = (counts[D.type]||0) + 1

	var/F = file("data/type_tracker/[GLOB.round_id]-datums-[world.time].txt")
	for(var/i in counts)
		WRITE_FILE(F, "[i]\t[counts[i]]\n")
#endif

///these procs don't work on od
SUBSYSTEM_DEF(memory_stats)
	name = "Mem Stats"
	init_order = INIT_ORDER_AIR
	priority = FIRE_PRIORITY_AIR
	wait = 5 MINUTES
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME


/datum/controller/subsystem/memory_stats/fire(resumed)
	if(world.system_type == MS_WINDOWS)
		var/memory_summary = call_ext("memorystats", "get_memory_stats")()
		var/file = file("data/mem_stat/[GLOB.round_id]-memstat.txt")

		WRITE_FILE(file, memory_summary)
