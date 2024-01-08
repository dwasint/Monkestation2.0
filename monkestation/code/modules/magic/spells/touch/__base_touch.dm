#define COMSIG_SPELL_TOUCH_CAN_HIT "spell_touch_can_hit"

/**
 * A preset component for touch spells that use mana
 *
 * These spells require mana to activate (channel into your hand)
 * but does not expend mana until you actually touch someone with it.
 */
/datum/component/uses_mana/touch
	can_transfer = FALSE

/datum/component/uses_mana/touch/Initialize(...)
	if (!istype(parent, /datum/action/cooldown/spell/touch))
		return COMPONENT_INCOMPATIBLE

	return ..()

/datum/component/uses_mana/touch/proc/can_touch(
	datum/action/cooldown/spell/touch/source,
	atom/victim,
	mob/living/carbon/caster,
)
	SIGNAL_HANDLER

	if(source.attached_hand)
		return NONE // de-activating, so don't block it

	return can_activate_with_feedback(caster, victim)

/datum/component/uses_mana/touch/proc/handle_touch(
	datum/action/cooldown/spell/touch/source,
	atom/victim,
	mob/living/carbon/caster,
	obj/item/melee/touch_attack/hand,
)
	SIGNAL_HANDLER

	react_to_successful_use(source, victim)

// Override to send a signal we can react to
/datum/action/cooldown/spell/touch/can_hit_with_hand(atom/victim, mob/caster)
	. = ..()
	if(!.)
		return

	if(SEND_SIGNAL(src, COMSIG_SPELL_TOUCH_CAN_HIT, victim, caster) & SPELL_CANCEL_CAST)
		return FALSE

	return TRUE

#undef COMSIG_SPELL_TOUCH_CAN_HIT
