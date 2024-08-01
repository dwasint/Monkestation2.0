/datum/artifact_fault
	var/name = "Generic Fault"
	///the visible message sent when triggered
	var/visible_message
	///the chance of us triggering on bad info
	var/trigger_chance = 0

/datum/artifact_fault/proc/on_trigger(datum/component/artifact/component)
	return

/datum/artifact_fault/shutdown
	name = "Generic Shutdown Fault"

/datum/artifact_fault/on_trigger(datum/component/artifact/component)
	if(component.active)
		component.artifact_deactivate()
