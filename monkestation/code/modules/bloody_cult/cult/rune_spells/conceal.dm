
/datum/rune_spell/conceal
	name = "Conceal"
	desc = "Hide runes and cult structures. Some runes can still be used when concealed, but using them might reveal them."
	desc_talisman = "Hide runes and cult structures. Covers a smaller range than when used from a rune."
	invocation = "Kla'atu barada nikt'o!"
	word1 = /datum/rune_word/hide
	word2 = /datum/rune_word/see
	word3 = /datum/rune_word/blood
	page = "This rune allows you to hide every rune and structures in a circular 7 tile range around it. You cannot hide a rune or structure that got revealed less than 10 seconds ago. Affects through walls.\
		<br><br>The talisman version has a 5 tile radius."
	var/rune_effect_range=7
	var/talisman_effect_range=5

/datum/rune_spell/conceal/cast(var/effect_range = rune_effect_range,var/size='monkestation/code/modules/bloody_cult/icons/480x480.dmi')
	var/turf/T = get_turf(spell_holder)
	var/obj/effect/abstract/animation = anim(target = T, a_icon = size, a_icon_state = "rune_conceal", offX = -32*effect_range, offY = -32*effect_range, plane = ABOVE_LIGHTING_PLANE)
	animation.alpha = 0
	animate(animation, alpha = 255, time = 2)
	animate(alpha = 0, time = 3)
	to_chat(activator, "<span class='notice'>All runes and cult structures in range hide themselves behind a thin layer of reality.</span>")
	playsound(T, 'monkestation/code/modules/bloody_cult/sound/conceal.ogg', 50, 0, -5)
	var/datum/antagonist/cult/C = activator.mind.has_antag_datum(/datum/antagonist/cult)

	for(var/obj/structure/cult/S in range(effect_range,T))
		var/dist = cheap_pythag(S.x - T.x, S.y - T.y)
		if (S.conceal_cooldown)
			continue
		if (dist <= effect_range+0.5)
			S.conceal()
			C.gain_devotion(10, DEVOTION_TIER_0, "conceal_structure", S)

	for(var/obj/effect/new_rune/R in range(effect_range,T))
		if (R == spell_holder)
			continue
		if (R.conceal_cooldown)
			continue
		var/dist = cheap_pythag(R.x - T.x, R.y - T.y)
		if (dist <= effect_range+0.5)
			R.conceal()
			C.gain_devotion(10, DEVOTION_TIER_0, "conceal_rune", R)
			var/obj/effect/abstract/trail = shadow(R,T,"rune_conceal")
			trail.alpha = 0
			animate(trail, alpha = 200, time = 2)
			animate(alpha = 0, time = 3)
	qdel(spell_holder)

/datum/rune_spell/conceal/cast_talisman()
	cast(talisman_effect_range,'monkestation/code/modules/bloody_cult/icons/352x352.dmi')
