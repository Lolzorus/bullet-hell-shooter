extends ParallaxBackground

#paralax movement
func _process(delta):
	scroll_offset += Vector2.LEFT * 75 * delta
