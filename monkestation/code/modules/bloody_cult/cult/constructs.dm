
/mob/living/basic/construct
	var/construct_type = "Unknown"

/*
/////////////////Juggernaut///////////////
/mob/living/basic/construct/armoured/perfect
	icon_state = "juggernaut2"
	icon_living = "juggernaut2"
	icon_dead = "juggernaut2"
	construct_spells = list(
		/datum/action/cooldown/spell/forcewall/cult,
		/datum/action/cooldown/spell/basic_projectile/juggernaut,
		/datum/action/innate/cult/create_rune/wall,
		)
	see_in_dark = 7
	var/dash_dir = null
	var/turf/crashing = null


/mob/living/basic/construct/armoured/perfect/Bump(atom/obstacle)
	. = ..()
	if(src.throwing)
		var/breakthrough = 0
		if(istype(obstacle, /obj/structure/window/))
			var/obj/structure/window/W = obstacle
			W.take_damage(1000)
			breakthrough = 1

		else if(istype(obstacle, /obj/structure/grille/))
			var/obj/structure/grille/G = obstacle
			G.take_damage(G.max_integrity * 0.25)
			breakthrough = 1

		else if(istype(obstacle, /obj/structure/table))
			var/obj/structure/table/T = obstacle
			T.destroy()
			breakthrough = 1

		else if(istype(obstacle, /obj/structure/rack))
			new /obj/item/weapon/rack_parts(obstacle.loc)
			qdel(obstacle)
			breakthrough = 1

		else if(istype(obstacle, /turf/simulated/wall))
			var/turf/simulated/wall/W = obstacle
			if (W.hardness <= 60)
				playsound(W, 'sound/weapons/heavysmash.ogg', 75, 1)
				W.dismantle_wall(1)
				breakthrough = 1
			else
				src.throwing = 0
				src.crashing = null

		else if(istype(obstacle, /obj/structure/reagent_dispensers))
			var/obj/structure/reagent_dispensers/R = obstacle
			R.explode(src)

		else if(istype(obstacle, /mob/living))
			var/mob/living/L = obstacle
			if (L.flags & INVULNERABLE)
				src.throwing = 0
				src.crashing = null
			else if (!(L.status_flags & CANKNOCKDOWN) || (M_HULK in L.mutations) || istype(L,/mob/living/silicon))
				//can't be knocked down? you'll still take the damage.
				src.throwing = 0
				src.crashing = null
				L.take_overall_damage(5,0)
				if(L.locked_to)
					L.locked_to.unlock_atom(L)
			else
				L.take_overall_damage(5,0)
				if(L.locked_to)
					L.locked_to.unlock_atom(L)
				L.Stun(2)
				L.Knockdown(2)
				L.apply_effect(5, STUTTER)
				playsound(src, 'sound/weapons/heavysmash.ogg', 50, 0, 0)
				breakthrough = 1
		else
			src.throwing = 0
			src.crashing = null

		if(breakthrough)
			if(crashing && !istype(crashing,/turf/space))
				spawn(1)
					src.throw_at(crashing, 50, src.throw_speed)
			else
				spawn(1)
					crashing = get_distant_turf(get_turf(src), dash_dir, 2)
					src.throw_at(crashing, 50, src.throw_speed)

	if(istype(obstacle, /obj))
		var/obj/O = obstacle
		if(!O.anchored)
			step(obstacle,src.dir)
		else
			obstacle.Bumped(src)
	else if(istype(obstacle, /mob))
		step(obstacle,src.dir)
	else
		obstacle.Bumped(src)


////////////////////Wraith/////////////////////////


/mob/living/basic/construct/wraith/perfect
	icon_state = "wraith2"
	icon_living = "wraith2"
	icon_dead = "wraith2"
	see_in_dark = 7
	construct_spells = list(
		/spell/targeted/ethereal_jaunt/shift/alt,
		/spell/wraith_warp,
		/spell/aoe_turf/conjure/path_entrance,
		/spell/aoe_turf/conjure/path_exit,
		)
	var/warp_ready = FALSE

/mob/living/basic/construct/wraith/perfect/toggle_throw_mode()
	var/spell/wraith_warp/WW = locate() in spell_list
	WW.perform(src)


////////////////////Artificer/////////////////////////

/mob/living/basic/construct/builder/perfect
	icon_state = "artificer2"
	icon_living = "artificer2"
	icon_dead = "artificer2"
	see_in_dark = 7
	construct_spells = list(
		/spell/aoe_turf/conjure/struct,
		/spell/aoe_turf/conjure/wall,
		/spell/aoe_turf/conjure/floor,
		/spell/aoe_turf/conjure/door,
		/spell/aoe_turf/conjure/pylon,
		/spell/aoe_turf/conjure/construct/lesser/alt,
		/spell/aoe_turf/conjure/soulstone,
		/spell/aoe_turf/conjure/hex,
		)
	var/mob/living/basic/construct/heal_target = null
	var/obj/effect/overlay/artificerray/ray = null
	var/heal_range = 2
	var/list/minions = list()
	var/list/satellites = list()

/obj/abstract/satellite
	mouse_opacity = 0
	invisibility = 101
	icon = 'icons/effects/effects.dmi'
	icon_state = "blank"

/mob/living/basic/construct/builder/perfect/proc/update_satellites()
	var/turf/T = get_turf(src)
	while(satellites.len < 3)
		var/obj/abstract/satellite/S = new(T)
		satellites.Add(S)
	var/obj/abstract/satellite/satellite_A = satellites[1]
	var/obj/abstract/satellite/satellite_B = satellites[2]
	var/obj/abstract/satellite/satellite_C = satellites[3]
	satellite_A.forceMove(get_step(T, turn(dir, 180)))//behind
	satellite_B.forceMove(get_step(T, turn(dir, 135)))//behind on one side
	satellite_C.forceMove(get_step(T, turn(dir, 225)))//behind on the other side

/mob/living/basic/construct/builder/perfect/Life()
	if(timestopped)
		return 0
	. = ..()
	if(. && heal_target)
		heal_target.health = min(heal_target.maxHealth, heal_target.health + round(heal_target.maxHealth/10))
		heal_target.update_icons()
		anim(target = heal_target, a_icon = 'icons/effects/effects.dmi', flick_anim = "const_heal", lay = NARSIE_GLOW, plane = ABOVE_LIGHTING_PLANE)
		move_ray()
	update_satellites()

/mob/living/basic/construct/builder/perfect/Move(NewLoc,Dir=0,step_x=0,step_y=0,var/glide_size_override = 0)
	. = ..()
	if (ray)
		move_ray()
	update_satellites()

/mob/living/basic/construct/builder/perfect/forceMove(atom/destination, step_x = 0, step_y = 0, no_tp = FALSE, harderforce = FALSE, glide_size_override = 0)
	. = ..()
	if (ray)
		move_ray()
	update_satellites()

/mob/living/basic/construct/builder/perfect/proc/start_ray(var/mob/living/basic/construct/target)
	if (!istype(target))
		return
	if (locate(src) in target.healers)
		to_chat(src, "<span class='warning'>You are already healing \the [target].</span>")
		return
	if (ray)
		end_ray()
	target.healers.Add(src)
	heal_target = target
	ray = new (loc)
	to_chat(src, "<span class='notice'>You are now healing \the [target].</span>")
	move_ray()

/mob/living/basic/construct/builder/perfect/proc/move_ray()
	if(heal_target && ray && heal_target.health < heal_target.maxHealth && get_dist(heal_target, src) <= heal_range && isturf(loc) && isturf(heal_target.loc))
		ray.forceMove(loc)
		var/disty = heal_target.y - src.y
		var/distx = heal_target.x - src.x
		var/newangle
		if(!disty)
			if(distx >= 0)
				newangle = 90
			else
				newangle = 270
		else
			newangle = arctan(distx/disty)
			if(disty < 0)
				newangle += 180
			else if(distx < 0)
				newangle += 360
		var/matrix/M = matrix()
		if (ray.oldloc_source && ray.oldloc_target && get_dist(src,ray.oldloc_source) <= 1 && get_dist(heal_target,ray.oldloc_target) <= 1)
			animate(ray, transform = turn(M.Scale(1,sqrt(distx*distx+disty*disty)),newangle),time = 1)
		else
			ray.transform = turn(M.Scale(1,sqrt(distx*distx+disty*disty)),newangle)
		ray.oldloc_source = src.loc
		ray.oldloc_target = heal_target.loc
	else
		end_ray()

/mob/living/basic/construct/builder/perfect/proc/end_ray()
	if (heal_target)
		heal_target.healers.Remove(src)
		heal_target = null
	if (ray)
		QDEL_NULL(ray)

/obj/effect/overlay/artificerray
	name = "ray"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "artificer_ray"
	layer = FLY_LAYER
	plane = LYING_MOB_PLANE
	anchored = 1
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -29
	var/turf/oldloc_source = null
	var/turf/oldloc_target = null

/obj/effect/overlay/artificerray/narsie_act()
	return

/obj/effect/overlay/artificerray/ex_act()
	return

/obj/effect/overlay/artificerray/emp_act()
	return

/obj/effect/overlay/artificerray/blob_act()
	return

/obj/effect/overlay/artificerray/singularity_act()
	return


/mob/living/simple_animal/hostile/hex
	name = "\improper Hex"
	desc = "A lesser construct, crafted by an Artificer."
	stop_automated_movement_when_pulled = 1
	ranged_cooldown_cap = 1
	icon = 'icons/mob/mob.dmi'
	icon_state = "hex"
	icon_living = "hex"
	icon_dead = "hex"
	speak_chance = 0
	turns_per_move = 8
	response_help = "gently taps"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 0.2
	maxHealth = 50
	health = 50
	can_butcher = 0
	ranged = 1
	retreat_distance = 4
	minimum_distance = 4
	projectilesound = 'sound/effects/forge.ogg'
	projectiletype = /obj/projectile/bloodslash
	move_to_delay = 1
	mob_property_flags = MOB_SUPERNATURAL
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "grips"
	attack_sound = 'sound/weapons/rapidslice.ogg'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 5
	supernatural = 1
	faction = "cult"
	flying = 1
	environment_smash_flags = 0
	var/mob/living/basic/construct/builder/perfect/master = null
	var/no_master = TRUE
	var/glow_color = "#FFFFFF"

	var/image/master_glow = null
	var/image/harm_glow = null

	var/mode = HEX_MODE_ROAMING
	var/passive = FALSE
	var/turf/guard_spot = null
	/*
	HEX_MODE_ROAMING 	: Usual mob roaming behaviour.
	HEX_MODE_GUARD 		: Stands in place. If it spots an enemy, will chase it, then attempt to return to the spot where they were placed.
	HEX_MODE_ESCORT		: Follows the Artificer that summoned them around if they're close enough, otherwise stays idle. Shoots at enemies but doesn't chase them.
	*/

/mob/living/simple_animal/hostile/hex/New()
	..()
	setupglow(glow_color)
	update_harmglow()
	animate(src, pixel_y = 4 * 1 , time = 10, loop = -1, easing = SINE_EASING)
	animate(pixel_y = 2 * 1, time = 10, loop = -1, easing = SINE_EASING)

/mob/living/simple_animal/hostile/hex/adjustBruteLoss(damage)
	..()
	update_icons()

/mob/living/simple_animal/hostile/hex/update_icons()
	overlays = 0

	var/damage = maxHealth - health
	var/icon/damageicon
	if (damage > (2*maxHealth/3))
		damageicon = icon(icon,"wraith2_damage_high")//fits well enough
	else if (damage > (maxHealth/3))
		damageicon = icon(icon,"wraith2_damage_low")
	if (damageicon)
		damageicon.Blend(glow_color, ICON_ADD)
		var/image/damage_overlay = image(icon = damageicon, layer = ABOVE_LIGHTING_LAYER)
		damage_overlay.plane = ABOVE_LIGHTING_PLANE
		overlays += damage_overlay

	setupglow(glow_color)
	update_harmglow()

/mob/living/simple_animal/hostile/hex/proc/setupglow(var/_glowcolor = "#FFFFFF")
	glow_color = _glowcolor
	overlays -= master_glow
	var/icon/glowicon = icon(icon,"glow-[icon_state]")
	glowicon.Blend(_glowcolor, ICON_ADD)
	master_glow = image(icon = glowicon, layer = ABOVE_LIGHTING_LAYER)
	master_glow.plane = ABOVE_LIGHTING_PLANE
	overlays += master_glow

/mob/living/simple_animal/hostile/hex/proc/update_harmglow()
	overlays -= harm_glow
	harm_glow = image(icon, src, "[passive ? "glow-hex-passive" : "glow-hex-harm"]", layer = ABOVE_LIGHTING_LAYER)
	harm_glow.plane = ABOVE_LIGHTING_PLANE+1
	overlays += harm_glow

/mob/living/simple_animal/hostile/hex/Destroy()
	if (master)
		master.minions.Remove(src)
		if (iscultist(master))
			master.DisplayUI("Cultist Right Panel")
	master = null
	..()

/mob/living/simple_animal/hostile/hex/Life()
	if(timestopped)
		return 0
	if (mode != HEX_MODE_ROAMING)
		stop_automated_movement = 1
	. = ..()
	if (!no_master)
		if (!master || master.gcDestroyed || master.isDead())
			adjustBruteLoss(20)//we shortly die out after our master's demise
			mode = HEX_MODE_ROAMING
	switch(mode)
		if (HEX_MODE_GUARD)
			if (stance == HOSTILE_STANCE_IDLE)
				if (!guard_spot)
					guard_spot = get_turf(src)
				else
					var/turf/T = get_turf(src)
					if (T != guard_spot)
						if ((T.z == guard_spot.z) && (get_dist(T,guard_spot) < 50))
							Goto(guard_spot,move_to_delay,0)
						else
							guard_spot = get_turf(src)
					else
						dir = turn(dir, -90)
		if (HEX_MODE_ESCORT)
			escort_routine()
		else
			guard_spot = null

/mob/living/simple_animal/hostile/hex/proc/escort_routine()
	guard_spot = null
	var/escorts = 0
	var/spot = 0
	for (var/mob/living/simple_animal/hostile/hex/H in master.minions)
		if (H.mode == HEX_MODE_ESCORT)
			escorts++
		if (H == src)
			spot = escorts
	if (escorts == 1)
		Goto(master.satellites[1],move_to_delay,0)//trailing behind
		if (!target && (loc == get_turf(master.satellites[1])))
			dir = master.dir
	else
		Goto(master.satellites[spot+1],move_to_delay,0)//trailing on each sides
		if (!target && (loc == get_turf(master.satellites[spot+1])))
			dir = master.dir

/mob/living/simple_animal/hostile/hex/Cross(var/atom/movable/mover, var/turf/target, var/height=1.5, var/air_group = 0)
	if(istype(mover, /obj/projectile/bloodslash))//stop hitting yourself ffs!
		return 1
	if ((mode == HEX_MODE_ESCORT) && (istype(mover, /mob/living/simple_animal/hostile/hex) || (mover == master)))//Escort mode is janky otherwise
		return 1

	return ..()

/mob/living/simple_animal/hostile/hex/Move(NewLoc,Dir=0,step_x=0,step_y=0,var/glide_size_override = 0)
	. = ..()
	if (target)
		dir = get_dir(src, target)

/mob/living/simple_animal/hostile/hex/forceMove(atom/destination, step_x = 0, step_y = 0, no_tp = FALSE, harderforce = FALSE, glide_size_override = 0)
	. = ..()
	if (target)
		dir = get_dir(src, target)

/mob/living/simple_animal/hostile/hex/death(var/gibbed = FALSE)
	..(TRUE) //If they qdel, they gib regardless
	for(var/i=0;i<3;i++)
		new /obj/item/weapon/ectoplasm (src.loc)
	visible_message("<span class='warning'>\The [src] collapses in a shattered heap. </span>")
	qdel (src)

/mob/living/simple_animal/hostile/hex/isValidTarget(var/atom/the_target)
	if (passive)
		return FALSE
	if(ismob(the_target))
		var/mob/M = the_target
		if(isanycultist(M))
			return FALSE
		if (iscarbon(M))
			var/mob/living/carbon/C = M
			if (istype(C.handcuffed,/obj/item/restraints/handcuffs/cult)) //hex don't attack prisoners
				return FALSE
		if (locate(/obj/effect/stun_indicator) in M)//or people that got stun paper'd
			return FALSE
		if (locate(/obj/effect/cult_ritual/conversion) in M.loc)//or people that stand on top of an active conversion rune
			return FALSE
	return TRUE

/mob/living/simple_animal/hostile/hex/MoveToTarget()
	if (mode == HEX_MODE_ESCORT)
		stop_automated_movement = 1
		if(!target || !CanAttack(target))
			LoseTarget()
			return
		if(isturf(loc))
			if(target in ListTargets())
				dir = get_dir(src, target)
				if(get_dist(src,target) >= 2 && ranged_cooldown <= 0)
					OpenFire(target)
				if(target.Adjacent(src))
					AttackingTarget()
				return
		LostTarget()
	else
		..()

/mob/living/simple_animal/hostile/hex/narsie_act()
	return


////////////////////Harvester/////////////////////////


/mob/living/basic/construct/harvester/perfect
	desc = "The reward of those who sacrificed their life so that Nar-Sie could rise."
	icon_state = "harvester2"
	icon_living = "harvester2"
	icon_dead = "harvester2"

	var/ready = FALSE

	construct_spells = list(
			/spell/targeted/harvest,
			/spell/aoe_turf/knock/harvester,
		)


/mob/living/basic/construct/harvester/perfect/New()
	..()
	flick("harvester2_spawn",src)
	spawn(10)
		ready = TRUE
		if (mind)
			var/datum/role/streamer/streamer_role = mind.GetRole(STREAMER)
			if(streamer_role && streamer_role.team == ESPORTS_CULTISTS)
				if(streamer_role.followers.len == 0 && streamer_role.subscribers.len == 0) //No followers and subscribers, use normal cult colors.
					construct_color = rgb(235,0,0) // STREAMER (no subs) -> RED
				else
					construct_color = rgb(30,255,30) // STREAMER (with subs) -> GREEN
			else
				construct_color = rgb(235,0,0)
		else
			construct_color = rgb(235,0,0)
		update_icons()

/mob/living/basic/construct/harvester/perfect/update_icons()
	if (ready)
		..()

*/
