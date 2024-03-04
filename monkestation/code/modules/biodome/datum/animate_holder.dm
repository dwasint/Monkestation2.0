/atom
	var/datum/animate_holder/animate_holder


///this currently only supports a single animation set
/datum/animate_holder
	var/atom/parent
	///this is a pretty compicated situation where its a list of lists that follow the vars needed for animates
	var/list/steps = list()
	///this only exists for ui reasons its basically steps but its a list of all the easing levels and if they are true
	var/list/easings = list()

/datum/animate_holder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AnimateHolder")
		ui.open()
	ui.set_autoupdate(TRUE)

/datum/animate_holder/ui_state(mob/user)
	return GLOB.always_state

/datum/animate_holder/ui_data(mob/user)
	var/list/data = list()
	data["steps"] = steps
	data["easings"] = easings

	return data

/datum/animate_holder/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("modify_step")
			var/list/changes = list()
			changes += params["variable"]
			changes[params["variable"]] = params["value"]
			modify_index_value(params["index"], changes)
			. = TRUE

		if("add_blank_step")
			add_blank_step()
			. = TRUE

		if("remove_step")
			remove_step(params["index"])
			. = TRUE

		if("modify_easing")
			update_easing_step(params["index"], params["flag"], params["value"])
			. = TRUE

/datum/animate_holder/New(atom/creator)
	parent = creator

/datum/animate_holder/Destroy(force, ...)
	. = ..()
	steps.Cut(1)
	easings.Cut(1)
	reanimate()

	parent = null


/datum/animate_holder/proc/reanimate()
	var/first_item = TRUE
	for(var/list/held_list as anything in steps)
		if(!length(held_list))
			animate(parent)
			continue

		if(first_item)
			animate(arglist(list(parent) + held_list))
			first_item = FALSE
		else
			if(held_list["flags"] ==  ANIMATION_PARALLEL)
				animate(arglist(list(parent) + held_list))
			else
				animate(arglist(held_list))

/datum/animate_holder/proc/add_animation_step(list/addition)
	steps += list(addition)
	adjust_easing_list(addition, length(steps))
	reanimate()

/datum/animate_holder/proc/update_easing_step(index  = 1, easing_flag, value)
	if(!steps[index] || !easings[index])
		return
	easings[index][easing_flag] = value
	convert_easing_list(index)

/datum/animate_holder/proc/convert_easing_list(index = 1)
	var/list/easing = easings[index]

	var/ending_easing_value = NONE

	if(easing["LINEAR_EASING"])
		ending_easing_value |= LINEAR_EASING
	if(easing["SINE_EASING"])
		ending_easing_value |= SINE_EASING
	if(easing["CIRCULAR_EASING"])
		ending_easing_value |= CIRCULAR_EASING
	if(easing["QUAD_EASING"])
		ending_easing_value |= QUAD_EASING
	if(easing["CUBIC_EASING"])
		ending_easing_value |= CUBIC_EASING
	if(easing["BOUNCE_EASING"])
		ending_easing_value |= BOUNCE_EASING
	if(easing["ELASTIC_EASING"])
		ending_easing_value |= ELASTIC_EASING
	if(easing["BACK_EASING"])
		ending_easing_value |= BACK_EASING
	if(easing["JUMP_EASING"])
		ending_easing_value |= JUMP_EASING

	if(!steps[index]["easing"])
		steps[index] |= "easing"

	steps[index]["easing"] = ending_easing_value
	reanimate()

/datum/animate_holder/proc/adjust_easing_list(list/addition, index = 1)
	var/list/easing = list(
		"LINEAR_EASING" = FALSE,
		"SINE_EASING" = FALSE,
		"CIRCULAR_EASING" = FALSE,
		"QUAD_EASING" = FALSE,
		"CUBIC_EASING" = FALSE,
		"BOUNCE_EASING" = FALSE,
		"ELASTIC_EASING" = FALSE,
		"BACK_EASING" = FALSE,
		"JUMP_EASING" = FALSE,
	)

	if(addition["easing"])
		var/easing_value = addition["easing"]

		if(easing_value & LINEAR_EASING)
			easing["LINEAR_EASING"] = TRUE
		if(easing_value & SINE_EASING)
			easing["SINE_EASING"] = TRUE
		if(easing_value & CIRCULAR_EASING)
			easing["CIRCULAR_EASING"] = TRUE
		if(easing_value & QUAD_EASING)
			easing["QUAD_EASING"] = TRUE
		if(easing_value & CUBIC_EASING)
			easing["CUBIC_EASING"] = TRUE
		if(easing_value & BOUNCE_EASING)
			easing["BOUNCE_EASING"] = TRUE
		if(easing_value & ELASTIC_EASING)
			easing["ELASTIC_EASING"] = TRUE
		if(easing_value & BACK_EASING)
			easing["BACK_EASING"] = TRUE
		if(easing_value & JUMP_EASING)
			easing["JUMP_EASING"] = TRUE
	easings += list(easing)

/datum/animate_holder/proc/remove_step(index = 1)
	if(!steps[index])
		return // this is modify not add
	steps.Cut(index, index+1)
	easings.Cut(index, index+1)
	reanimate()

/datum/animate_holder/proc/modify_specific_list(index = 1, list/new_list)
	if(!steps[index])
		return // this is modify not add
	steps[index] = new_list
	reanimate()

/datum/animate_holder/proc/modify_index_value(index = 1, list/change)
	if(!steps[index])
		return // this is modify not add

	for(var/item in change)
		if(!(item in steps[item]))
			steps[index] |= item
		steps[index][item] = change[item]

	reanimate()

/datum/animate_holder/proc/add_blank_step()
	easings += list(list(
		"LINEAR_EASING" = FALSE,
		"SINE_EASING" = FALSE,
		"CIRCULAR_EASING" = FALSE,
		"QUAD_EASING" = FALSE,
		"CUBIC_EASING" = FALSE,
		"BOUNCE_EASING" = FALSE,
		"ELASTIC_EASING" = FALSE,
		"BACK_EASING" = FALSE,
		"JUMP_EASING" = FALSE,
	))

	steps += list(list())

/datum/animate_holder/proc/return_list_strippped_nulls(list/new_list)
	//not a complete list but all that I can see being used atm
	var/list/base_list = list(
		"time" = null,
		"loop" = null,
		"easing" = null,
		"flags" = null,
		"alpha" = null,
		"color" = null,
		"infra_luminosity" = null,
		"layer" = null,
		"maptext_width" = null,
		"maptext_height" = null,
		"maptext_x" = null,
		"maptext_y" = null,
		"luminosity" = null,
		"pixel_x" = null,
		"pixel_y" = null,
		"pixel_w" = null,
		"pixel_z" = null,
		"transform" = null,
		"dir" = null,
		"maptext" = null,
	)
	for(var/index in new_list)
		if(index in base_list)
			base_list[index] = new_list[index]

	for(var/item in base_list)
		if(base_list[item] == null)
			base_list.Cut(item)

	return base_list
