
/obj/structure/cult
	density = 1
	anchored = 1
	icon = 'monkestation/code/modules/bloody_cult/icons/cult.dmi'
	max_integrity = 50
	var/sound_damaged = null
	var/sound_destroyed = null
	var/conceal_cooldown = 0
	var/timeleft = 0
	var/timetotal = 0
	var/list/contributors = list()// list of cultists currently participating in the ritual
	var/min_contributors = 1 	  // how many cultists we need for the current ritual
	var/image/progbar = null//progress bar
	var/cancelling = 3//check to abort the ritual if interrupted
	var/custom_process = 0
	//if we have a map id we create a holomap marker
	var/map_id
	var/marker_icon = 'monkestation/code/modules/bloody_cult/icons/holomap_markers.dmi'
	var/marker_icon_state

/obj/structure/cult/Initialize(mapload)
	. = ..()
	if(map_id)
		var/datum/holomap_marker/holomarker = new(src)
		holomarker.id = map_id
		holomarker.filter = HOLOMAP_FILTER_CULT
		holomarker.x = src.x
		holomarker.y = src.y
		holomarker.z = src.z
		holomarker.icon = marker_icon
		holomarker.icon_state = marker_icon_state

/obj/structure/cult/get_cult_power()
	return 1//light emitted by those won't be reduced during the eclipse

/obj/structure/cult/proc/conceal()
	var/obj/structure/cult/concealed/C = new(loc)
	C.pixel_x = pixel_x
	C.pixel_y = pixel_y
	forceMove(C)
	C.held = src
	C.icon = icon
	C.icon_state = icon_state

/obj/structure/cult/proc/reveal()
	conceal_cooldown = 1
	spawn (100)
		if (src && loc)
			conceal_cooldown = 0

/obj/structure/cult/concealed
	density = 0
	anchored = 1
	alpha = 127
	invisibility = INVISIBILITY_OBSERVER
	var/obj/structure/cult/held = null

/obj/structure/cult/concealed/reveal()
	if (held)
		held.forceMove(loc)
		held.reveal()
		held = null
	qdel(src)

/obj/structure/cult/concealed/conceal()
	return

/obj/structure/cult/concealed/takeDamage(var/damage)
	return

//if you want indestructible buildings, just make a custom takeDamage() proc
/obj/structure/cult/proc/takeDamage(var/damage)
	atom_integrity -= damage
	if (atom_integrity <= 0)
		if (sound_destroyed)
			playsound(src, sound_destroyed, 100, 1)
		qdel(src)
	else
		update_icon()

//duh
/obj/structure/cult/narsie_act()
	. = ..()
	return

/obj/structure/cult/ex_act(var/severity)
	switch(severity)
		if (1)
			takeDamage(100)
		if (2)
			takeDamage(20)
		if (3)
			takeDamage(4)

/obj/structure/cult/blob_act()
	playsound(src, sound_damaged, 75, 1)
	takeDamage(20)

/obj/structure/cult/bullet_act(var/obj/projectile/Proj)
	takeDamage(Proj.damage)
	return ..()

/obj/structure/cult/attackby(var/obj/item/weapon/W, var/mob/user, params)
	if (istype(W))
		if(!(user.istate & ISTATE_HARM )|| W.force == 0)
			visible_message("<span class='warning'>\The [user] gently taps \the [src] with \the [W].</span>")
		else
			user.do_attack_animation(src, W)
	//		if (W.hitsound)
	//			playsound(src, W.hitsound, 50, 1, -1)
			if (sound_damaged)
				playsound(src, sound_damaged, 75, 1)
			if(isholyweapon(W))
				//playsound(loc, 'sound/weapons/welderattack.ogg', 50, 1)
				takeDamage(W.force*2)
			else
				takeDamage(W.force)
			visible_message("<span class='warning'>\The [user] hits \the [src] with \the [W].</span>")
			..()


/obj/structure/cult/attack_paw(var/mob/user)
	return attack_hand(user)


/obj/structure/cult/attack_hand(var/mob/living/user)
	if(user.istate & ISTATE_HARM)
		user.visible_message("<span class='danger'>[user.name] [pick("kicks","punches")] \the [src]!</span>", \
							"<span class='danger'>You strike at \the [src]!</span>", \
							"You hear stone cracking.")
		user.adjustBruteLoss(3)
		if (sound_damaged)
			playsound(src, sound_damaged, 75, 1)
	else if(IS_CULTIST(user))
		cultist_act(user)
	else
		noncultist_act(user)

/obj/structure/cult/proc/cultist_act(var/mob/user)
	return 1

/obj/structure/cult/proc/noncultist_act(var/mob/user)
	to_chat(user,"<span class='sinister'>You feel madness taking its toll, trying to figure out \the [name]'s purpose</span>")
	//might add some hallucinations or brain damage later, checks for cultist chaplains, etc
	return 1

/obj/structure/cult/proc/safe_space()
	for(var/turf/T in range(5,src))
		var/dist = cheap_pythag(T.x - src.x, T.y - src.y)
		if (dist <= 2.5)
			T.ChangeTurf(/turf/open/floor/engine/cult)
			T.turf_animation('monkestation/code/modules/bloody_cult/icons/effects.dmi',"cultfloor", 0, 0, MOB_LAYER-1, anim_plane = GAME_PLANE)
			for (var/obj/structure/S in T)
				if (!istype(S,/obj/structure/cult))
					qdel(S)
			for (var/obj/machinery/M in T)
				qdel(M)
		else if (dist <= 4.5)
			if (istype(T, /turf/open/space))
				T.ChangeTurf(/turf/open/floor/engine/cult)
				T.turf_animation('monkestation/code/modules/bloody_cult/icons/effects.dmi',"cultfloor", 0, 0, MOB_LAYER-1, anim_plane = GAME_PLANE)
			else
				T.narsie_act()
		else if (dist <= 5.5)
			if (istype(T, /turf/open/space))
				T.ChangeTurf(/turf/closed/wall/mineral/cult)
				T.turf_animation('monkestation/code/modules/bloody_cult/icons/effects.dmi',"cultwall", 0, 0, MOB_LAYER-1, anim_plane = GAME_PLANE)
			else
				T.narsie_act()

//inspired from LoZ:Oracle of Seasons
/obj/structure/cult/proc/dance_start()
	while(timeleft > 0)
		for (var/mob/M in contributors)
			if (!IS_CULTIST(M) || get_dist(src,M) > 1 || M.incapacitated() || M.occult_muted())
				if (M.client)
					M.client.images -= progbar
				contributors.Remove(M)
				continue
		if (contributors.len <= 0)
			return 0
		if(contributors.len < min_contributors)
			sleep(10)
			continue
		timeleft -= 1 + round(contributors.len/2)//Additional dancers will complete the ritual faster
		update_progbar()
		dance_step()
		sleep(3)
		dance_step()
		sleep(3)
		dance_step()
		sleep(6)
	for (var/mob/M in contributors)
		if (M.client)
			M.client.images -= progbar
		ritual_reward(M)
		contributors.Remove(M)
	return 1

/obj/structure/cult/proc/ritual_reward(var/mob/M)
	return

/obj/structure/cult/proc/dance_step()
	var/dance_move = pick("clock","counter","spin")

	switch(dance_move)
		if ("clock")
			for (var/mob/M in contributors)
				switch (get_dir(src,M))
					if (NORTHWEST,NORTH)
						M.forceMove(get_step(M,EAST))
						M.dir = EAST
					if (NORTHEAST,EAST)
						M.forceMove(get_step(M,SOUTH))
						M.dir = SOUTH
					if (SOUTHEAST,SOUTH)
						M.forceMove(get_step(M,WEST))
						M.dir = WEST
					if (SOUTHWEST,WEST)
						M.forceMove(get_step(M,NORTH))
						M.dir = NORTH
		if ("counter")
			for (var/mob/M in contributors)
				switch (get_dir(src,M))
					if (NORTHEAST,NORTH)
						M.forceMove(get_step(M,WEST))
						M.dir = WEST
					if (SOUTHEAST,EAST)
						M.forceMove(get_step(M,NORTH))
						M.dir = NORTH
					if (SOUTHWEST,SOUTH)
						M.forceMove(get_step(M,EAST))
						M.dir = EAST
					if (NORTHWEST,WEST)
						M.forceMove(get_step(M,SOUTH))
						M.dir = SOUTH
		if ("spin")
			for (var/mob/M in contributors)
				spawn()
					M.dir = SOUTH
					sleep(0.75)
					M.dir = EAST
					sleep(0.75)
					M.dir = NORTH
					sleep(0.75)
					M.dir = WEST
					sleep(0.75)
					M.dir = SOUTH

