extends StaticBody3D

signal triggered

func on_poke(event: Variant):
	if event.event_type == XRToolsPointerEvent.Type.ENTERED:
		triggered.emit()
