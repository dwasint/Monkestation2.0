/datum/leyline_variable/attunement_theme/fire_minor
	name = "Smoldering"
	beam_color = COLOR_ORANGE

/datum/leyline_variable/attunement_theme/fire_minor/adjust_attunements(list/datum/attunement/attunements)
	attunements[MAGIC_ELEMENT_FIRE] += 0.2

/datum/leyline_variable/attunement_theme/fire
	name = "Embering"
	beam_color = COLOR_RED_LIGHT

/datum/leyline_variable/attunement_theme/fire/adjust_attunements(list/datum/attunement/attunements)
	attunements[MAGIC_ELEMENT_FIRE] += 0.5

/datum/leyline_variable/attunement_theme/fire_major
	name = "Blazing"
	beam_color = COLOR_RED

/datum/leyline_variable/attunement_theme/fire_major/adjust_attunements(list/datum/attunement/attunements)
	attunements[MAGIC_ELEMENT_FIRE] += 1
