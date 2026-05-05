if keyboard_check_pressed(vk_backspace) room_restart()

var seconds = delta_time / 1000000

#region --> INPUTS

key.right	= keyboard_check(vk_right)		|| keyboard_check(ord("D"))
key.left	= keyboard_check(vk_left)		|| keyboard_check(ord("A"))
key.jump	= keyboard_check_pressed(vk_up)	|| keyboard_check_pressed(ord("W"))	|| keyboard_check_pressed(vk_space)

if key.jump{
	input_buff.jump = 0.25
}

#endregion

#region --> CHECKS BASE

var ground = place_meeting(x,y+1,obj_wall)
var move = key.right - key.left

if move != 0{
	move_dir = move	
}

var side_wall = place_meeting(x+move_dir,y,obj_wall)

#endregion

#region --> TIMERS

//coyote
if ground coyote_timer = coyote_time
else coyote_timer -= seconds

//coyote wall
if side_wall wall_coyote_timer = wall_coyote_time
else wall_coyote_timer -= seconds

//input buffer
if input_buff.jump > 0{
	input_buff.jump -= seconds	
	key.jump = true
}else{
	key.jump = false
}

#endregion

#region --> STATE MACHINE

//reset
want_jump = false
want_walljump = false

switch estado
{
	case "parado": case "andando":
	{
		body_state = move == 0 ? "parado" : "andando"
		
		//trocas
		//parado
		if !ground{
			estado = "caindo"	
		}
		
		//pulando
		if key.jump{
			want_jump = true
			estado = "pulando"
		}
		break
	}
	
	case "pulando":
	{
		body_state = "pulando"
		
		//trocas
		//caindo
		if vspd > 0{
			estado = "caindo"	
		}
		
		//wall climb
		if side_wall and !ground{
			estado = "wallclimb"	
		}
		break
	}
	
	case "caindo":
	{
		body_state = "caindo"
		
		//trocas
		//parado
		if ground{
			estado = "parado"	
		}
		
		//coyote
		if key.jump and coyote_timer > 0{
			want_jump = true
			estado = "pulando"
		}
		
		//wall coyote
		if key.jump and wall_coyote_timer > 0{
			want_walljump = true
			estado = "walljump"
		}
		
		//wall climb
		if side_wall{
			estado = "wallclimb"	
		}
		break
	}
	
	case "wallclimb":
	{
		body_state = "wallclimb"
		
		//trocas
		//wall jump
		if key.jump{
			want_walljump = true	
			estado = "walljump"
		}
		
		//caindo
		if !side_wall{
			estado = "caindo"	
		}
		
		//parado
		if ground{
			estado = "parado"
		}
		break
	}
	
	case "walljump":
	{
		body_state = "walljump"
		
		//trocas
		//caindo
		if vspd > 0{
			estado = "caindo"
		}
		
		//wall climb
		if side_wall{
			estado = "wallclimb"	
		}
		break
	}
}

#endregion

#region --> FÍSICA

//movimento horizontal
if move != 0{
	hspd_input = lerp(hspd_input, move_spd * move_dir, acc)
}else{
	hspd_input = lerp(hspd_input, 0, dcc)	
}

//pulo normal
if want_jump{
	vspd = -jump_power
	coyote_timer = 0
	input_buff.jump = 0
}

//wall jump
if want_walljump{
	vspd = -wall_jump_power
	
	var force = wall_h_power
	
	if place_meeting(x+move_dir,y,obj_wall){
		force *= -move_dir
	}else{
		force *= move_dir	
	}
	
	hspd_input = force
	
	wall_coyote_timer = 0
	input_buff.jump = 0
}

//gravidade
vspd += grav

//limites
vspd = clamp(vspd,vspd_min,vspd_max)

//wall slide
if side_wall and vspd > 0{
	vspd = min(vspd,0.75)
}

//velocidade final
hspd = hspd_input + hspd_impulse
hspd_impulse = lerp(hspd_impulse,0,dcc)

#endregion

#region --> COLISÃO

//horizontal
if place_meeting(x+hspd,y,obj_wall)
{
	while !place_meeting(x+sign(hspd),y,obj_wall){
		x += sign(hspd)	
	}
	
	if sign(hspd) == move_dir{
		hspd = 0	
	}
}
x+=hspd

//vertical
if place_meeting(x,y+vspd,obj_wall)
{
	while !place_meeting(x,y+sign(vspd),obj_wall){
		y += sign(vspd)	
	}
	vspd = 0	
}
y+=vspd

#endregion


#region --> FOLLOW LEADER
//resto segue o anterior
for (var i = 1; i < point_count; i++)
{
	
	var p = points[i]
	var prev = points[i - 1]
	
	var dx = prev._x - p._x
	var dy = prev._y - p._y
	
	var dist = point_distance(p._x, p._y, prev._x, prev._y)
	
	if hspd < 0.1 and hspd > -01 and !position_meeting(p._x,p._y+1,obj_wall){
		p._y += 24
	}
	
	if (dist != 0)
	{
		//posição ideal (mantendo distância)
		var target_x = prev._x - (dx / dist) * seg_len
		var target_y = prev._y - (dy / dist) * seg_len
		
		//suavização (ESSENCIAL)
		p._x = lerp(p._x, target_x, 0.9)
		p._y = lerp(p._y, target_y, 0.9)
	}
	
	points[i] = p
}

//colisão
repeat(10)
{
	for (var i = 1; i < point_count; i++)
	{
		var p = points[i]
		var prev = points[i - 1]
	
		if position_meeting(p._x,p._y,obj_wall)
		{
			//tenta resolver separando eixo
			if !position_meeting(prev._x,p._y,obj_wall){
				p._x = lerp(p._x,prev._x,0.2)
			}
			else if !position_meeting(p._x,prev._y,obj_wall){
				p._y = lerp(p._y,prev._y,0.2)
			}
			else{
				p._x = lerp(p._x,prev._x,0.2)
				p._y = lerp(p._y,prev._y,0.2)
			}
		}
		
		points[i] = p
	}
}
#endregion

#region --> BODY STATE

switch body_state
{
	case "parado":
	{
		//ficando pra cima
		var ty = y - seg_len * (point_count-1)
		
		xx = x
		yy = lerp(yy,ty,0.1)
		
		
		//colocando o ultimo ponto pro lado
		var plast = points[point_count-1]
		
		var px = xx - seg_len * move_dir
		var py = y
		
		plast._x = lerp(plast._x,px,0.9)
		plast._y = lerp(plast._y,py,0.1)
		
		points[point_count-1] = plast
		break
	}
	
	case "andando":
	{
		//atualizando x e y
		xx = x
		
		//acumulando tempo
		t += delta_time / 1000000
		var tempo = 0.33 //intervalo da onda (quanto tempo dura um cilco)
		var amplitude = 2 //amplitude da onda (altura)
		var base_y = y - amplitude //base onde o y vai começar
		
		//apliccando animação de onda
		yy = base_y + sin(t * (2*pi / tempo)) * amplitude
		break
	}
	
	case "pulando":
	{
		//atualizando x e y
		xx = x
		yy = y
		break
	}
	
	case "caindo":
	{
		//atualizando x e y
		xx = x
		yy = y	
		break
	}
		
	case "wallclimb":
	{
		//atualizando x e y
		xx = x
		yy = y	
		
		//alinhando x
		for (var i = 1; i<point_count; i++)
		{
			var p = points[i]
			
			p._x = lerp(p._x,xx,0.2)
		}
		break
	}
		
	case "walljump":
	{
		//atualizando x e y
		xx = x
		yy = y	
		break	
	}
}

#endregion