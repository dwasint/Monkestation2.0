/mob/living/basic/slime
	name = "grey baby slime (123)"
	icon = 'monkestation/code/modules/slimecore/icons/slimes.dmi'
	icon_state = "grey baby slime"
	base_icon_state = "grey baby slime"
	icon_dead = "grey baby slime dead"

	maxHealth = 150
	health = 150

	ai_controller = /datum/ai_controller/basic_controller/slime
	density = FALSE

	pass_flags = PASSTABLE | PASSGRILLE
	gender = NEUTER
	faction = list(FACTION_SLIME)

	//emote_see = list("jiggles", "bounces in place")
	speak_emote = list("blorbles")
	bubble_icon = "slime"
	initial_language_holder = /datum/language_holder/slime

	verb_say = "blorbles"
	verb_ask = "inquisitively blorbles"
	verb_exclaim = "loudly blorbles"
	verb_yell = "loudly blorbles"

	// canstun and canknockdown don't affect slimes because they ignore stun and knockdown variables
	// for the sake of cleanliness, though, here they are.
	status_flags = CANUNCONSCIOUS|CANPUSH

	///we track flags for slimes here like ADULT_SLIME, and PASSIVE_SLIME
	var/slime_flags = NONE

	///our current datum for slime color
	var/datum/slime_color/current_color = /datum/slime_color/grey
	///this is our last cached hunger precentage between 0 and 1
	var/hunger_precent = 0
	///how much hunger we need to produce
	var/production_precent = 0.6
	///our list of slime traits
	var/list/slime_traits = list()
	///used to help our name changes so we don't rename named slimes
	var/static/regex/slime_name_regex = new("\\w+ (baby|adult) slime \\(\\d+\\)")
	///our number
	var/number

	///list of all possible mutations
	var/list/possible_color_mutations = list()

	var/list/compiled_liked_foods = list()
	///this is our list of trait foods
	var/list/trait_foods = list()
	///the in progress mutation used for descs
	var/datum/slime_color/mutating_into
	///this is our mutation chance
	var/mutation_chance = 30

	var/obj/item/slime_accessory/worn_accessory

	///this is a list of trees that we replace goes from base = replaced
	var/list/replacement_trees = list()
	///this is our emotion overlay states
	var/list/emotion_states = list(
		EMOTION_HAPPY = "aslime-happy",
		EMOTION_SAD = "aslime-sad",
		EMOTION_ANGER = "aslime-angry",
		EMOTION_FUNNY = "aslime-mischevous",
		EMOTION_SCARED = "aslime-scared",
		EMOTION_SUPRISED = "aslime-happy",
		EMOTION_HUNGRY = "aslime-pout",
	)

/mob/living/basic/slime/Initialize(mapload, datum/slime_color/passed_color)
	. = ..()
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_SLIME, 0.5, -11)
	AddElement(/datum/element/soft_landing)

	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

	if(!passed_color)
		current_color = new current_color
	else
		current_color = new passed_color
	current_color.on_add_to_slime(src)

	AddComponent(/datum/component/liquid_secretion, current_color.secretion_path, 10, 10 SECONDS, TYPE_PROC_REF(/mob/living/basic/slime, check_secretion))
	AddComponent(/datum/component/generic_mob_hunger, 400, 0.1, 5 MINUTES, 200)
	AddComponent(/datum/component/scared_of_item, 5)
	AddComponent(/datum/component/emotion_buffer, emotion_states)

	RegisterSignal(src, COMSIG_HUNGER_UPDATED, PROC_REF(hunger_updated))
	RegisterSignal(src, COMSIG_MOB_OVERATE, PROC_REF(attempt_change))

	for(var/datum/slime_mutation_data/listed as anything in current_color.possible_mutations)
		var/datum/slime_mutation_data/data = new listed
		data.on_add_to_slime(src)
		possible_color_mutations += data
		if(length(data.needed_items))
			compiled_liked_foods |= data.needed_items

	update_slime_varience()
	if(length(compiled_liked_foods))
		recompile_ai_tree()


/mob/living/basic/slime/Destroy()
	. = ..()
	for(var/datum/slime_trait/trait as anything in slime_traits)
		remove_trait(trait)
	UnregisterSignal(src, COMSIG_HUNGER_UPDATED)
	QDEL_NULL(current_color)

/mob/living/basic/slime/proc/rebuild_foods()
	compiled_liked_foods |= trait_foods

/mob/living/basic/slime/proc/recompile_ai_tree()
	var/list/new_planning_subtree = list()
	rebuild_foods()

	RemoveElement(/datum/element/basic_eating)

	if(!HAS_TRAIT(src, TRAIT_SLIME_RABID))
		new_planning_subtree |= add_or_replace_tree(/datum/ai_planning_subtree/simple_find_nearest_target_to_flee_has_item)
		new_planning_subtree |= add_or_replace_tree(/datum/ai_planning_subtree/flee_target)

	if(slime_flags & CLEANER_SLIME)
		new_planning_subtree |= add_or_replace_tree(/datum/ai_planning_subtree/cleaning_subtree)

	if(!(slime_flags & PASSIVE_SLIME))
		new_planning_subtree |= add_or_replace_tree(/datum/ai_planning_subtree/simple_find_target_no_trait/slime)

	if(length(compiled_liked_foods))
		AddElement(/datum/element/basic_eating, food_types = compiled_liked_foods)
		new_planning_subtree |= add_or_replace_tree(/datum/ai_planning_subtree/find_food)
		ai_controller.override_blackboard_key(BB_BASIC_FOODS, compiled_liked_foods) //since list we override

	new_planning_subtree |= add_or_replace_tree(/datum/ai_planning_subtree/basic_melee_attack_subtree/slime)

	ai_controller.replace_planning_subtrees(new_planning_subtree)

/mob/living/basic/slime/proc/add_or_replace_tree(datum/ai_planning_subtree/checker)
	if(checker in replacement_trees)
		return replacement_trees[checker]
	return checker

/mob/living/basic/slime/proc/update_slime_varience()
	if(slime_flags & ADULT_SLIME)
		icon_state = "grey adult slime"
		icon_dead = "grey baby slime dead"
	else
		icon_state = "grey baby slime"
		icon_dead = "grey baby slime dead"

	color = current_color.slime_color

	update_name()
	SEND_SIGNAL(src, COMSIG_SECRETION_UPDATE, current_color.secretion_path, 10, 10 SECONDS)

/mob/living/basic/slime/update_overlays()
	. = ..()
	if(worn_accessory)
		if(slime_flags & ADULT_SLIME)
			.+= mutable_appearance(worn_accessory.accessory_icon, "[worn_accessory.accessory_icon_state]-adult", layer + 0.15, src, appearance_flags = (KEEP_APART | RESET_COLOR))
		else
			.+= mutable_appearance(worn_accessory.accessory_icon, "[worn_accessory.accessory_icon_state]-baby", layer + 0.15, src, appearance_flags = (KEEP_APART | RESET_COLOR))

/mob/living/basic/slime/proc/check_secretion()
	if((!(slime_flags & ADULT_SLIME)) || (slime_flags & STORED_SLIME) || (slime_flags & MUTATING_SLIME))
		return FALSE

	if(hunger_precent < production_precent)
		return FALSE
	return TRUE

/mob/living/basic/slime/proc/hunger_updated(datum/source, current_hunger, max_hunger)
	hunger_precent = current_hunger / max_hunger
	if(hunger_precent > 0.6)
		slime_flags |= ADULT_SLIME
	else
		slime_flags &= ~ADULT_SLIME
	update_slime_varience()
	update_appearance()

/mob/living/basic/slime/proc/add_trait(datum/slime_trait/added_trait)
	var/datum/slime_trait/new_trait = new added_trait
	new_trait.on_add(src)
	slime_traits += new_trait

/mob/living/basic/slime/proc/remove_trait(datum/slime_trait/removed_trait)
	slime_traits -= removed_trait
	qdel(removed_trait)

/mob/living/basic/slime/update_name()
	if(slime_name_regex.Find(name))
		if(!number)
			number = rand(1, 1000)
		name = "[current_color.name] [(slime_flags & ADULT_SLIME) ? "adult" : "baby"] slime ([number])"
		real_name = name
	return ..()

/mob/living/basic/slime/proc/start_split()
	ai_controller.set_ai_status(AI_STATUS_OFF)
	slime_flags |= SPLITTING_SLIME

	visible_message(span_notice("[name] starts to flatten, it looks to be splitting."))

	addtimer(CALLBACK(src, PROC_REF(finish_splitting)), 15 SECONDS)

/mob/living/basic/slime/proc/finish_splitting()
	SEND_SIGNAL(src, COMSIG_MOB_ADJUST_HUNGER, -200)
	update_slime_varience()

	slime_flags &= ~SPLITTING_SLIME
	ai_controller.set_ai_status(AI_STATUS_ON)

	var/mob/living/basic/slime/new_slime = new(loc, current_color.type)

/mob/living/basic/slime/proc/start_mutating()
	if(!pick_mutation())
		return FALSE

	ai_controller.set_ai_status(AI_STATUS_OFF)
	visible_message(span_notice("[name] starts to ungulate, it looks to be mutating."))
	slime_flags |= MUTATING_SLIME

	ungulate()


	addtimer(CALLBACK(src, PROC_REF(finish_mutating)), 30 SECONDS)
	return TRUE

/mob/living/basic/slime/proc/change_color(datum/slime_color/new_color)
	QDEL_NULL(current_color)
	current_color = new_color
	current_color.on_add_to_slime(src)

	update_slime_varience()

	compiled_liked_foods = list()

	QDEL_LIST(possible_color_mutations)
	possible_color_mutations = list()

	for(var/datum/slime_mutation_data/listed as anything in current_color.possible_mutations)
		var/datum/slime_mutation_data/data = new listed
		data.on_add_to_slime(src)
		possible_color_mutations += data
		if(length(data.needed_items))
			compiled_liked_foods |= data.needed_items

	recompile_ai_tree()

/mob/living/basic/slime/proc/finish_mutating()
	SEND_SIGNAL(src, COMSIG_MOB_ADJUST_HUNGER, -200)
	change_color(mutating_into)

	slime_flags &= ~MUTATING_SLIME
	ai_controller.set_ai_status(AI_STATUS_ON)

	animate(src) // empty animate to break ungulating

/mob/living/basic/slime/proc/pick_mutation(random = FALSE)
	var/list/valid_choices = list()
	for(var/datum/slime_mutation_data/listed as anything in possible_color_mutations)
		if(!random && !listed.can_mutate)
			continue
		valid_choices += listed
		valid_choices[listed] = listed.weight
	if(!length(valid_choices))
		return FALSE

	var/datum/slime_mutation_data/picked = pick_weight(valid_choices)
	mutating_into = new picked.output
	return TRUE

/mob/living/basic/slime/proc/attempt_change(datum/source, hunger_precent)
	if(prob(mutation_chance)) // we try to mutate 30% of the time
		if(!start_mutating())
			start_split()
	else
		start_split()

/mob/living/basic/slime/attackby(obj/item/attacking_item, mob/living/user, params)
	. = ..()
	if(!istype(attacking_item, /obj/item/slime_accessory))
		return
	worn_accessory = attacking_item
	attacking_item.forceMove(src)
	update_appearance()

/mob/living/basic/slime/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(worn_accessory)
		visible_message("[user] takes the [worn_accessory] off the [src].")
		worn_accessory = null
		worn_accessory.forceMove(get_turf(user))
		update_appearance()

/mob/living/basic/slime/Life(seconds_per_tick, times_fired)
	if(isopenturf(loc))
		var/turf/open/my_our_turf = loc
		if(my_our_turf.pollution)
			my_our_turf.pollution.touch_act(src)
	. = ..()

/mob/living/basic/slime/rainbow
	current_color = /datum/slime_color/rainbow

/mob/living/basic/slime/random

/mob/living/basic/slime/random/Initialize(mapload, datum/slime_color/passed_color)
	current_color = pick(subtypesof(/datum/slime_color))
	. = ..()

/mob/living/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(HAS_TRAIT(src, VACPACK_THROW))
		REMOVE_TRAIT(src, VACPACK_THROW, "vacpack")
