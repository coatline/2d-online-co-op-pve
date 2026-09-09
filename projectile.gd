extends Entity
class_name Projectile

@export var damage_dealer: DamageDealer
@export var hit_box: Hitbox

var lifetime: float
var force: float
var damage: int

func apply_state(entity_state: EntityState) -> void:
	super(entity_state)
	var projectile_state: ProjectileState = entity_state as ProjectileState
	damage_dealer.setup(EntityManager.I.get_entity(projectile_state.source_entity_id), 10, projectile_state.force)
	damage_dealer.source_entity = EntityManager.I.get_entity(projectile_state.source_entity_id)
	force = projectile_state.force

func get_current_state() -> EntityState:
	var proj_state: ProjectileState = super() as ProjectileState
	proj_state.source_entity_id = damage_dealer.source_entity.id
	proj_state.force = force
	proj_state.damage = damage
	proj_state.lifetime = lifetime
	return proj_state

func _ready() -> void:
	hit_box.damaged_entity.connect(queue_free)
	lifetime = 1

func _physics_process(delta: float) -> void:
	global_position += force * delta * transform.x
	lifetime -= delta

	if lifetime <= 0:
		queue_free()
	#global_position += global_transform.x * speed * delta

# func _exit_tree() -> void:
	