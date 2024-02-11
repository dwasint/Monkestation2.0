/datum/quirk/stable_ass
	name = "Stable Rear"
	desc = "Your rear is far more robust than average, falling off less often than usual."
	value = 2
	icon = "face-sad-cry"
	//All effects are handled directly in butts.dm

/datum/quirk/loud_ass
	name = "Loud Ass"
	desc = "For some ungodly reason, your ass is twice as loud as normal."
	value = 2
	icon = "volume-high"
	//All effects are handled directly in butts.dm

/datum/quirk/dummy_thick
	name = "Dummy Thicc"
	desc = "Hm...Colonel, I'm trying to sneak around, but I'm dummy thicc and the clap of my ass cheeks keep alerting the guards..."
	value = 3	//Why are we still here? Just to suffer?
	icon = "bullhorn"

/datum/quirk/dummy_thick/post_add()
	. = ..()
	RegisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_move))
	var/obj/item/organ/internal/butt/booty = quirk_holder.get_organ_by_type(/obj/item/organ/internal/butt)
	var/matrix/thick = new
	thick.Scale(1.5)
	animate(booty, transform = thick, time = 1)

/datum/quirk/dummy_thick/proc/on_mob_move()
	SIGNAL_HANDLER
	if(prob(33))
		playsound(quirk_holder, "monkestation/sound/misc/clap_short.ogg", 70, TRUE, 5, ignore_walls = TRUE)

/datum/quirk/gourmand
	name = "Gourmand"
	desc = "You enjoy the finer things in life. You are able to have one more food buff applied at once."
	value = 2
	icon = FA_ICON_COOKIE_BITE
	mob_trait = TRAIT_GOURMAND
	gain_text = "<span class='notice'>You start to enjoy fine cuisine.</span>"
	lose_text = "<span class='danger'>Those Space Twinkies are starting to look mighty fine.</span>"

/datum/quirk/gourmand/add()
	var/mob/living/carbon/human/holder = quirk_holder
	holder.max_food_buffs ++

/datum/quirk/gourmand/remove()
	var/mob/living/carbon/human/holder = quirk_holder
	holder.max_food_buffs --
