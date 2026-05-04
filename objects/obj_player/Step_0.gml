if keyboard_check_pressed(vk_backspace) room_restart()

#region ---> VARIAVEIS 

var _side_wall = place_meeting(x+1,y,obj_wall) || place_meeting(x-1,y,obj_wall)
var ground = place_meeting(x, y + 1, obj_wall)

#endregion

//coyote
if ground{
	coyote_timer = coyote_time
}else{
	coyote_timer -= delta_time / 1000000
}

if _side_wall{
	wall_coyote_timer = wall_coyote_time	
}else{
	wall_coyote_timer -= delta_time / 1000000
}

#region ---> INPUTS
//direita
if keyboard_check(vk_right) or keyboard_check(ord("D")){
	keys.right = true
}else{
	keys.right = false	
}

//esquerda
if keyboard_check(vk_left) or keyboard_check(ord("A")){
	keys.left = true
}else{
	keys.left = false	
}

//pulo
if keyboard_check(vk_up) or keyboard_check(ord("W")) or keyboard_check(vk_space){
	keys.jump = true
}else{
	keys.jump = false	
}

//pulo pressed
if keyboard_check_pressed(vk_up) or keyboard_check_pressed(ord("W")) or keyboard_check_pressed(vk_space){
	input_buff.jump_pressed = 0.25
}
#endregion

#region ---> INPUT BUFF

//pulo pressed
if input_buff.jump_pressed > 0{
	input_buff.jump_pressed -= delta_time / 1000000
	keys.jump_pressed = true
}else{
	keys.jump_pressed = false
}

#endregion

#region ---> LOGICA MOVIMENTAÇÃO 

var move = keys.right - keys.left

//gravidade e limitando vspd
if estado != "parado"{
	vspd += grav
}
vspd = clamp(vspd,vspd_min,vspd_max)

//definindo direção
if move != 0{
	move_dir = move
	input_buff.right = 0
	input_buff.left = 0
}

//se eu apertar pra mover eu adiciono valor ao hspd_input
if move != 0{
	hspd_input = lerp(hspd_input,move_spd * move_dir,acc)	
}else{
	hspd_input = lerp(hspd_input,0,dcc)
}

show_debug_message("move: " + string(move_dir))
show_debug_message("hspd_input: " + string(hspd_input))

//definindo o hspd
hspd = hspd_input + hspd_impulse

//resetando hspd_impulse
hspd_impulse = lerp(hspd_impulse,0,dcc)

#endregion

#region ---> COLISÃO 
//colisão horizontal
if place_meeting(x+hspd,y,obj_wall)// and place_meeting(x+hspd, y-1, obj_wall)
{
		
	//colisão perfeita
	while !place_meeting(x+sign(hspd),y,obj_wall)
	{
		x = x + sign(hspd)
	}
	//só zera se eu estiver indo na direção da parede (evitar bug de walljump)
	if sign(hspd) == move_dir{
		hspd = 0 //se eu colidir não ando mais
	}
}

x+=hspd


//colisão vertical
if place_meeting(x,y+vspd,obj_wall)
{
	//colisão perfeita
	while !place_meeting(x,y+sign(vspd),obj_wall)
	{
		y = y + sign(vspd)
	}
	vspd = 0 //parando
}

y+=vspd //setando y = velocidade vertical
#endregion


switch estado
{
	case "parado":
	{
		//comportamento
		body_state = "parado"
		
		//resetando para segurança
		vspd_min = dft_vspd_min	
		
		//resetando variaveis
		pulo_alto = true
		
		//condição de troca
		//andando
		if move != 0{
			estado = "andando"
			image_index = 0
		}
		
		//pulando
		if keys.jump or keys.jump_pressed{
			estado = "pulando"
			image_index = 0
		}
		
		//caindo
		if !ground{
			estado = "caindo"
			image_index = 0
		}
		break
	}
	
	case "andando":
	{
		//comportamento
		body_state = "andando"
		
		//condição de troca
		//parado
		if move == 0{
			estado = "parado"
			image_index = 0
		}
		
		//pulando
		if keys.jump or keys.jump_pressed{
			estado = "pulando"
			image_index = 0
		}
		
		//caindo
		if !ground{
			estado = "caindo"
			image_index = 0
		}
		break
	}
	
	case "pulando":
	{
		//comportamento		
		body_state = "pulando"
		
		if !pulando
		{
			//reset por segurança
			vspd = 0
			
			//pulando
			vspd-=jump_power
			
			coyote_timer = 0
			
			//resetando buff
			input_buff.jump_pressed = 0	
			keys.jump_pressed = false
			
			//reset
			pulando = true
		}
		
		//condição de troca
		//caindo
		if vspd > 0{
			estado = "caindo"
			image_index = 0
		}
		
		//parado
		if ground{
			pulando = false //reset
			
			estado = "parado"
			image_index = 0
		}
		
		//wallclimb
		if _side_wall and !ground{
			estado = "wallclimb"
			image_index = 0
		}
		break
	}
	
	case "caindo":
	{
		//comportamento
		body_state = "caindo"
		
		//condição de troca
		//parado
		if ground{
			coyote_timer = coyote_time //reset
			pulando = false //reset
			estado = "parado"
			image_index = 0
		}
		
		//wall coyote
		if keys.jump_pressed and wall_coyote_timer > 0{
			wall_coyote_timer = 0
			wall_pulando = true
			estado = "walljump"	
		}
		
		//coyote
		if keys.jump_pressed and coyote_timer > 0{
			coyote_timer = coyote_time
			estado = "pulando"	
		}
		
		//wallclimb
		if _side_wall{
			estado = "wallclimb"
			image_index = 0
		}
		break	
	}
	
	case "wallclimb":
	{
		//comportamento
		body_state = "wallclimb"
		
		//caindo lento
		if vspd > 0{
			vspd_max = 0.75
		}
	
		//resetando coyote
		wall_coyote_timer = wall_coyote_time
		
		//condição de troca
		//walljump
		if keys.jump_pressed{
			//reset
			vspd_max = dft_vspd_max	
			
			wall_coyote_timer = wall_coyote_time
			
			wall_pulando = true
			estado = "walljump"
			image_index = 0
		}
		
		//saindo climb
		else if !_side_wall and vspd > 0{
			//reset
			vspd_max = dft_vspd_max	
			
			estado = "caindo"
			image_index = 0
		}
		
		if ground{
			estado = "parado"
		}
		break
	}
	
	case "walljump":
	{
		//comportamento
		body_state = "walljump"
		
		//evitando super velocidade
		//diminuindo minha força caso eu esteja andando pro lado contrário da parede
		//if move != 0 and sign(hspd) == sign(move_dir){
		//	//wall_h_power -= 6
		//}else{
		//	//wall_h_power = dft_wall_h_power	
		//}
		
		wall_coyote_timer = 0
		
		//pulando
		if wall_pulando
		{
			wall_state_exit = 0.1
			
			//mudando limite pra poder pular mais alto
			vspd_min = -wall_jump_power
			
			//reset
			vspd = 0
			
			vspd -= wall_jump_power
			
			//resetando buffs
			input_buff.jump_pressed = 0	
			keys.jump_pressed = false
			
			//antibug de inverter direção sem precisar
			//invertendo a direção da força caso eu esteja encostado na parede/não me movendo
			if place_meeting(x+sign(move_dir),y,obj_wall){
				var _force = wall_h_power * -move_dir
			}
			//não invertendo caso eu esteja apertando pro lado
			else{
				var _force = wall_h_power * move_dir
			}
			//aplicando força
			hspd_input = _force

			//reset
			wall_pulando = false
		}
		else
		{
			//resetando
			vspd_min = dft_vspd_min	
		}
		
		
		if wall_state_exit < 0
		{
			//caindo
			if vspd > 0{
				estado = "caindo"
				image_index = 0
			}
		
			//wallclimb
			if _side_wall{
				estado = "wallclimb"
				image_index = 0
			}
		}else{
			wall_state_exit -= delta_time / 1000000
		}
		break
	}
}


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


//state machine
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