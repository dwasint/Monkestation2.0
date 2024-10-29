/obj/machinery/computer/security/telescreen/entertainment/spesstv
	name = "low-latency Spess.TV CRT monitor"
	desc = "An ancient computer monitor. They don't make them like they used to. A sticker reads: \"Come be their hero\"."
	network = list("SpessTV")
	density = TRUE
	ui_path = "SpessTVCameraConsole"

	icon = 'icons/obj/computer.dmi'
	icon_state = "television"
	icon_keyboard = null
	icon_screen = "detective_tv"
	pass_flags = PASSTABLE

/obj/machinery/computer/security/telescreen/entertainment/spesstv/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("follow")
			var/obj/machinery/camera/spesstv/camera = active_camera
			if(!istype(camera))
				return
			var/datum/antagonist/streamer/streamer_role = camera.streamer
			if(!istype(streamer_role))
				return
			streamer_role.try_add_follower(usr.mind)
		if("subscribe")
			var/obj/machinery/camera/spesstv/camera = active_camera
			if(!istype(camera))
				return
			var/datum/antagonist/streamer/streamer_role = camera.streamer
			if(!istype(streamer_role))
				return
			streamer_role.try_add_subscription(usr.mind, src)
