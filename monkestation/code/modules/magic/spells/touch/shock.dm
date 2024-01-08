// Magical shock touch can just subtype normal shock touch relatievly painlessly
/datum/action/cooldown/spell/touch/shock/magical
	name = "Shocking Grasp"

	invocation = "Con cussa!"
	invocation_type = INVOCATION_SHOUT

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE

	var/shock_touch_attunement_amount = 0.5
	var/shock_touch_cost = 50

/datum/action/cooldown/spell/touch/shock/magical/New(Target, original)
	. = ..()
	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_ELECTRIC] += shock_touch_attunement_amount

	AddComponent(/datum/component/uses_mana/touch,\
		pre_use_check_with_feedback_comsig = COMSIG_SPELL_BEFORE_CAST,\
		post_use_comsig = COMSIG_SPELL_AFTER_CAST,\
		mana_consumed = shock_touch_cost,\
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)),\
		attunements = attunements,\
	)

// Shock mutation needs to address people with magic shock touch
/datum/mutation/human/shock

/datum/mutation/human/shock/grant_power()
	if(isnull(owner))
		return FALSE

	var/datum/action/cooldown/spell/touch/shock/magical/magic_shock = locate() in owner.actions
	if(isnull(magic_shock))
		return ..()

	to_chat(owner, span_notice("Your hands feel like they're buzzing with electricity."))
	magic_shock?.shock_touch_cost = 0
	power_path = null

/datum/mutation/human/shock/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return

	var/datum/action/cooldown/spell/touch/shock/magical/magic_shock = locate() in owner.actions
	if(isnull(magic_shock))
		return

	to_chat(owner, span_warning("Your hands feel numb once more."))
	magic_shock?.shock_touch_cost = initial(magic_shock.shock_touch_cost)
