/datum/design/manipulator_filter
	name = "Manipulator Filter"
	desc = "This can be inserted into a manipulator to give it filters."
	id = "manipulator_filter"
	build_path = /obj/item/manipulator_filter
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO
	)
	materials = list(/datum/material/iron = 2000)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/design/manipulator_filter_cargo
	name = "Manipulator Filter (Department)"
	desc = "This can be inserted into a manipulator to give it filters."
	id = "manipulator_filter_cargo"
	build_path = /obj/item/manipulator_filter/cargo
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO
	)
	materials = list(/datum/material/iron = 2000)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/design/manipulator_filter_internal
	name = "Manipulator Filter (Internal)"
	desc = "This can be inserted into a manipulator to give it filters."
	id = "manipulator_filter_internal"
	build_path = /obj/item/manipulator_filter/internal_filter
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO
	)
	materials = list(/datum/material/iron = 2000)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/big_manipulator
	name = "Big Manipulator Board"
	desc = "The circuit board for a big manipulator."
	id = "big_manipulator"
	build_path = /obj/item/circuitboard/machine/big_manipulator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE
