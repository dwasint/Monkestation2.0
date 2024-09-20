/datum/color_palette/generic_colors
	var/hair_color
	var/facial_hair_color

	var/hair_gradient_color
	var/facial_hair_gradient_color

	//this is temporary until we move everything over to per species coloring
	var/mutant_color
	var/mutant_color_secondary
	var/fur_color

/datum/color_palette/generic_colors/apply_prefs(datum/preferences/incoming)
	hair_color = incoming.read_preference(/datum/preference/color/hair_color)
	facial_hair_color = incoming.read_preference(/datum/preference/color/facial_hair_color)

	facial_hair_gradient_color = incoming.read_preference(/datum/preference/color/facial_hair_gradient)
	hair_gradient_color = incoming.read_preference(/datum/preference/color/hair_gradient)

	mutant_color = incoming.read_preference(/datum/preference/color/mutant_color)
	mutant_color_secondary = incoming.read_preference(/datum/preference/color/mutant_color_secondary)

	fur_color = incoming.read_preference(/datum/preference/color/fur_color)
