/datum/console_command/spawn
	command_key = "spawn"
	required_args = 1

/datum/console_command/spawn/help_information(obj/abstract/visual_ui_element/scrollable/console_output/output)
	output.add_line("spawn {PATH or partial path} - spawns a mob at your feet")

/datum/console_command/spawn/execute(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	var/mob/user = output.get_user()
	var/datum/admins/admin = user.client.holder
	if(!admin)
		output.add_line("ERROR: Lacks Permission")
		return
	var/name = spawn_atom_to_turf(get_turf(user), arg_list[1])
	output.add_line("Successfully spawned [name] at feet")

/datum/admins/proc/spawn_atom(object as text)
	set category = "Debug"
	set desc = ""
	set name = "Spawn"

	if(!check_rights(R_SPAWN) || !object)
		return

	var/list/preparsed = splittext(object,":")
	var/path = preparsed[1]
	var/amount = 1
	if(preparsed.len > 1)
		amount = CLAMP(text2num(preparsed[2]),1,ADMIN_SPAWN_CAP)

	var/atom/chosen = pick_closest_path(path)
	if(!chosen)
		return
	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		for(var/i in 1 to amount)
			var/atom/A = new chosen(T)
			A.flags_1 |= ADMIN_SPAWNED_1

	log_admin("[key_name(usr)] spawned [amount] x [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return initial(chosen.name)
