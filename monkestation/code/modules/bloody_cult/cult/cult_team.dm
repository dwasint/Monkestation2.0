/datum/team/cult
	name = "\improper Cult"

	///The blood mark target
	var/atom/blood_target
	///Image of the blood mark target
	var/image/blood_target_image
	///Timer for the blood mark expiration
	var/blood_target_reset_timer

	///Has a vote been called for a leader?
	var/cult_vote_called = FALSE
	///The cult leader
	var/mob/living/cult_master
	///Has the mass teleport been used yet?
	var/reckoning_complete = FALSE
	///Has the cult risen, and gotten red eyes?
	var/cult_risen = FALSE
	///Has the cult asceneded, and gotten halos?
	var/cult_ascendent = FALSE

	///Has narsie been summoned yet?
	var/narsie_summoned = FALSE
	///How large were we at max size.
	var/size_at_maximum = 0
	///list of cultists just before summoning Narsie
	var/list/true_cultists = list()


	//////NEW STUFF HERE
	var/stage = BLOODCULT_STAGE_NORMAL
	var/list/bloody_floors = list()
	var/cult_win = FALSE

	var/list/cult_reminders = list()

	var/list/bindings = list()

	var/cultist_cap = 1	//clamped between 5 and 9 depending on crew size. once the cap goes up it cannot go down.
	var/min_cultist_cap = 5
	var/max_cultist_cap = 9

	var/mentor_count = 0 	//so we don't loop through the member list if we already know there are no mentors in there

	var/cult_founding_time = 0
	var/last_process_time = 0
	var/delta = 1

	var/eclipse_progress = 0
	var/eclipse_target = 1800
	var/eclipse_window = 10 MINUTES
	var/eclipse_increments = 0
	var/eclipse_contributors = list()//associative list: /mind = score

	var/soon_announcement = FALSE
	var/overtime_announcement = FALSE

	var/bloodstone_rising_time = 0
	var/bloodstone_duration = 430 SECONDS
	var/bloodstone_target_time = 0

	var/datum/rune_spell/tearreality/tear_ritual = null
	var/obj/structure/cult/bloodstone/bloodstone = null		//we track the one spawned by the Tear Reality rune
	var/obj/narsie/narsie = null

	//we track the mind of anyone that has been converted or made prisoner at least once.
	var/previously_made_prisoner = list()
	var/previously_converted = list()

	var/total_devotion = 0

	var/twister = FALSE

	var/list/deconverted = list()//tracking for scoreboard purposes

	var/datum/bloodcult_ritual/bloodspill_ritual = null

	var/list/possible_rituals = list()
	var/list/rituals = list(RITUAL_FACTION_1,RITUAL_FACTION_2,RITUAL_FACTION_3)

	var/countdown_to_first_rituals = 5


/datum/team/cult/proc/check_size()
	if(cult_ascendent)
		return

#ifdef UNIT_TESTS
	// This proc is unnecessary clutter whilst running cult related unit tests
	// Remove this if, at some point, someone decides to test that halos and eyes are added at expected ratios
	return
#endif

	var/alive = 0
	var/cultplayers = 0
	for(var/I in GLOB.player_list)
		var/mob/M = I
		if(M.stat != DEAD)
			if(IS_CULTIST(M))
				++cultplayers
			else
				++alive

	ASSERT(cultplayers) //we shouldn't be here.
	var/ratio = alive ? cultplayers/alive : 1
	if(ratio > CULT_RISEN && !cult_risen)
		for(var/datum/mind/mind as anything in members)
			if(mind.current)
				SEND_SOUND(mind.current, 'sound/ambience/antag/bloodcult/bloodcult_eyes.ogg')
				to_chat(mind.current, span_cultlarge(span_warning("The veil weakens as your cult grows, your eyes begin to glow...")))
				mind.current.AddElement(/datum/element/cult_eyes)
		cult_risen = TRUE
		log_game("The blood cult has risen with [cultplayers] players.")

	if(ratio > CULT_ASCENDENT && !cult_ascendent)
		for(var/datum/mind/mind as anything in members)
			if(mind.current)
				SEND_SOUND(mind.current, 'sound/ambience/antag/bloodcult/bloodcult_halos.ogg')
				to_chat(mind.current, span_cultlarge(span_warning("Your cult is ascendent and the red harvest approaches - you cannot hide your true nature for much longer!!")))
				mind.current.AddElement(/datum/element/cult_halo)
		cult_ascendent = TRUE
		log_game("The blood cult has ascended with [cultplayers] players.")

/datum/team/cult/add_member(datum/mind/new_member)
	. = ..()
	// A little hacky, but this checks that cult ghosts don't contribute to the size at maximum value.
	if(is_unassigned_job(new_member.assigned_role))
		return
	size_at_maximum++

/datum/team/cult/proc/make_image(datum/objective/sacrifice/sac_objective)
	var/datum/job/job_of_sacrifice = sac_objective.target.assigned_role
	var/datum/preferences/prefs_of_sacrifice = sac_objective.target.current.client.prefs
	var/icon/reshape = get_flat_human_icon(null, job_of_sacrifice, prefs_of_sacrifice, list(SOUTH))
	reshape.Shift(SOUTH, 4)
	reshape.Shift(EAST, 1)
	reshape.Crop(7,4,26,31)
	reshape.Crop(-5,-3,26,30)
	sac_objective.sac_image = reshape

/datum/team/cult/proc/setup_objectives()
	START_PROCESSING(SSobj, src)
	for (var/ritual_type in GLOB.bloodcult_faction_rituals)
		possible_rituals += new ritual_type()
	cult_founding_time = world.time
	initialize_rune_words()
	for (var/datum/mind/mind in members)
		var/mob/M = mind.current
		to_chat(M, "<span class='sinister'>Our communion must remain small and secretive until we are confident enough.</span>")
		previously_converted |= mind

	var/datum/objective/sacrifice/sacrifice_objective = new
	sacrifice_objective.team = src
	sacrifice_objective.find_target()
	objectives += sacrifice_objective

	var/datum/objective/eldergod/summon_objective = new
	summon_objective.team = src
	objectives += summon_objective

/datum/team/cult/proc/replace_rituals(var/slot)
	if (!slot)
		return

	var/list/valid_rituals = list()

	for (var/datum/bloodcult_ritual/R in possible_rituals)
		if (R.pre_conditions())
			valid_rituals += R

	if (valid_rituals.len < 1)
		return

	var/datum/bloodcult_ritual/BR = pick(valid_rituals)
	rituals[slot] = BR
	possible_rituals -= BR
	BR.init_ritual()

	for (var/datum/antagonist/cult/cultist in members)
		var/mob/O = cultist.owner.current
		if (O)
			to_chat(O, "<span class='sinister'>A new ritual is available...</span>")
		var/datum/mind/M = cultist.owner
		if ("Cult Panel" in M.active_uis)
			var/datum/mind_ui/m_ui = M.active_uis["Cult Panel"]
			if (m_ui.active)
				m_ui.Display()

/datum/team/cult/proc/UpdateCap()
	if (stage == BLOODCULT_STAGE_DEFEATED)
		cultist_cap = 0
		return
	if (stage == BLOODCULT_STAGE_NARSIE)
		cultist_cap = 666
		return
	var/living_players = 0
	var/new_cap = 0
	for (var/mob/M in GLOB.player_list)
		if (!M.client)
			continue
		if (istype(M,/mob/dead/new_player))
			continue
		if (M.stat != DEAD)
			living_players++
	new_cap =  clamp(round(living_players / 3),min_cultist_cap,max_cultist_cap)
	if (new_cap > cultist_cap)
		cultist_cap = new_cap
		for (var/datum/mind/mind in members)
			var/mob/M = mind.current
			to_chat(M, "<span class='sinister'>The station population is now large enough for <span class='userdanger'>[cultist_cap]</span> cultists, plus one of each construct types.</span>")

/datum/team/cult/proc/CanConvert(construct_type)
	var/list/free_construct_slots = list()
	var/cultist_count = 0
	for (var/datum/mind/mind in members)
		var/mob/M = mind.current
		//The first construct of each type doesn't take up a slot.
		if (istype(M, /mob/living/basic/construct))
			var/mob/living/basic/construct/C = M
			if (!(C.construct_type in free_construct_slots))
				free_construct_slots += C.construct_type
				continue
		//Living Humans, Shades and extra Constructs all count.
		if (isliving(M))
			if (M.stat != DEAD)
				cultist_count += 1

	if(construct_type && (!(construct_type in free_construct_slots)))
		return TRUE

	return (cultist_count < cultist_cap)


/datum/team/cult/proc/check_ritual(var/key, var/extra)
	switch(stage)
		if (BLOODCULT_STAGE_DEFEATED)//no more devotion gains if the bloodstone has been destroyed
			return
		if (BLOODCULT_STAGE_NARSIE)//or narsie has risen
			return

	if (key && (stage != BLOODCULT_STAGE_ECLIPSE))
		for (var/ritual_slot in rituals)
			if (rituals[ritual_slot])
				var/datum/bloodcult_ritual/faction_ritual = rituals[ritual_slot]
				if (key in faction_ritual.keys)
					if (faction_ritual.key_found(extra))
						faction_ritual.complete()
						if (!faction_ritual.only_once)
							possible_rituals += faction_ritual
						rituals[ritual_slot] = null
						for (var/datum/mind/mind in members)
							var/mob/M = mind.current
							if (M)
								to_chat(M, "<span class='sinister'>Someone has completed a ritual, rewarding the entire cult...soon another ritual will take its place.</span>")
						spawn(10 MINUTES)
							if (!rituals[ritual_slot])
								replace_rituals(ritual_slot)

/datum/team/cult/proc/stage(var/value)
	stage = value
	switch(stage)
		if (BLOODCULT_STAGE_READY)
			eclipse_trigger_cult()
			for(var/obj/structure/cult/spire/S in GLOB.cult_spires)
				S.upgrade(3)
		if (BLOODCULT_STAGE_MISSED)
			for (var/datum/mind/mind in members)
				var/mob/M = mind.current
				if (M)
					to_chat(M, "<span class='sinister'>The Eclipse has passed. You won't be able to tear reality aboard this station anymore. Escape the station alive with your fellow cultists so you may try again another day.</span>")
			for(var/obj/structure/cult/spire/S in GLOB.cult_spires)
				S.upgrade(1)
		if (BLOODCULT_STAGE_ECLIPSE)
			setup_hell()
			/*
			update_all_parallax()
			var/datum/zLevel/ZL = map.zLevels[map.zMainStation]
			ZL.transitionLoops = TRUE
			spawn()
				for (var/mob/dead/observer/O in player_list)
					O.cultify()
					sleep(rand(1,5))
			bloodstone_rising_time = world.time
			bloodstone_target_time = world.time + bloodstone_duration
			spawn (3 SECONDS)//leaving just a moment for the blood stone to rise.
				last_security_level_change = SEC_LEVEL_RED
				var/sec_change = TRUE
				for(var/datum/faction/F in ticker.mode.factions)
					if (F.last_security_level_change == SEC_LEVEL_DELTA)
						sec_change = FALSE
				command_alert(/datum/command_alert/eclipse_bloodstone)
				if (sec_change)
					ticker.StartThematic("endgame")
					sleep(2 SECONDS)
					set_security_level("red")
				*/
		if (BLOODCULT_STAGE_DEFEATED)
			GLOB.eclipse.eclipse_end()
			for (var/obj/effect/new_rune/R in runes)
				qdel(R)//new runes can be written, but any pre-existing one gets nuked.
			cultist_cap = 0
			spawn()
				for(var/mob/living/simple_animal/M in GLOB.mob_list)
					if(!M.client && (M.faction == "cult"))
						M.death()
					CHECK_TICK
			spawn()
			for(var/obj/structure/cult/spire/S in GLOB.cult_spires)
				S.upgrade(1)
			spawn(5 SECONDS)
				for (var/datum/mind/mind in members)
					var/mob/M = mind.current
					to_chat(M, "<span class='sinister'>With the blood stone destroyed, the tear through the veil has been mended, and a great deal of occult energies have been purged from the Station.</span>")
					sleep(3 SECONDS)
					to_chat(M, "<span class='sinister'>Your connection to the Geometer of Blood has grown weaker and you can no longer recall the runes as easily as you did before. Maybe an Arcane Tome can alleviate the problem.</span>")
					sleep(3 SECONDS)
					to_chat(M, "<span class='sinister'>Lastly it seems that the toll of the ritual on your body hasn't gone away. Going unnoticed will be a lot harder.</span>")
		if (BLOODCULT_STAGE_NARSIE)
			if (bloodstone)
				anim(target = bloodstone.loc, a_icon = 'icons/obj/cult/narsie.dmi', flick_anim = "narsie_spawn_anim_start", offX = -236, offY = -256, plane = MASSIVE_OBJ_PLANE)
				sleep(5)
				narsie = new(bloodstone.loc)
	for (var/datum/mind/M in members)
		if ("Cult Panel" in M.active_uis)
			var/datum/mind_ui/m_ui = M.active_uis["Cult Panel"]
			if (m_ui.active)
				m_ui.Display()
		if ("Cultist Panel" in M.active_uis)
			var/datum/mind_ui/m_ui = M.active_uis["Cultist Panel"]
			if (m_ui.active)
				m_ui.Display()

/datum/team/cult/proc/HandleRecruitedRole(datum/antagonist/R)
	if (cult_reminders.len)
		to_chat(R.owner.current, "<span class='notice'>Other cultists have shared some of their knowledge. It will be stored in your memory (check your Notes under the IC tab).</span>")
	/*
	for (var/reminder in cult_reminders)
		R.antag.store_memory("Shared Cultist Knowledge: [reminder].")
	*/
	previously_converted |= R.owner
	if (R.owner.name in deconverted)
		deconverted -= R.owner.name

/datum/team/cult/proc/assign_rituals()
	var/list/valid_rituals = list()

	for (var/datum/bloodcult_ritual/R in possible_rituals)
		if (R.pre_conditions())
			valid_rituals += R

	if (valid_rituals.len < 3)
		return

	for (var/ritual_slot in rituals)
		var/datum/bloodcult_ritual/BR = pick(valid_rituals)
		rituals[ritual_slot] = BR
		possible_rituals -= BR
		valid_rituals -= BR
		BR.init_ritual()

	for (var/datum/mind/M in members)
		if ("Cult Panel" in M.active_uis)
			var/datum/mind_ui/m_ui = M.active_uis["Cult Panel"]
			if (m_ui.active)
				m_ui.Display()

/datum/team/cult/process()
	..()
	if (cultist_cap > 1) //The first call occurs in OnPostSetup()
		UpdateCap()

	switch(stage)
		if (BLOODCULT_STAGE_NORMAL)
			if (bloodspill_ritual)
				check_ritual("bloodspill", bloody_floors.len)
			//if there is at least one cultist alive, the eclipse comes forward
			for (var/datum/mind/mind in members)
				var/mob/M = mind.current
				calculate_eclipse_rate()
				if (isliving(M) && M.stat != DEAD)
					//we calculate the progress relative to the time since the last process so the overall time is independant from server lag and shit
					delta = 1
					if (last_process_time && (last_process_time < world.time))//carefully dealing with midnight rollover
						delta = (world.time - last_process_time)
						if(SSticker.initialized)
							delta /= SSticker.wait
					last_process_time = world.time

					eclipse_progress += max(0.1, eclipse_increments) * delta
					if (eclipse_progress >= eclipse_target)
						stage(BLOODCULT_STAGE_READY)
					break
			if (countdown_to_first_rituals)
				countdown_to_first_rituals--
				if (countdown_to_first_rituals <= 0)
					assign_rituals()
					for (var/datum/mind/mind in members)
						var/datum/antagonist/cult/C = mind.has_antag_datum(/datum/antagonist/cult)
						C.assign_rituals()
						var/mob/M = mind.current
						if (M)
							to_chat(M, "<span class='sinister'>Although you can generate devotion by performing most cult activities, a couple rituals for you to perform are now available. Check the cult panel.</span>")


		if (BLOODCULT_STAGE_MISSED)
			if (bloodspill_ritual)
				check_ritual("bloodspill", bloody_floors.len)
		if (BLOODCULT_STAGE_READY)
			/*
			if (GLOB.eclipse == ECLIPSE_OVER)
				stage(BLOODCULT_STAGE_MISSED)
			*/
		if (BLOODCULT_STAGE_ECLIPSE)
			bloodstone.update_icon()
			if (world.time >= bloodstone_target_time)
				stage(BLOODCULT_STAGE_NARSIE)

/datum/team/cult/proc/calculate_eclipse_rate()
	eclipse_increments = 0
	for (var/datum/mind/mind in members)
		var/mob/M = mind.current
		var/datum/antagonist/cult/R = mind.has_antag_datum(/datum/antagonist/cult)
		if (isliving(M) && M.stat != DEAD)
			if (M.occult_muted())
				eclipse_increments -= R.get_eclipse_increment()
			else
				eclipse_increments += R.get_eclipse_increment()


/datum/team/cult/proc/setup_hell()
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		var/list/turfs = get_area_turfs(/area/space, z)
		for(var/turf/open/space/space in turfs)
			space.add_particles(PS_SPACE_RUNES)//visible for everyone
			space.adjust_particles(PVAR_SPAWNING, rand(5,20)/1000 ,PS_SPACE_RUNES)

	for(var/datum/time_of_day/time in SSoutdoor_effects.time_cycle_steps)
		time.color = COLOR_BLOOD
	GLOB.GLOBAL_LIGHT_RANGE = 20

	for (var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
		SSoutdoor_effects.transition_sunlight_color(SP)

/datum/team/cult/proc/add_bloody_floor(turf/T)
	if (!istype(T))
		return
	if(T && (is_station_level(T.z)))
		if(!(locate("\ref[T]") in bloody_floors))
			bloody_floors[T] = T


/datum/team/cult/proc/remove_bloody_floor(turf/T)
	if (!istype(T))
		return
	bloody_floors -= T
