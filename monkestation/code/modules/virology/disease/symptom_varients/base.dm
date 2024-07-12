/datum/symptom_varient
	var/name = "Generic Varient"
	var/desc = "An amalgamation of genes."

	var/datum/symptom/host_symptom

/datum/symptom_varient/New(datum/symptom/host)
	. = ..()
	host_symptom = host

	setup_varient()

/datum/symptom_varient/proc/setup_varient()
	return TRUE
