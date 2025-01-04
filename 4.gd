extends State

## for other type of bullet if needed ##
func enter():
	super.enter()
	owner.alpha = 3
	owner.bullet_type = 0

func transition():
	if can_transition:
		get_parent().change_state("5")
