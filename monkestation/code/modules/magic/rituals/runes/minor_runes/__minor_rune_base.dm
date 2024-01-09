/obj/effect/decal/cleanable/minor_rune
	name = ""
	icon = 'monkestation/code/modules/magic/icons/3x3_rituals.dmi'


/obj/effect/decal/cleanable/minor_rune/update_appearance(updates)
	. = ..()
	. += emissive_appearance(icon, icon_state, src)

/obj/effect/decal/cleanable/minor_rune/proc/process_effect(obj/effect/decal/cleanable/ritual/ritual)
	SHOULD_CALL_PARENT(FALSE)
	return
