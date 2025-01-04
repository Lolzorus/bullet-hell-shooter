extends State

## for other type of bullet if needed ##

func enter():
	super.enter()
	owner.alpha = 1.3
	owner.bullet_type = 0
	speed.start()

func transition():
	if can_transition:
		get_parent().change_state("4")
