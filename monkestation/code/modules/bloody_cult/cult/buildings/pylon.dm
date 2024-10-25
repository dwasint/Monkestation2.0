/obj/structure/cult/pylon
	name = "pylon"
	desc = "A floating crystal that hums with an unearthly energy."
	icon_state = "pylon"
	light_outer_range = 5
	light_color = COLOR_FIRE_LIGHT_RED
	max_integrity = 50
	sound_damaged = 'sound/effects/Glasshit.ogg'
	plane = GAME_PLANE_UPPER

/obj/structure/cult/pylon/attack_hand(var/mob/M)
	attackpylon(M, 5)

/*
/obj/structure/cult/pylon/attack_basic_mob(mob/user, list/modifiers)
	. = ..()
	if(istype(user, /mob/living/basic/construct/artificer))
		if(broken)
			repair(user)
			return
	attackpylon(user, user.melee_damage_upper)
*/

/obj/structure/cult/pylon/attackby(var/obj/item/W, var/mob/user)
	attackpylon(user, W.force)

/obj/structure/cult/pylon/proc/attackpylon(mob/user as mob, var/damage)
	if(!broken)
		if(prob(1+ damage * 5))
			to_chat(user, "You hit the pylon, and its crystal breaks apart!")
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashed the pylon!", 1, "You hear a tinkle of crystal shards.", 2)
			playsound(src, 'sound/effects/Glassbr3.ogg', 75, 1)
			broken = TRUE
			density = FALSE
			icon_state = "pylon-broken"
			set_light(0)
		else
			to_chat(user, "You hit the pylon!")
			playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
	else
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		if(prob(damage * 2))
			to_chat(user, "You pulverize what was left of the pylon!")
			qdel(src)
		else
			to_chat(user, "You hit the pylon!")

/obj/structure/cult/pylon/proc/repair(var/mob/user)
	if(broken)
		to_chat(user, "You repair the pylon.")
		broken = FALSE
		density = TRUE
		icon_state = "pylon"
		sound_damaged = 'sound/effects/Glasshit.ogg'
		set_light(5)

/obj/structure/cult/pylon/takeDamage()
	..()
	if(atom_integrity <= 20 && !broken)
		playsound(src, 'sound/effects/Glassbr3.ogg', 75, 1)
		visible_message("<span class='warning'>\The [src] breaks apart!</span>")
		icon_state = "pylon-broken"
		set_light(0)
		density = FALSE
		broken = TRUE

/obj/structure/cult/pylon/New()
	..()
	flick("[icon_state]-spawn", src)
