extends CharacterBody2D

var cell_size;
var tileMap;

func _ready():
	tileMap = get_parent().get_node("TileMapLayer")
	cell_size = tileMap.tile_set.tile_size.x;

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

func _process(delta):
	if Input.is_action_just_pressed("move_left"):
		_angel_move(180)
	if Input.is_action_just_pressed("move_right"):
		_angel_move(0)
	if Input.is_action_just_pressed("move_up"):
		_angel_move(270)
	if Input.is_action_just_pressed("move_down"):
		_angel_move(90)
