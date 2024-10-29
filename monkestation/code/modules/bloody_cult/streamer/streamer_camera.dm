/obj/machinery/camera/spesstv
	name = "\improper Spess.TV camera"
	network = list("SpessTV")
	var/datum/antagonist/streamer/streamer
	var/static/suffix_tag = 0

/obj/machinery/camera/spesstv/Initialize(mapload, obj/structure/camera_assembly/old_assembly)
	. = ..()
	suffix_tag++

/obj/machinery/camera/spesstv/proc/name_camera()
	var/team_name = streamer?.team
	var/basename = streamer?.owner?.name || "Unknown"
	if(team_name)
		basename = "\[[team_name]\] [basename]"
	var/nethash = english_list(network)
	name = "[nethash]_0[suffix_tag]"
	c_tag = "[name] - [streamer.owner.current.name]"
