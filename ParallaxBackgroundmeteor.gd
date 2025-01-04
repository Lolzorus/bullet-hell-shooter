extends ParallaxLayer

#trash
func _process(delta):
	scroll_offset += Vector2.DOWN * 75 * delta
