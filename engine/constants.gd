extends Node

const TIME_PER_TURN: float = 30  # seconds
const ROOM_TEMPERATURE: float = 293  # kelvin
const TILE_SIZE_IN_REAL_LIFE: float = 0.7  # meter
const TILE_SIZE_IN_PX: int = 300  # pixels
const IDLE_EXTINGUISH_RATE: float = 0.25  # per turn
const SMOKE_STRENGTH_INSCREASE_RATE: float = 0.2  # per turn

const DEBUG_MODE: bool = false

const METRICS_FPS_PUBLISH_FREQUENCY = 2.0  # seconds
const METRICS_SERVER := "https://eucalyptic-overvaluably-kina.ngrok-free.dev"
const SEND_METRICS := false
