/obj/effect/decal/cleanable/ritual
	name = "chalk ritual"
	icon = 'monkestation/code/modules/magic/icons/3x3_rituals.dmi'
	icon_state = "base_rune"

	pixel_x = -32
	pixel_y = -32

	var/list/leylines = list()
	var/list/lesser_sigils = list()
	var/list/greater_sigils = list()

	var/turf/center_turf

	///this rune dictates what happens
	var/obj/effect/decal/cleanable/rune/center_rune
	var/mob/living/caster
	//if we are focusing the ritual on a crystal we aren't the center.
	var/atom/centerpiece
	///our total amplification for existing
	var/total_amplification = 1
	///our leyline bonus after accounting for greater sigils
	var/leyline_amplification = 1

	var/ritual_base = "Light"

/obj/effect/decal/cleanable/ritual/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	var/turf/stepper = get_step(get_turf(src), NORTH)
	center_turf = get_step(stepper, EAST)

/obj/effect/decal/cleanable/ritual/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "base_rune_emissive", src)
