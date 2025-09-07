@tool
extends XRToolsPickable


func on_poke(event: Variant):
	if event.event_type == XRToolsPointerEvent.Type.ENTERED:
		get_parent().on_poke()
