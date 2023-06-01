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

func calculate_best_rank(new_rank, old_rank):
	if new_rank == 'S+' or old_rank == 'S+':
		return 'S+'
	if new_rank == 'S' or old_rank == 'S':
		return 'S'
	if new_rank == 'A' or old_rank == 'A':
		return 'A'
	if new_rank == 'B' or old_rank == 'B':
		return 'B'
	return 'C'
