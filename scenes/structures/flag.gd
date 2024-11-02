class_name Flag
extends Node2D

@export var flag_icon: Texture2D:
	set(p_texture):
		flag_icon = p_texture
		icon_sprite.texture = flag_icon

@export_group("Child Nodes")
@export var icon_sprite: Sprite2D
@export var remove_sprite: Sprite2D