/datum/leyline_variable/attunement_theme/ice_minor
	name = "Freezing"
	beam_color = COLOR_CARP_LIGHT_BLUE

/datum/leyline_variable/attunement_theme/ice_minor/adjust_attunements(list/datum/attunement/attunements)
	attunements[MAGIC_ELEMENT_ICE] += 0.2

/datum/leyline_variable/attunement_theme/ice
	name = "Frigid"
	beam_color = COLOR_CYAN

/datum/leyline_variable/attunement_theme/ice/adjust_attunements(list/datum/attunement/attunements)
	attunements[MAGIC_ELEMENT_ICE] += 0.5

/datum/leyline_variable/attunement_theme/ice_major
	name = "Absolute Zero"
	beam_color = COLOR_DARK_CYAN

/datum/leyline_variable/attunement_theme/ice_major/adjust_attunements(list/datum/attunement/attunements)
	attunements[MAGIC_ELEMENT_ICE] += 1
