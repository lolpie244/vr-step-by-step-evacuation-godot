extends Node

const TIME_PER_TURN: float = 26  # seconds
const ROOM_TEMPERATURE: float = 293  # kelvin
const TILE_SIZE_IN_REAL_LIFE: float = 0.7  # meter
const TILE_SIZE_IN_PX: int = 300  # pixels
const IDLE_FLAME_INCREASE: float = 0.15  # per turn
const IDLE_DURABILITY_DECREASE: float = 0.1  # per turn
const SMOKE_STRENGTH_INSCREASE_RATE: float = 0.2  # per turn

const DEBUG_MODE: bool = false

const METRICS_PUBLISH_FREQUENCY = 1.5  # seconds
const METRICS_SERVER := "https://eucalyptic-overvaluably-kina.ngrok-free.dev"
const SEND_METRICS := false

var fire_spreading_rate: float = 0.5
