
/datum/action/cooldown/spell/cult
	panel = "Cult"
	overlay_icon_state = "cult"
	spell_requirements = NONE

/datum/action/cooldown/spell/cult/is_valid_target(atom/cast_on)
	. = ..()
	if(cast_on != owner)
		return FALSE

// Not sure what to do with this spell really, it always kinda sucked and tomes as a whole need an overhaul. Runic Skin is a better power.
var/list/arcane_pockets = list()

/datum/action/cooldown/spell/cult/arcane_dimension
	name = "Arcane Dimension (empty)"
	desc = "Cast while holding an Arcane Tome to discretly store it through the veil."
	button_icon_state = "cult_pocket_empty"

	invocation_type = INVOCATION_NONE
	var/obj/item/weapon/tome/stored_tome = null

/datum/action/cooldown/spell/cult/arcane_dimension/New()
	..()
	arcane_pockets.Add(src)

/datum/action/cooldown/spell/cult/arcane_dimension/Destroy()
	arcane_pockets.Remove(src)
	..()

/datum/action/cooldown/spell/cult/arcane_dimension/cast(mob/living/user)
	..()
	if (user.occult_muted())
		to_chat(user, "<span class='warning'>You can't seem to remember how to access your arcane dimension right now.</span>")
		return 0
	if (stored_tome)
		stored_tome.forceMove(get_turf(user))
		if (user.get_inactive_hand() && user.get_active_hand())//full hands
			to_chat(user,"<span class='warning'>Your hands being full, your [stored_tome] had nowhere to fall but on the ground.</span>")
		else
			to_chat(user,"<span class='notice'>You hold your hand palm up, and your [stored_tome] drops in it from thin air.</span>")
			user.put_in_hands(stored_tome)
		stored_tome = null
		name = "Arcane Dimension (empty)"
		desc = "Cast while holding an Arcane Tome to discretly store it through the veil."
		button_icon_state = "cult_pocket_empty"
		return

	var/obj/item/weapon/tome/held_tome = locate() in user.held_items
	if (held_tome)
		if (held_tome.state == TOME_OPEN)
			held_tome.icon_state = "tome"
			held_tome.state = TOME_CLOSED
		stored_tome = held_tome
		user.dropItemToGround(held_tome)
		held_tome.loc = null
		to_chat(user,"<span class='notice'>With a swift movement of your arm, you drop \the [held_tome] that disappears into thin air before touching the ground.</span>")
		name = "Arcane Dimension (full)"
		desc = "Cast to pick up your Arcane Tome back from the veil. You should preferably have a free hand."
		button_icon_state = "cult_pocket_full"


///////////////////////////////ASTRAL PROJECTION SPELLS/////////////////////////////////////


/datum/action/cooldown/spell/astral_return
	name = "Re-enter Body"
	desc = "End your astral projection and re-awaken inside your body. If used while tangible you might spook on-lookers, so be mindful."
	button_icon_state = "astral_return"
	overlay_icon_state = "cult"
	spell_requirements = NONE


/datum/action/cooldown/spell/astral_return/cast(mob/living/user)
	. = ..()
	var/mob/living/basic/astral_projection/astral = user
	if (istype(astral))
		astral.death()//pretty straightforward isn't it?

/datum/action/cooldown/spell/astral_toggle
	name = "Toggle Tangibility"
	desc = "Turn into a visible copy of your body, able to speak and bump into doors. But note that the slightest source of damage will dispel your astral projection altogether."
	background_icon_state = "cult"
	spell_requirements = NONE

/datum/action/cooldown/spell/astral_toggle/cast(mob/living/user)
	. = ..()
	var/mob/living/basic/astral_projection/astral = user
	astral.toggle_tangibility()
	if (astral.tangibility)
		desc = "Turn back into an invisible projection of your soul."
	else
		desc = "Turn into a visible copy of your body, able to speak and bump into doors. But note that the slightest source of damage will dispel your astral projection altogether."
