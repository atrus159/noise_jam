extends CharacterBody2D

var cell_size;
var tileMap;
var turn;
var timer;

func _ready():
	tileMap = get_parent().get_node("TileMapLayer")
	cell_size = tileMap.tile_set.tile_size.x;
	turn = true
	timer = 1
	randomize()

func _check_tile_map_pos(x: float, y: float) -> bool:
	var cell = tileMap.local_to_map(tileMap.to_local(Vector2(x,y)))
	var tile_data = tileMap.get_cell_tile_data(cell)
	return tile_data != null

func _angel_move(dir: float) -> bool:
	var curX = position.x
	var curY = position.y
	var xMod = cell_size * cos(deg_to_rad(dir))
	var yMod = cell_size * sin(deg_to_rad(dir))
	while !_check_tile_map_pos(curX + xMod, curY + yMod):
		curX += xMod
		curY += yMod
	if position.x == curX and position.y == curY:
		return false
	position.x = curX
	position.y = curY
	return true
	
func _human_move():
	var choises = [0,90,180,270]
	var dir = choises[randi() % 4]
	var xMod = cell_size * cos(deg_to_rad(dir))
	var yMod = cell_size * sin(deg_to_rad(dir))
	while _check_tile_map_pos(position.x + xMod, position.y + yMod):
		dir = choises[randi() % 4]
		xMod = cell_size * cos(deg_to_rad(dir))
		yMod = cell_size * sin(deg_to_rad(dir))
	position.x += xMod
	position.y += yMod

func _process(delta):
	if(turn):
		var succeded = false
		if Input.is_action_just_pressed("move_left"):
			succeded = _angel_move(180)
		if Input.is_action_just_pressed("move_right"):
			succeded = _angel_move(0)
		if Input.is_action_just_pressed("move_up"):
			succeded = _angel_move(270)
		if Input.is_action_just_pressed("move_down"):
			succeded = _angel_move(90)
		if succeded:
			turn = false
			timer = 1
	else:
		timer -= delta
		if timer <= 0:
			_human_move()
			turn = true
		
			
