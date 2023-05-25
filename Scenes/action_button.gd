extends Button

var action : Action

func _on_pressed():
	SignalBus.emit_signal('action_chosen', action)
