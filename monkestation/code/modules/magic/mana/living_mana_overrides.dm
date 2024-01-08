/mob/living/carbon
	has_initial_mana_pool = TRUE

/mob/living/carbon/get_initial_mana_pool_type()
	return /datum/mana_pool/mob/living/carbon

/datum/mana_pool/mob/living/carbon
	maximum_mana_capacity = CARBON_BASE_MANA_CAPACITY

	exponential_decay_divisor = BASE_CARBON_MANA_EXPONENTIAL_DIVISOR

/mob/living/carbon/initialize_mana_pool()
	var/datum/mana_pool/mob/living/carbon/our_pool = ..()

	//our_pool.set_max_mana((our_pool.maximum_mana_capacity * get_max_mana_capacity_mult()), change_amount = TRUE, change_softcap = TRUE)

	our_pool.softcap *= get_mana_softcap_mult(mana_pool)

	return our_pool

/mob/living/carbon/proc/get_mana_softcap_mult(datum/mana_pool/pool)
	SHOULD_BE_PURE(TRUE)

	var/mult = 1

	if (mob_biotypes & MOB_ROBOTIC)
		mult *= ROBOTIC_MANA_SOFTCAP_MULT

	return mult

/mob/living/carbon/proc/get_max_mana_capacity_mult()
	SHOULD_BE_PURE(TRUE)

	var/mult = 1

	return mult
