extends Control

onready var background = $Background
onready var server = $Server/ServerNameInput
onready var player = $Player/PlayerNameInput
onready var join_button = $Join
onready var music = $Music

var server_name = ""
var player_name = ""
var current_hue = 0

func cycle_colors(delta):
	current_hue += delta * .25
	var color = Color().from_hsv(current_hue, 0.35, 0.5)
	background.set_frame_color(color)

func handle_server(text):
	server_name = text

func handle_player(text):
	player_name = text
	
func handle_join():
	if player_name != "" and server_name != "":
		if server_name in Network.servers:
			print("Joining: ", server_name, " as ", player_name)
			Network.join_server(server_name)
		else:
			print("Creating: ", server_name, " as ", player_name)
			Network.create_server(server_name)

func _ready():
	server.connect("text_changed", self, "handle_server")
	player.connect("text_changed", self, "handle_player")
	join_button.connect("pressed", self, "handle_join")

func _process(delta):
	cycle_colors(delta)
