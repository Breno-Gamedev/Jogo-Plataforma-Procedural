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

point_count = 3
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

follow_grav = 24


//patas frontais
//direita
patafd_x = 0
patafd_y = 0

//esquerda
patafe_x = 0
patafe_y = 0

//patas traseiras
//direita
patatd_x = 0
patatd_y = 0

//esquerda
patate_x = 0
patate_y = 0


//patas presset
function patas_parado(){
		var p1 = points[1]
		var p2 = points[2]
		
		//-frontais
		//esquerda
		patafe_x = p1._x - 1.5
		patafe_y = p1._y + 1
		
		//direita
		patafd_x = p1._x + 1.5
		patafd_y = p1._y + 1
		
		
		//-tarseiras
		//esquerda
		patate_x = p2._x - 1.5
		patate_y = p2._y
		
		//direita
		patatd_x = p2._x + 1.5
		patatd_y = p2._y
}

function patas_andando(){
		var p1 = points[1]
		var p2 = points[2]
		
		//-frontais
		var x1 = (p1._x + 9 * move_dir) + sin(t * (2 * pi / 0.4)) * 2
		var y1 = (y+2) + sin(t * (2 * pi / 0.33)) * 2
		
		//esquerda
		patafe_x = x1
		patafe_y = y1
		
		//direita
		patafd_x = x1 - 2
		patafd_y = y1
		
		
		//-tarseiras
		var x2 = (p2._x + 6 * move_dir) + sin(t * (2 * pi / 0.4)) * 2
		var y2 = p2._y + 3
		
		//esquerda
		patate_x = x2
		patate_y = y2
		
		//direita
		patatd_x = x2 - 2
		patatd_y = y2
}

function patas_caindo(){
		var p1 = points[1]
		var p2 = points[2]
		
		//-frontais
		if abs(hspd) > 0.1{
			var x1 = p1._x + 9 * move_dir
		}else{
			var x1 = p1._x
		}
		var y1 = yy + 2
		
		//esquerda
		patafe_x = x1
		patafe_y = y1
		
		//direita
		patafd_x = x1
		patafd_y = y1
		
		
		//-tarseiras
		if abs(hspd) > 0.1{
			var x2 = p2._x + 8 * move_dir
		}else{
			var x2 = p2._x
		}
		var y2 = p1._y + 2
		
		//esquerda
		patate_x = x2 
		patate_y = y2
		
		//direita
		patatd_x = x2
		patatd_y = y2	
}