extends Node2D

func _ready():
	for scene_name in SceneBrowser.scene_map.keys():
		$ItemList.add_item(scene_name)
	
func _on_ItemList_item_activated(index):
	var scene_to_play = $ItemList.get_item_text(index)
	SceneBrowser.change_scene( scene_to_play )