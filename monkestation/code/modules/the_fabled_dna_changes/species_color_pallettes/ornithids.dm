/datum/color_palette/ornithids
	default_color = COLOR_AMETHYST

	var/feather_main
	var/feather_secondary
	var/feather_tri

/datum/color_palette/ornithids/apply_prefs(datum/preferences/incoming)
	feather_main = incoming.read_preference(/datum/preference/color/feather_color)
	feather_secondary = incoming.read_preference(/datum/preference/color/feather_color_secondary)
