move_spd = 3.5
move_dir = 1 //direção do movimento
acc = 0.3
dcc = 0.3

hspd = 0 //velocidade horizontal real
hspd_input = 0 //velocidade horizontal com base nas teclas
hspd_impulse = 0 //velocidade horizontal com base em impulsos exteriores

vspd = 0
dft_vspd_min = -10 //velocidade vertical minima padrão
dft_vspd_max =  10 //velocidade vertical maxima padrão

vspd_min = dft_vspd_min //vspd minimo real
vspd_max = dft_vspd_max //vspd maximo real

grav = 0.3

//state machine
estado = "parado" //estate machine


//pulo
pulando = false //variavel de controle do pulo
jump_power = 5 //força do pulo

coyote_time = 0.1 //tempo em segundos de tolerância do coyote jump
coyote_timer = coyote_time //timer do coyote jump

//walljump
wall_coyote_time = 0.2 //tempo em segundos de tolerância do coyote jump para o wallclimb
wall_coyote_timer = coyote_time //timer do coyote jump para wallclimb

wall_pulando = false //controle do pulo do wallump
wall_jump_power = 5.2 //força do pulo wall

dft_wall_h_power = 10 //força padrão horizontal do walljump
wall_h_power = dft_wall_h_power //força horizontal do walljump

wall_state_exit = 0.1


//inputs
keys={
	right : 0,
	left : 0,
	jump : 0,
	jump_pressed : 0
}

//input buff
input_buff={
	right : 0,
	left : 0,
	jump : 0,
	jump_pressed : 0
}

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

xx = x //alvo x
yy = y //alvo y