/obj/machinery/assembler
	name = "assembler"
	desc = "Produces a set recipe when given the materials, some say a small cargo technican is stuck inside making these things."

	var/speed_multiplier = 1
	var/datum/crafting_recipe/chosen_recipe
	var/crafting = FALSE

	var/static/list/crafting_recipes = list()
	var/list/crafting_inventory = list()

	icon = 'monkestation/code/modules/factory_type_beat/icons/mining_machines.dmi'
	icon_state = "splitter"


/obj/machinery/assembler/Initialize(mapload)
	. = ..()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	if(!length(crafting_recipes))
		create_recipes()



/obj/machinery/assembler/proc/create_recipes()
	for(var/datum/crafting_recipe/recipe as anything in subtypesof(/datum/crafting_recipe))
		if(initial(recipe.non_craftable) || !initial(recipe.always_available))
			continue
		crafting_recipes += new recipe

/obj/machinery/assembler/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/datum/crafting_recipe/choice = tgui_input_list(user, "Choose a recipe", name, crafting_recipes)
	if(!choice)
		return
	chosen_recipe = choice
	for(var/atom/movable/listed as anything in crafting_inventory)
		listed.forceMove(get_turf(src))
		crafting_inventory -= listed

/obj/machinery/assembler/CanAllowThrough(atom/movable/mover, border_dir)
	if(!anchored)
		return FALSE
	if(!chosen_recipe)
		return FALSE
	if(!(mover.type in chosen_recipe.reqs) || !(mover.type in chosen_recipe.parts))
		return FALSE
	if(!check_item(mover))
		return FALSE
	return ..()

/obj/machinery/assembler/proc/on_entered(datum/source, atom/movable/atom_movable)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(accept_item), atom_movable)

/obj/machinery/assembler/proc/accept_item(atom/movable/atom_movable)
	if(!chosen_recipe)
		return
	if(isstack(atom_movable))
		var/obj/item/stack/stack = atom_movable
		if(!(stack.merge_type in chosen_recipe.reqs))
			return FALSE
	else
		if(!(atom_movable.type in chosen_recipe.reqs))
			return FALSE

	atom_movable.forceMove(src)
	crafting_inventory += atom_movable
	check_recipe_state()


/obj/machinery/assembler/can_drop_off(atom/movable/target)
	if(!check_item(target))
		return FALSE
	return TRUE


/obj/machinery/assembler/proc/check_item(atom/movable/atom_movable)
	if(!chosen_recipe)
		return
	if(isstack(atom_movable))
		var/obj/item/stack/stack = atom_movable
		if(!(stack.merge_type in chosen_recipe.reqs))
			return FALSE

	if((!(atom_movable.type in chosen_recipe.reqs) || !(atom_movable.type in chosen_recipe.parts)) && !isstack(atom_movable))
		return FALSE

	var/list/reqs = chosen_recipe.reqs.Copy()
	for(var/atom/movable/listed in reqs)
		reqs[listed] *= 10 // we can queue 10 crafts of everything

	for(var/atom/movable/item in crafting_inventory)
		if(isstack(item))
			var/obj/item/stack/stack = item
			if(item in reqs)
				reqs[item.type] -= stack.amount
				if(reqs[item.type] <= 0)
					reqs -= item.type
		else
			if(item in reqs)
				reqs[item.type]--
				if(reqs[item.type] <= 0)
					reqs -= item.type
	if(!length(reqs))
		return FALSE

	if((atom_movable.type in reqs))
		return TRUE
	if(isstack(atom_movable))
		var/obj/item/stack/stack = atom_movable
		if((stack.merge_type in reqs))
			return TRUE

	return FALSE


/obj/machinery/assembler/proc/check_recipe_state()
	var/list/reqs = chosen_recipe.reqs.Copy()

	for(var/atom/movable/item in crafting_inventory)
		if(isstack(item))
			var/obj/item/stack/stack = item
			if(stack.merge_type in reqs)
				reqs[stack.merge_type] -= stack.amount
				if(reqs[stack.merge_type] <= 0)
					reqs -= stack.merge_type
		else
			if(item.type in reqs)
				reqs[item.type]--
				if(reqs[item.type] <= 0)
					reqs -= item.type
	if(!length(reqs))
		start_craft()

/obj/machinery/assembler/proc/start_craft()
	if(crafting)
		return
	crafting = TRUE

	if(!machine_do_after_visable(src, chosen_recipe.time * speed_multiplier * 3))
		return

	var/list/requirements = chosen_recipe.reqs
	var/list/Deletion = list()
	var/list/stored_parts = list()
	var/data
	var/amt
	main_loop:
		for(var/path_key in requirements)
			amt = chosen_recipe.reqs?[path_key]
			if(!amt)//since machinery & structures can have 0 aka CRAFTING_MACHINERY_USE - i.e. use it, don't consume it!
				continue main_loop
			if(ispath(path_key, /obj/item/stack))
				var/obj/item/stack/S
				var/obj/item/stack/SD
				while(amt > 0)
					S = locate(path_key) in crafting_inventory
					if(S.amount >= amt)
						if(!locate(S.type) in Deletion)
							SD = new S.type()
							Deletion += SD
						S.use(amt)
						SD = locate(S.type) in Deletion
						SD.amount += amt
						continue main_loop
					else
						amt -= S.amount
						if(!locate(S.type) in Deletion)
							Deletion += S
						else
							data = S.amount
							S = locate(S.type) in Deletion
							S.add(data)
						crafting_inventory -= S
			else
				var/atom/movable/I
				while(amt > 0)
					I = locate(path_key) in crafting_inventory
					Deletion += I
					crafting_inventory -= I
					amt--
	var/list/partlist = list(chosen_recipe.parts.len)
	for(var/M in chosen_recipe.parts)
		partlist[M] = chosen_recipe.parts[M]
	for(var/part in chosen_recipe.parts)
		if(isstack(part))
			var/obj/item/stack/ST = locate(part) in Deletion
			if(ST.amount > partlist[part])
				ST.amount = partlist[part]
			stored_parts += ST
			Deletion -= ST
			continue
		else
			while(partlist[part] > 0)
				var/atom/movable/AM = locate(part) in Deletion
				stored_parts += AM
				Deletion -= AM
				partlist[part] -= 1
	while(Deletion.len)
		var/DL = Deletion[Deletion.len]
		Deletion.Cut(Deletion.len)
		if(istype(DL, /obj/item/storage))
			var/obj/item/storage/container = DL
			container.emptyStorage()
		else if(isstructure(DL))
			var/obj/structure/structure = DL
			structure.dump_contents(structure.drop_location())
		qdel(DL)

	var/atom/movable/I
	if(ispath(chosen_recipe.result, /obj/item/stack))
		I = new chosen_recipe.result (src, chosen_recipe.result_amount || 1)
	else
		I = new chosen_recipe.result (src)
		if(I.atom_storage && chosen_recipe.delete_contents)
			for(var/obj/item/thing in I)
				qdel(thing)
	I.CheckParts(stored_parts, chosen_recipe)

	I.forceMove(get_turf(src))
	crafting = FALSE
	check_recipe_state()
