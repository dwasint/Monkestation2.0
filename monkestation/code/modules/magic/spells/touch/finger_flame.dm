
/datum/component/uses_mana/touch/finger_flame/can_activate_with_feedback(datum/action/cooldown/spell/touch/finger_flame/source, atom/cast_on)
	if(source.attached_hand)
		return FALSE
	return ..()

// All this spell does is give you a lighter on demand.
/datum/action/cooldown/spell/touch/finger_flame
	name = "Finger Flame"
	desc = "With a snap, conjures a low flame at the tip of your fingers - just enough to light a cigarette."
	button_icon = 'monkestation/code/modules/magic/icons/actions_cantrips.dmi'
	button_icon_state = "spark"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED
	school = SCHOOL_CONJURATION // can also be SCHOOL_EVOCATION
	cooldown_time = 2 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	hand_path = /obj/item/lighter/finger
	draw_message = null
	drop_message = null
	can_cast_on_self = TRUE // self burn

	var/flame_cost = 5 // very cheap, it's just a lighter
	var/flame_attunement = 0.2 // flame users make this EVEN cheaper

	// I was considering giving this the same "trigger on snap emote" effect that the arm implant has,
	// but considering this has a tangible cost (mana) while the arm implant is free, I decided against it.

/datum/action/cooldown/spell/touch/finger_flame/New(Target, original)
	. = ..()
	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_FIRE] += flame_attunement

	AddComponent(/datum/component/uses_mana/touch/finger_flame,\
		pre_use_check_comsig = COMSIG_SPELL_BEFORE_CAST,\
		pre_use_check_with_feedback_comsig = COMSIG_SPELL_AFTER_CAST,\
		mana_consumed = flame_cost,\
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)),\
		attunements = attunements,\
	)


/datum/action/cooldown/spell/touch/finger_flame/can_cast_spell(feedback)
	return ..() && !HAS_TRAIT(owner, TRAIT_EMOTEMUTE) // checked as if it were an emote invocation spell

/datum/action/cooldown/spell/touch/finger_flame/is_valid_target(atom/cast_on)
	return ismovable(cast_on)

/datum/action/cooldown/spell/touch/finger_flame/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	return TRUE // essentially, if we touch something with the flame it goes away.

/datum/action/cooldown/spell/touch/finger_flame/create_hand(mob/living/carbon/cast_on)
	cast_on.emote("snap")
	cast_on.visible_message(
		span_rose("With a snap, <b>[cast_on]</b> conjures a flickering flame at the tip of [cast_on.p_their()] finger."),
		span_rose("With a snap, you conjure a flickering flame at the tip of your finger."),
	)
	. = ..()
	if(!.)
		return
	var/obj/item/lighter/finger/lighter = attached_hand
	lighter.name = "finger flame"
	lighter.set_lit(TRUE)

/datum/action/cooldown/spell/touch/finger_flame/remove_hand(mob/living/hand_owner, reset_cooldown_after)
	if(QDELETED(src) || QDELETED(hand_owner))
		return ..()

	var/obj/item/lighter/finger/lighter = attached_hand
	lighter.set_lit(FALSE) // not strictly necessary as we qdel, but for the sound fx
	if(reset_cooldown_after)
		hand_owner.emote("snap")
		hand_owner.visible_message(
			span_rose("<b>[hand_owner]</b> dispels the flame with another snap."),
			span_rose("You dispel the flame with another snap."),
		)
	return ..()

/obj/item/lighter/finger
	name = "finger light"
	desc = "Fire at your fingertips!"
	inhand_icon_state = "nothing"
	item_flags = EXAMINE_SKIP | ABSTRACT

/obj/item/lighter/finger/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		playsound(user, pick('sound/misc/fingersnap1.ogg', 'sound/misc/fingersnap2.ogg'), 50, TRUE)
		return span_infoplain(span_rose(
			"With a snap, [user]'s finger emits a low flame, which they use to light [A] ablaze. \
			Hot damn, [user.p_theyre()] badass."))

/obj/item/lighter/finger/attack_self(mob/living/user)
	return
