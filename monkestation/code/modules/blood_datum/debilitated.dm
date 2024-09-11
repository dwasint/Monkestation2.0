/datum/physiology
	///our temp stamina mod
	var/temp_stamina_mod = 1

/datum/status_effect/stacking/debilitated
	id = "debilitated"
	stacks = 0
	max_stacks = 10
	tick_interval = 10 SECONDS
	delay_before_decay = 3 MINUTES
	consumed_on_threshold = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/debilitated
	status_type = STATUS_EFFECT_REFRESH

	///our base stamina damage increase on stamina projectiles
	var/base_increase = 10
	///our increase per stack
	var/per_stack_increase = 5
	///our base stamina loss multiplier
	var/loss_multiplier = 1
	///our per stack increase to stamina loss
	var/per_stack_multiplier_increase = 0.1
	///our cached stamina_mod
	var/cached_stamina

/datum/status_effect/stacking/debilitated/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/human = owner
		cached_stamina = human.physiology.temp_stamina_mod
	RegisterSignal(owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(check_bullet))

/datum/status_effect/stacking/debilitated/add_stacks(stacks_added)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human = owner
	human.physiology.temp_stamina_mod = loss_multiplier + (stacks * per_stack_multiplier_increase)

/datum/status_effect/stacking/debilitated/proc/check_bullet(mob/living/carbon/human/source, obj/projectile/hitting_projectile, def_zone)
	SIGNAL_HANDLER

	if(hitting_projectile.stamina < 10)
		return

	source.stamina.adjust(-base_increase + (stacks * per_stack_increase), FALSE, TRUE)

/atom/movable/screen/alert/status_effect/debilitated
	icon_state = "debilitated"
	name = "Debilitated"
	desc = "You are taking extra stamina damage from incoming projectiles, and lose stamina faster."
