extends TileMap

var Cell = load("res://scripts/Cell.gd")
var SmartList = load("res://scripts/SmartList.gd")
var cells = []
var grid_h = 21
var grid_w = 19
var start
var end

func _ready():
	init_grid()

func init_grid():
	for x in range(grid_w):
		for y in range(grid_h):
			cells.append(Cell.new(x, y, get_cell(x, y) != 0))
func find_path(map_from, map_to):
	start = get_cell_list(map_from.x, map_from.y)
	end = get_cell_list(map_to.x, map_to.y)
	var opened = SmartList.new()
	opened.append(start)
	var closed = []
	while opened.get_size():
		var cell = opened.get_top()
		closed.append(cell)
		if cell == end:
			return calc_path()
		var adj_cells = get_adjacent_cell(cell)
		for adj_cell in adj_cells:
			if adj_cell.reachable and not closed.has(adj_cell):
				if opened.has(adj_cell):
					if adj_cell.g > cell.g + 10:
						update_cell(adj_cell, cell)
				else:
					update_cell(adj_cell, cell)
					opened.append(adj_cell)
				
	
func get_heuristic(cell):
	return 10 * (abs(cell.x - end.x) + abs(cell.y - end.y))
func get_adjacent_cell(cell):
	var cells = []
	if cell.x < grid_w - 1:
		cells.append(get_cell_list(cell.x + 1, cell.y))
	if cell.x > 0:
		cells.append(get_cell_list(cell.x - 1, cell.y))
	if cell.y < grid_h - 1:
		cells.append(get_cell_list(cell.x, cell.y + 1))
	if cell.y > 0:
		cells.append(get_cell_list(cell.x, cell.y - 1))
	return cells
func get_cell_list(x, y):
	return cells[x * grid_h + y]
func update_cell(adj, cell):
	adj.g = cell.g + 10
	adj.h = get_heuristic(adj)
	adj.f = adj.h + adj.g
	adj.parent = cell
func calc_path():
	var path = []
	var cell = end
	if cell == start:
		return path
	while cell.parent != start:
		cell = cell.parent
		path.append(Vector2(cell.x, cell.y))
	path.append(Vector2(start.x, start.y))
	return path