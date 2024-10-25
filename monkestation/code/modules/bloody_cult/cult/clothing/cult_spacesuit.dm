/obj/item/clothing/suit/space/cult
	name = "cult armor"
	desc = "A bulky suit of armor bristling with spikes. It looks space proof."
	icon_state = "cultarmor"
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/weapon/tome,/obj/item/weapon/melee/cultblade,/obj/item/weapon/melee/soulblade, /obj/item/tank,/obj/item/weapon/tome,/obj/item/weapon/talisman,/obj/item/weapon/blood_tesseract)
	slowdown = 1
	siemens_coefficient = 0

	//plasmaman stuff
	var/next_extinguish=0
	var/extinguish_cooldown=10 SECONDS

/obj/item/clothing/suit/space/cult/get_cult_power()
	return 60

/obj/item/clothing/suit/space/cult/narsie_act()
	return
