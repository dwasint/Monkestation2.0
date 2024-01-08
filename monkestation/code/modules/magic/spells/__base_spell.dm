/datum/action/proc/get_owner()
	return owner

/datum/component/uses_mana/story_spell/react_to_successful_use(datum/action/cooldown/spell/source, atom/cast_on)
	drain_mana(null, null, source.owner, cast_on)

/datum/component/uses_mana/story_spell/get_mana_required(atom/caster, atom/cast_on, ...)
	if(ismob(caster))
		var/mob/caster_mob = caster
		return caster_mob.get_casting_cost_mult()
	return 1
