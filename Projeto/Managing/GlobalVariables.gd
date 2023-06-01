extends Node

var current_stage_index = 0

func calculate_rank(shine_count, puzzle_get):
	var rating := 0
	rating += shine_count
	if puzzle_get: rating += 1
	match rating:
		0: return 'C'
		1: return 'B'
		2: return 'A'
		3: return 'S'
		4: return 'S+'
		_: return 'C'
