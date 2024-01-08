/datum/action/cooldown/spell/pointed/illusion
	name = "Illusion"
	desc = "Summon an illusion at the target location. Less effective in dark areas."
	button_icon = 'monkestation/code/modules/magic/icons/actions_cantrips.dmi'
	button_icon_state = "illusion"
	sound = 'sound/effects/magic.ogg'

	cooldown_time = 2 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	school = SCHOOL_CONJURATION

	active_msg = "You prepare to summon an illusion."
	deactive_msg = "You stop preparing to summon an illusion."
	aim_assist = FALSE
	cast_range = 20 // For camera memes

	/// Duration of the illusionary mob
	var/conjured_duration = 8 SECONDS
	/// HP of the illusionary mob
	var/conjured_hp = 10

	var/illusion_cost = 25
	var/illusion_attunement = 0.5

/datum/action/cooldown/spell/pointed/illusion/New(Target)
	. = ..()
	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_LIGHT] += illusion_attunement

	AddComponent(/datum/component/uses_mana,\
		pre_use_check_with_feedback_comsig = COMSIG_SPELL_BEFORE_CAST, \
		post_use_comsig = COMSIG_SPELL_AFTER_CAST, \
		mana_consumed = illusion_cost,\
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)),\
		attunements = attunements,\
	)

/datum/action/cooldown/spell/pointed/illusion/is_valid_target(atom/cast_on)
	var/turf/castturf = get_turf(cast_on)
	return isopenturf(castturf) && !isgroundlessturf(castturf)

/datum/action/cooldown/spell/pointed/illusion/cast(atom/cast_on)
	. = ..()
	var/turf/castturf = get_turf(cast_on)
	var/mob/copy_target = select_copy_target()
	var/mob/living/simple_animal/hostile/illusion/conjured/decoy = new(castturf)
	if(!isnull(copy_target))
		decoy.Copy_Parent(copy_target, conjured_duration, conjured_hp)
		decoy.face_atom(usr || owner || copy_target)

	decoy.spin(0.4 SECONDS, 0.1 SECONDS)
	// alpha is based on how bright the turf is. Darker = weaker illusion
	decoy.alpha = 0
	animate(decoy, alpha = clamp(255 * castturf.get_lumcount(), 75, 225), time = 0.2 SECONDS)

	// with a snap of course
	owner?.emote("snap")
	owner?.face_atom(castturf)

/// Determines what mob to copy for the illusion
/datum/action/cooldown/spell/pointed/illusion/proc/select_copy_target()
	RETURN_TYPE(/mob)
	return owner

// Illusion subtype for summon illusion
/mob/living/simple_animal/hostile/illusion/conjured
	desc = "An illusion! What are you hiding..?"
	AIStatus = AI_OFF
	density = FALSE
	melee_damage_lower = 0
	melee_damage_upper = 0
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	move_force = INFINITY
	move_resist = INFINITY
	pull_force = INFINITY
	sentience_type = SENTIENCE_BOSS
	// I wanted to make these illusion react to emotes (wave to wave, frown to swears, etc) but maybe later
