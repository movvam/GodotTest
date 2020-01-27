extends Node

# The script for networking
var servers = []
var players = []

var player_type = {
	"server_name": "",
	"player_name": ""
}

func create_server(server_name):
	# For now, just load the test level
	get_tree().change_scene("res://scenes/World.tscn")
	
func join_server(server_name):
	pass