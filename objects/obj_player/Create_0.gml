//estado
estado = "parado"

//movimentação horizontal
hspd = 0
hspd_input = 0
hspd_impulse = 0

move_dir = 1
move_spd = 3.5

acc = 0.3
dcc = 0.3

//movimentação vertical
vspd = 0
vspd_min = -10
vspd_max = 10

grav = 0.3

//inputs
key={
	right	: 0,
	left	: 0,
	jump	: 0
}

input_buff={
	jump : 0
}

//coyotes
coyote_time = 0.1
coyote_timer = coyote_time

wall_coyote_time = 0.2
wall_coyote_timer = wall_coyote_time

//pulo
want_jump = false
jump_power = 5

//walljump
want_walljump = false
wall_jump_power = 5.2
wall_h_power = 10

//follow leader
body_state = "parado"

t = 0

point_count = 4
seg_len = 7

points = []

for (var i = 0; i < point_count; i++)
{
	points[i] = {
		_x: x - i * seg_len,
		_y: y
	}
}

lerp_val = 0.1

xx = x //alvo x
yy = y //alvo y