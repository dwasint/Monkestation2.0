
///sent from ai controllers when they possess a pawn: (datum/ai_controller/source_controller)
#define COMSIG_AI_CONTROLLER_POSSESSED_PAWN "ai_controller_possessed_pawn"
///sent from ai controllers when they pick behaviors: (list/datum/ai_behavior/old_behaviors, list/datum/ai_behavior/new_behaviors)
#define COMSIG_AI_CONTROLLER_PICKED_BEHAVIORS "ai_controller_picked_behaviors"
///sent from ai controllers when a behavior is inserted into the queue: (list/new_arguments)
#define AI_CONTROLLER_BEHAVIOR_QUEUED(type) "ai_controller_behavior_queued_[type]"

#define COMSIG_AI_PATH_GENERATED "ai_path_generated"
#define COMSIG_AI_MOVEMENT_SET "ai_movement_set"
#define COMSIG_AI_GENERAL_CHANGE "ai_general_change"
#define COMSIG_AI_FUTURE_PATH_GENERATED "ai_future_path_generated"
#define COMSIG_AI_PATH_SWAPPED "ai_path_swapped"
