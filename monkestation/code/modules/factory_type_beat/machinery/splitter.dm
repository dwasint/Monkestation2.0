/obj/structure/belt_splitter
	name = "belt splitter"
	desc = "takes an input from one side and tries to output it on any side that has a belt."

	icon = 'monkestation/code/modules/factory_type_beat/icons/mining_machines.dmi'
	icon_state = "splitter"

	anchored = TRUE

	var/current_split_number = 1

	var/list/direction_order = list(NORTH, EAST, SOUTH, WEST)

/obj/structure/belt_splitter/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(try_split),
	)
	AddComponent(/datum/component/connect_loc_behalf, src, loc_connections)
	AddComponent(/datum/component/simple_rotation)

/obj/structure/belt_splitter/Destroy()
	. = ..()

/obj/structure/belt_splitter/proc/try_split(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(arrived.anchored)
		return
	var/direction = direction_order[current_split_number]
	current_split_number++
	if(current_split_number > length(direction_order))
		current_split_number = 1
	if(direction == dir)
		direction = direction_order[current_split_number]

	if(!(locate(/obj/machinery/conveyor) in get_step(src, direction)))
		return
	arrived.forceMove(get_step(src, direction))
