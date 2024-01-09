/obj/effect/decal/cleanable/rune
	icon = 'monkestation/code/modules/magic/icons/3x3_rituals.dmi'
	desc = "Rune drawn with magic chalk."
	pixel_x = -32
	pixel_y = -32
	var/chalk_name

	var/attunement = MAGIC_ELEMENT_LIGHT

/obj/effect/decal/cleanable/rune/update_overlays()
	. = ..()
	. += emissive_appearance(icon, icon_state, src)

/obj/effect/decal/cleanable/rune/life
	name = "sigil of life"
	chalk_name = "Life"

	icon_state = "greater_sigil_life"
	attunement = MAGIC_ELEMENT_LIFE
	color = COLOR_LIME

/obj/effect/decal/cleanable/rune/ice
	name = "sigil of ice"
	chalk_name = "Ice"

	icon_state = "greater_sigil_ice"
	attunement = MAGIC_ELEMENT_ICE
	color = COLOR_CYAN

/obj/effect/decal/cleanable/rune/fire
	name = "sigil of fire"
	chalk_name = "Fire"

	icon_state = "greater_sigil_fire"
	attunement = MAGIC_ELEMENT_FIRE
	color = COLOR_ORANGE

/obj/effect/decal/cleanable/rune/electric
	name = "sigil of electricity"
	chalk_name = "Electricity"

	icon_state = "greater_sigil_electric"
	attunement = MAGIC_ELEMENT_ELECTRIC
	color = COLOR_PURPLE

/obj/effect/decal/cleanable/rune/earth
	name = "sigil of earth"
	chalk_name = "Earth"

	icon_state = "greater_sigil_earth"
	attunement = MAGIC_ELEMENT_EARTH
	color = COLOR_GREEN

/obj/effect/decal/cleanable/rune/water
	name = "sigil of water"
	chalk_name = "Water"

	icon_state = "greater_sigil_water"
	attunement = MAGIC_ELEMENT_WATER
	color = COLOR_BLUE

/obj/effect/decal/cleanable/rune/air
	name = "sigil of air"
	chalk_name = "Air"

	icon_state = "greater_sigil_air"
	attunement = MAGIC_ELEMENT_WIND
	color = COLOR_YELLOW

/obj/effect/decal/cleanable/rune/light
	name = "sigil of light"
	chalk_name = "Light"

	icon_state = "greater_sigil_light"
	attunement = MAGIC_ELEMENT_LIGHT
	color = COLOR_WHITE

/obj/effect/decal/cleanable/rune/dark
	name = "sigil of dark"
	chalk_name = "Darkness"

	icon_state = "greater_sigil_dark"
	attunement = MAGIC_ELEMENT_DARKNESS
	color = COLOR_BLACK

/obj/effect/decal/cleanable/rune/blood
	name = "sigil of blood"
	chalk_name = "Blood"

	icon_state = "greater_sigil_blood"
	attunement = MAGIC_ELEMENT_BLOOD
	color = COLOR_DARK_RED

/obj/effect/decal/cleanable/rune/time
	name = "sigil of time"
	chalk_name = "Time"

	icon_state = "greater_sigil_time"
	attunement = MAGIC_ELEMENT_TIME
	color = LIGHT_COLOR_LIGHT_CYAN

/obj/effect/decal/cleanable/rune/death
	name = "sigil of death"
	chalk_name = "Death"

	icon_state = "greater_sigil_death"
	attunement = MAGIC_ELEMENT_DEATH
	color = COLOR_BLACK
