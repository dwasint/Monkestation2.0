
//////////////////////////////
//                          //
//   PERFORATING BLADE      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                          //Used when a filled soul blade performs a perforation
//////////////////////////////

/obj/projectile/soulbullet
	name = "soul blade"
	icon = 'monkestation/code/modules/bloody_cult/icons/cult_64x64.dmi'
	icon_state = "soulbullet"
	pixel_x = -16 * 1
	pixel_y = -10 * 1
	damage = 30//Only affects obj/turf. Mobs take a regular hit from the sword.
	mouse_opacity = 1
	var/turf/secondary_target = null
	var/obj/item/weapon/melee/soulblade/blade = null
	var/mob/living/basic/shade/shade = null
	var/redirected = 0
	var/leave_shadows = -1
	var/matrix/shadow_matrix = null

/obj/projectile/soulbullet/Destroy()
	var/turf/T = get_turf(src)
	if (T)
		if (blade)
			blade.forceMove(T)
	blade = null
	shade = null
	..()

/obj/projectile/soulbullet/fire(angle, atom/direct_target)
	var/atom/target = get_turf(direct_target)
	var/target_angle = get_angle(starting, direct_target)

	if (!secondary_target)
		secondary_target = target
	if (!shade)
		icon_state = "soulbullet-empty"
	if (target!=secondary_target)
		target_angle = round(get_angle(target,secondary_target))
		blade.dir = get_dir(target,secondary_target)
	else
		target_angle = round(get_angle(starting,target))
		blade.dir = get_dir(starting,target)
	shadow_matrix = turn(matrix(),target_angle+45)
	transform = shadow_matrix
	if (shade)
		icon_state = "soulbullet_spin"
		plane = HUD_PLANE
	else
		icon_state = "soulbullet-empty_spin"
	spawn(5)
		leave_shadows = 0
		if (shade)
			icon_state = "soulbullet"
		else
			icon_state = "soulbullet-empty"
	. = ..()

/*
/obj/projectile/soulbullet/bresenham_step(var/distA, var/distB, var/dA, var/dB)
	if (shade && leave_shadows >= 0)
		leave_shadows++
		if ((leave_shadows%3)==0)
			anim(target = loc, a_icon = 'monkestation/code/modules/bloody_cult/icons/cult_64x64.dmi', flick_anim = "soulblade-shadow", lay = NARSIE_GLOW, offX = pixel_x, offY = pixel_y, plane = ABOVE_LIGHTING_PLANE, trans = shadow_matrix)
	if(..())
		return 2
	else
		return 0
*/

/obj/projectile/soulbullet/Bump(atom/A)
	. = ..()
	if (shade)
		if (ismob(A))
			var/mob/M = A
			if (!IS_CULTIST(M))
				A.attackby(blade,shade)
			else if (!M.get_active_hand())//cultists and the blade's master can catch the blade on the fly
				blade.forceMove(loc)
				blade.attack_hand(M)
				to_chat(M, "<span class='warning'>Your hand moves by itself and catches \the [blade] out of the air.</span>")
				blade = null
				qdel(src)
			else if (!M.get_inactive_hand())
				blade.forceMove(loc)
				M.swap_hand() // guarrantees
				blade.attack_hand(M)
				to_chat(M, "<span class='warning'>Your hand moves by itself and catches \the [blade] out of the air.</span>")
				M.swap_hand()
				blade = null
				qdel(src)
		else
			A.attackby(blade,shade)
	else
		if (ismob(A))
			var/mob/M = A
			if (!IS_CULTIST(M))
				A.hitby(blade)
			else if (!M.get_active_hand())//cultists can catch the blade on the fly
				blade.forceMove(loc)
				blade.attack_hand(M)
				to_chat(M, "<span class='warning'>Your hand moves by itself and catches \the [blade] out of the air.</span>")
				blade = null
				qdel(src)
			else if (!M.get_inactive_hand())
				blade.forceMove(loc)
				M.swap_hand()
				blade.attack_hand(M)
				to_chat(M, "<span class='warning'>Your hand moves by itself and catches \the [blade] out of the air.</span>")
				M.swap_hand()
				blade = null
				qdel(src)
		else
			A.hitby(blade)
	if(isliving(A))
		forceMove(get_step(loc,dir))
		if (!redirected)
			redirect()
	else
		..()


/obj/projectile/soulbullet/proc/redirect()
	redirected = 1
	speed = 0.66
	set_angle(rand(0, 360))

/obj/projectile/soulbullet/narsie_act()
	return

/obj/projectile/soulbullet/attackby(var/obj/item/I, var/mob/user)
	if (blade)
		return blade.attackby(I,user)

/obj/projectile/soulbullet/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if (blade)
		return blade.hitby(hitting_atom)

/obj/projectile/soulbullet/bullet_act(var/obj/projectile/P)
	. = ..()
	if (blade)
		return blade.bullet_act(P)

//////////////////////////////
//                          //
//        BLOOD SLASH       ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                          //Used when a cultist swings a soul blade that has at least 5 blood in it.
//////////////////////////////

/obj/projectile/bloodslash
	name = "blood slash"
	icon = 'monkestation/code/modules/bloody_cult/icons/projectiles_experimental.dmi'
	icon_state = "bloodslash"
	damage = 15
	damage_type = BURN

/obj/projectile/bloodslash/Destroy()
	var/turf/T = get_turf(src)
	playsound(T, 'monkestation/code/modules/bloody_cult/sound/forge_over.ogg', 100, 1)
	if (!locate(/obj/effect/decal/cleanable/blood/splatter) in T)
		var/obj/effect/decal/cleanable/blood/splatter/S = new (T)//splash
		S.count = 1
	..()

/obj/projectile/bloodslash/Bump(atom/A)
	if (isliving(A))
		forceMove(A.loc)
		var/mob/living/M = A
		if (!IS_CULTIST(M))
			..()
	qdel(src)

/obj/projectile/bloodslash/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if (isliving(target))
		var/mob/living/M = target
		if (IS_CULTIST(M))
			return BULLET_ACT_BLOCK
		if (M.stat == DEAD)
			return BULLET_ACT_BLOCK
		to_chat(M, "<span class='warning'>You feel a searing heat inside of you!</span>")

/obj/projectile/bloodslash/narsie_act()
	return


//////////////////////////////
//                          //
//        BLOOD NAIL        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                          //Used when a cultist throws a blood dagger
//////////////////////////////

/obj/projectile/blooddagger
	name = "blood dagger"
	icon = 'monkestation/code/modules/bloody_cult/icons/projectiles_experimental.dmi'
	icon_state = "blood_dagger"
	damage = 5
	speed = 0.66
	var/absorbed = 0
	var/stacks = 0

/obj/projectile/blooddagger/Destroy()
	var/turf/T = get_turf(src)
	playsound(T, 'monkestation/code/modules/bloody_cult/sound/forge_over.ogg', 100, 1)
	if (!absorbed && !locate(/obj/effect/decal/cleanable/blood/splatter) in T)
		var/obj/effect/decal/cleanable/blood/splatter/S = new (T)//splash
		if (color)
			S.color = color
			S.update_icon()
	..()

/obj/projectile/blooddagger/Bump(atom/A)
	. = ..()
	if (isliving(A))
		forceMove(A.loc)
		var/mob/living/M = A
		if (!IS_CULTIST(M))
			density = FALSE
			invisibility = 101
			var/obj/effect/rooting_trap/bloodnail/nail = new (A.loc)
			nail.transform = transform
			if (color)
				nail.color = color
			else
				nail.color = COLOR_BLOOD
			if(isliving(A))
				nail.stick_to(A)
				var/mob/living/L = A
				L.take_overall_damage(damage,0)
				to_chat(L, "<span class='warning'>\The [src] stabs your body, sticking you in place.</span>")
				to_chat(L, "<span class='danger'>Resist or click the nail to dislodge it.</span>")
			else if(loc)
				var/turf/T = get_turf(src)
				nail.stick_to(T,get_dir(src,A))
			qdel(src)
			return
		else if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (!HAS_TRAIT(H, TRAIT_NOBLOOD))
				H.blood_volume += 5 + stacks * 5
				to_chat(H, "<span class='notice'>[firer ? "\The [firer]'s" : "The"] [src] enters your body painlessly, irrigating your vessels with some fresh blood.</span>")
			else
				to_chat(H, "<span class='notice'>[firer ? "\The [firer]'s" : "The"] [src] enters your body, but you have no vessels to irrigate.</span>")
			absorbed = 1
			playsound(H, 'monkestation/code/modules/bloody_cult/sound/bloodyslice.ogg', 30, 1)

	qdel(src)

/obj/projectile/blooddagger/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if (isliving(target))
		var/mob/living/M = target
		if (IS_CULTIST(M))
			return BULLET_ACT_BLOCK
		if (M.stat == DEAD)
			return BULLET_ACT_BLOCK


/obj/projectile/blooddagger/narsie_act()
	return
