
/datum/rune_spell/deafmute
	name = "Deaf-Mute"
	desc = "Deafen nearby enemies. Including robots."
	desc_talisman = "Deafen nearby enemies. Including robots. The effect is shorter than when used from a rune."
	invocation = "Sti' kaliedir!"
	word1 = /datum/rune_word/hide
	word2 = /datum/rune_word/other
	word3 = /datum/rune_word/see
	page = "This rune causes every non-cultist (both humans and robots) in a 7 tile radius to be unable to hear for 50 seconds. \
		The durations are halved when cast from a talisman, unless you slap someone directly with one, which will also limits the effects to them.\
		<br><br>This rune is great to sow disorder and delay the arrival of security, and can potentially combo with a Stun talisman used on an area. The only downside is that you can't hear them scream while they are muted."
	var/deaf_rune_duration= 50 SECONDS//times are in seconds
	var/deaf_talisman_duration=30 SECONDS
	var/mute_rune_duration=25 SECONDS
	var/mute_talisman_duration=15 SECONDS
	var/effect_range=7
	touch_cast = 1

/datum/rune_spell/deafmute/cast_touch(var/mob/living/M)
	invoke(activator,invocation,1)

	var/deaf_duration = deaf_rune_duration
	var/mute_duration = mute_rune_duration
	addtimer(CALLBACK(src, PROC_REF(remove_deaf), M), deaf_duration)
	addtimer(CALLBACK(src, PROC_REF(remove_mute), M), mute_duration)
	ADD_TRAIT(M, TRAIT_MUTE, "rune")
	ADD_TRAIT(M, TRAIT_DEAF, "rune")
	var/datum/antagonist/cult/C = activator.mind.has_antag_datum(/datum/antagonist/cult)
	if (!IS_CULTIST(M) && M.mind && M.stat != DEAD)
		C.gain_devotion(50, DEVOTION_TIER_2, "deafmute_papered", M)
	M.overlay_fullscreen("deafborder", /atom/movable/screen/fullscreen/deafmute_border)//victims see a red overlay fade in-out for a second
	M.update_fullscreen_alpha("deafborder", 100, 5)
	var/obj/item/organ/internal/ears/ears = M.get_organ_slot(ORGAN_SLOT_EARS)
	ears?.adjustEarDamage(0, deaf_duration)
	if (!(HAS_TRAIT(M, TRAIT_DEAF)))
		to_chat(M,"<span class='notice'>The world around you suddenly becomes quiet.</span>")
	if (!(HAS_TRAIT(M, TRAIT_MUTE)))
		if (iscarbon(M))
			to_chat(M,"<span class='warning'>You feel a terrible chill! You find yourself unable to speak a word...</span>")
		else if (issilicon(M))
			to_chat(M,"<span class='warning'>A shortcut appears to have temporarily disabled your speaker!</span>")
	spawn(8)
		M.update_fullscreen_alpha("deafborder", 0, 5)
		sleep(8)
		M.clear_fullscreen("deafborder", animated = FALSE)

	qdel(src)

/datum/rune_spell/deafmute/cast(var/deaf_duration = deaf_rune_duration, var/mute_duration = mute_rune_duration)
	for(var/mob/living/M in range(effect_range,get_turf(spell_holder)))
		if (IS_CULTIST(M))
			continue
		var/datum/antagonist/cult/C = activator.mind.has_antag_datum(/datum/antagonist/cult)
		if (M.stat != DEAD)
			C.gain_devotion(50, DEVOTION_TIER_2, "deafmute", M)
		M.overlay_fullscreen("deafborder", /atom/movable/screen/fullscreen/deafmute_border)//victims see a red overlay fade in-out for a second
		M.update_fullscreen_alpha("deafborder", 100, 5)
		addtimer(CALLBACK(src, PROC_REF(remove_deaf), M), deaf_duration)
		addtimer(CALLBACK(src, PROC_REF(remove_mute), M), mute_duration)
		ADD_TRAIT(M, TRAIT_MUTE, "rune")
		ADD_TRAIT(M, TRAIT_DEAF, "rune")
		var/obj/item/organ/internal/ears/ears = M.get_organ_slot(ORGAN_SLOT_EARS)
		ears?.adjustEarDamage(0, deaf_duration)
		if (!(HAS_TRAIT(M, TRAIT_DEAF)))
			to_chat(M,"<span class='notice'>The world around you suddenly becomes quiet.</span>")
		if (!(HAS_TRAIT(M, TRAIT_MUTE)))
			if (iscarbon(M))
				to_chat(M,"<span class='warning'>You feel a terrible chill! You find yourself unable to speak a word...</span>")
			else if (issilicon(M))
				to_chat(M,"<span class='warning'>A shortcut appears to have temporarily disabled your speaker!</span>")
		spawn(8)
			M.update_fullscreen_alpha("deafborder", 0, 5)
			sleep(8)
			M.clear_fullscreen("deafborder", animated = FALSE)
	qdel(spell_holder)

/datum/rune_spell/deafmute/cast_talisman()
	cast(deaf_talisman_duration, mute_talisman_duration)

/datum/rune_spell/deafmute/proc/remove_deaf(mob/remover)
	REMOVE_TRAIT(remover, TRAIT_DEAF, "rune")

/datum/rune_spell/deafmute/proc/remove_mute(mob/remover)
	REMOVE_TRAIT(remover, TRAIT_MUTE, "rune")
