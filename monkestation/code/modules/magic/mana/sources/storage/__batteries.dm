/datum/mana_pool/mana_battery

/datum/mana_pool/mana_battery/can_transfer(datum/mana_pool/target_pool)
	if (QDELETED(target_pool.parent))
		return TRUE

	var/obj/item/mana_battery/battery = parent

	if (battery.loc == target_pool.parent.loc)
		return TRUE

	if (get_dist(battery, target_pool.parent) > battery.max_allowed_transfer_distance)
		return TRUE

	return FALSE

/obj/item/mana_battery
	name = "generic mana battery"

	has_initial_mana_pool = TRUE
	var/max_allowed_transfer_distance = MANA_BATTERY_MAX_TRANSFER_DISTANCE

/obj/item/mana_battery/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_battery

/obj/item/mana_battery/attack_self(mob/user, modifiers)
	. = ..()

	if (.)
		return TRUE

	if (!user.mana_pool)
		balloon_alert(user, "you have no mana pool!")
		return FALSE

	var/already_transferring = (user in mana_pool.transferring_to)
	var/results
	if (already_transferring)
		results = mana_pool.stop_transfer(user.mana_pool)
	else
		results = mana_pool.start_transfer(user.mana_pool, force_process = TRUE)

/obj/item/mana_battery/mana_crystal
	name = MAGIC_MATERIAL_NAME + " crystal"
	desc = "Crystalized mana." //placeholder desc
	icon = 'goon/icons/obj/artifacts/artifacts.dmi'
	icon_state = "wizard-1"

// Do not use, basetype
/datum/mana_pool/mana_battery/mana_crystal

	maximum_mana_capacity = MANA_CRYSTAL_BASE_MANA_CAPACITY
	softcap = MANA_CRYSTAL_BASE_MANA_CAPACITY

	exponential_decay_divisor = MANA_CRYSTAL_BASE_DECAY_DIVISOR

	max_donation_rate_per_second = BASE_MANA_CRYSTAL_DONATION_RATE

/obj/item/mana_battery/mana_crystal/standard

/obj/item/mana_battery/mana_crystal/standard/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_battery/mana_crystal/standard

/datum/mana_pool/mana_battery/mana_crystal/standard // basically, just, bog standard, none of the variables need to be changed

/obj/item/mana_battery/mana_crystal/small
	icon = 'goon/icons/obj/artifacts/artifacts.dmi'
	icon_state = "wizard-2"
