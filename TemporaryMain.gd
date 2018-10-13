extends Node2D

var scenes : Array = [
	"Path Test",
	"Integration Test"
]

func _ready():
	for scene_name in scenes:
		$ItemList.add_item(scene_name)
	
func _on_ItemList_item_activated(index):
	var scene_to_play = $ItemList.get_item_text(index)
	SceneBrowser.change_scene( scene_to_play )