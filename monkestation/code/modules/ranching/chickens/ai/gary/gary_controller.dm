/datum/ai_controller/chicken/gary
	planning_subtrees = list(
		/datum/ai_planning_subtree/gary,
		/datum/ai_planning_subtree/flee_target/low_health,
		)

	idle_behavior = /datum/idle_behavior/chicken/gary

/datum/ai_controller/chicken/gary/TryPossessPawn(atom/new_pawn)
	. = ..()
	blackboard += BB_GARY_HIDEOUT
	blackboard += BB_GARY_TARGET_AREA
	blackboard += BB_GARY_WANDER_COOLDOWN

	blackboard += BB_GARY_BARTERING
	blackboard += BB_GARY_BARTER_TARGET
	blackboard += BB_GARY_BARTER_ITEM
	blackboard += BB_GARY_BARTER_STEP

	blackboard += BB_GARY_HIDEOUT_SETTING_UP
	blackboard += BB_GARY_COME_HOME
	blackboard += BB_GARY_HAS_SHINY


/datum/ai_controller/basic_controller/chicken/gary/get_access()
	return list(ACCESS_SYNDICATE, ACCESS_MAINT_TUNNELS, ACCESS_AWAY_MAINTENANCE)

/datum/idle_behavior/chicken/gary/perform_idle_behavior(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	if(prob(5) && (world.time > controller.blackboard[BB_GARY_WANDER_COOLDOWN]))
		controller.queue_behavior(/datum/ai_behavior/gary_goto_target)


/datum/ai_movement/jps/gary
	max_pathing_attempts = 25
	maximum_length = 60
	diagonal_flags = DIAGONAL_REMOVE_ALL
