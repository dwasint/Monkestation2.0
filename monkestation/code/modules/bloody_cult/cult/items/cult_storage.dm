/obj/item/storage/cult
	name = "coffer"
	desc = "A gloomy-looking storage chest."
	icon = 'monkestation/code/modules/bloody_cult/icons/storage.dmi'
	icon_state = "cult"

/obj/item/reagent_containers/cup/cult
	name = "tempting goblet"
	desc = "An obsidian cup in the shape of a skull. Used by the followers of Nar-Sie to collect the blood of their sacrifices."
	icon_state = "cult"

	fill_icon = 'monkestation/code/modules/bloody_cult/icons/reagentfillings.dmi'
	fill_icon_state = "cult"
	amount_per_transfer_from_this = 10
	volume = 60
	force = 5
	throwforce = 7

/obj/item/reagent_containers/cup/cult/examine(var/mob/user)
	..()
	if (IS_CULTIST(user))
		if(issilicon(user))
			to_chat(user, "<span class='info'>Drinking blood from this cup will always safely replenish the vessels of cultists, regardless of blood type. It's a shame you're a robot.</span>")
		else
			to_chat(user, "<span class='info'>Drinking blood from this cup will always safely replenish your own vessels, regardless of blood types. The opposite is true to non-cultists. Throwing this cup at them may force them to swallow some of its content if their face isn't covered.</span>")


/obj/item/reagent_containers/cup/cult/gamer
	name = "gamer goblet"
	desc = "A plastic cup in the shape of a skull. Typically full of Geometer-Fuel."

/obj/item/reagent_containers/cup/cult/narsie_act()
	return

/obj/item/reagent_containers/cup/cult/bloodfilled

/obj/item/reagent_containers/cup/cult/bloodfilled/New()
	..()
	reagents.add_reagent(/datum/reagent/blood, 50)
