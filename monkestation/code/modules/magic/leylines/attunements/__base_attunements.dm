// works differently than others - uses prob(), so treat this stuff as percents
GLOBAL_LIST_INIT(leyline_attunement_themes, list(
	/datum/leyline_variable/attunement_theme/fire_minor = 50,
	/datum/leyline_variable/attunement_theme/fire = 25,
	/datum/leyline_variable/attunement_theme/fire_major = 10,

	/datum/leyline_variable/attunement_theme/ice_minor = 50,
	/datum/leyline_variable/attunement_theme/ice = 25,
	/datum/leyline_variable/attunement_theme/ice_major = 10,
))

/proc/get_random_attunement_themes()
	RETURN_TYPE(/list/datum/leyline_variable/attunement_theme)

	var/list/datum/leyline_variable/attunement_theme/themes = list()

	for (var/datum/leyline_variable/attunement_theme/theme as anything in GLOB.leyline_attunement_themes)
		if (prob(GLOB.leyline_attunement_themes[theme]))
			themes += new theme

	return pick(themes)

/// For each entry in GLOB.[leyline_attunement_themes], prob() is ran, and if it succeeds, it adjusts the leyline attunement by [adjust_attunements]
/datum/leyline_variable/attunement_theme
	var/beam_color = COLOR_WHITE

/datum/leyline_variable/attunement_theme/proc/adjust_attunements(list/datum/attunement/attunements)
	return

