// uses pickweight
GLOBAL_LIST_INIT_TYPED(leyline_amounts, /datum/leyline_amount, list(
	/datum/leyline_amount/standard = 5000,
	/datum/leyline_amount/above_average = 500,
	/datum/leyline_amount/abundant = 200,
	/datum/leyline_amount/extreme = 10
))

/datum/leyline_amount
	var/amount = 0

/datum/leyline_amount/standard
	amount = 7

/datum/leyline_amount/above_average
	amount = 10

/datum/leyline_amount/abundant
	amount = 15

/datum/leyline_amount/extreme
	amount = 20

