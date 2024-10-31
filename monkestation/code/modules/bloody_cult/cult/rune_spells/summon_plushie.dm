/datum/rune_spell/summon_plushie
	secret = TRUE
	name = "Manifest Nar'sie Plushie"
	desc = "Manifest's Nar'sie in plushie form, helps prepare yourself for the ritual."
	desc_talisman = "Summons Nar'sie in plushie form, helps prepare yourself for the ritual."
	invocation = "Sa Tatha Plu'Shi"
	word1 = /datum/rune_word/see
	word2 = /datum/rune_word/self
	word3 = /datum/rune_word/hide
	talisman_uses = 1
	page = "This rune, summons a plushie of your god."

/datum/rune_spell/summon_plushie/cast()
	var/obj/effect/new_rune/R = spell_holder
	if (istype(R))
		R.one_pulse()
	new /obj/item/toy/plush/narplush
	qdel(R)
