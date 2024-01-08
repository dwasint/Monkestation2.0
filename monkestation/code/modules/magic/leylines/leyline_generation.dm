/turf
	var/list/leylines = list()
	var/distance_from_leyline = 0

/datum/mana_pool/leyline/proc/generate_start_and_end()
	var/starting_y = 0
	var/starting_x = 0
	var/stuck_dir = pick(GLOB.cardinals)

	var/ending_x = 0
	var/ending_y = 0

	var/stuck_axis
	switch(stuck_dir)
		if(NORTH)
			starting_y = 255
			stuck_axis = "Y"
		if(SOUTH)
			starting_y = 1
			stuck_axis = "Y"
		if(EAST)
			starting_x = 1
			stuck_axis = "X"
		if(WEST)
			starting_x = 255
			stuck_axis = "X"

	switch(stuck_axis)
		if("X")
			starting_y = rand(1, 255)
			ending_x = rand(2, 254)
			ending_y = rand(1, 255)
		if("Y")
			starting_x = rand(1, 255)
			ending_y = rand(2, 254)
			ending_x = rand(1, 255)

	var/station_z = SSmapping.levels_by_trait(ZTRAIT_STATION)[1]
	var/turf/ending = locate(ending_x, ending_y, station_z)
	var/turf/starting = locate(starting_x, starting_y, station_z)

	return list(starting, ending, stuck_axis)

/datum/mana_pool/leyline/proc/create_leyline_objects()
	var/list/data = generate_start_and_end()
	var/expansion = data[3]
	var/list/line_turfs = get_line(data[1], data[2])
	var/thickness = intensity.thickness

	var/turf/starting = data[1]
	starting.Beam(data[2])

	for(var/turf/turf as anything in line_turfs)
		for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
			var/turf/located = locate(turf.x, turf.y, z)
			located.leylines |= src

			switch(expansion)
				if("Y")
					for(var/num = 1 to thickness)
						var/turf/turf_x_minus = locate(turf.x-num, turf.y, z)
						var/turf/turf_x_plus = locate(turf.x+num, turf.y, z)
						turf_x_plus.leylines |= src
						turf_x_plus.distance_from_leyline = num
						turf_x_minus.leylines |= src
						turf_x_minus.distance_from_leyline = num
				if("X")
					for(var/num = 1 to thickness)
						var/turf/turf_y_minus = locate(turf.x, turf.y-num, z)
						var/turf/turf_y_plus = locate(turf.x, turf.y+num, z)
						turf_y_plus.leylines |= src
						turf_y_plus.distance_from_leyline = num
						turf_y_minus.leylines |= src
						turf_y_minus.distance_from_leyline = num
