if keyboard_check_pressed(vk_backspace) room_restart()

#region ---> VARIAVEIS 

var _kright = keyboard_check(vk_right)
var _kleft = keyboard_check(vk_left)
var _kjump = keyboard_check(vk_up)
var _kjump_pressed = keyboard_check_pressed(vk_up)

var _side_wall = place_meeting(x+move_dir,y,obj_wall)

#endregion

#region ---> LOGICA MOVIMENTAÇÃO 

var move = _kright - _kleft
var ground = place_meeting(x, y + 1, obj_wall)

//gravidade e limitando vspd
if estado != "parado"{
	vspd += grav
}
vspd = clamp(vspd,vspd_min,vspd_max)

//definindo direção
if move != 0{
	move_dir = move	
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

#region ---> RAMPA 

var rampei = false //variavel de controle pra saber se estou na rampa 

//mudando o valor de correção da rampa caso esteja ou não no chão
if ground{
	var _val = abs(hspd)
}else{
	var _val = 1.5
}

//se tiver parede a um pixel 
if place_meeting(x+sign(hspd),y,obj_wall)
{ 
	//loop pra checar quantos pixels vazios 
	for (var i = 1; i <= 2 * _val; i++) 
	{ 
		//se tiver um pixel na frente mas tiver vazio acima 
		if !place_meeting(x+sign(hspd),y-i,obj_wall) 
		{ 
			y-=i //subindo 
			x += hspd //andando 
			rampei = true //estou rampando 
			break //quebrando loop 
		} 
	} 
} 

//descendo rampa 
//checando se estou no chão e não tem colisão à frente e abaixo e não estou rampando 
if place_meeting(x,y+abs(vspd),obj_wall) and !place_meeting(x+sign(hspd),y+1,obj_wall) 
{ 
	//loop 
	for (var i = 1; i <=5; i++) 
	{ //se não tiver colisão abaixo mas ainda vai ter colisão um pouco depois... 
		if !place_meeting(x+sign(hspd),y+i,obj_wall) and place_meeting(x+sign(hspd),y+i+1,obj_wall) 
		{ 
			rampei = true //estou na rampa 
			y += i //descendo 
			x += hspd //andando 
			//--ANTI BUG 
			//se eu estiver caindo e não estiver subindo a rampa 
			if vspd > 0 and !place_meeting(x+sign(hspd),y+i,obj_wall) 
			{ 
				//loop que vai repetir de acordo com o tanto que eu andei 
				for (var _i = 0; _i < abs(hspd) + 1; _i++) 
				{ 
					//se não tem chão eu desço 
					if !place_meeting(x, y + 1, obj_wall) y += i
					else break //se tiver chão eu paro o loop 
				} 
			} 
			break 
		} 
	} 
} 
#endregion

#region ---> COLISÃO 
//colisão horizontal
//se eu não estiver rampando eu posso colidir normalmente
if !rampei
{
	if place_meeting(x+hspd,y,obj_wall) and place_meeting(x+hspd, y-1, obj_wall)
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
}


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
		if _kjump{
			estado = "pulando"
			image_index = 0
		}
		
		//caindo
		if !ground and !rampei{
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
		if _kjump{
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
			
			//reset
			pulando = true
		}
		
		//condição de troca
		//caindo
		if vspd > 0 and !_kjump{
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
		
		//coyote
		coyote_timer -= delta_time / 1000000
		//coyote wall
		wall_coyote_timer -= delta_time / 1000000
		
		//condição de troca
		//parado
		if ground{
			coyote_timer = coyote_time //reset
			pulando = false //reset
			estado = "parado"
			image_index = 0
		}
		
		//coyote
		if _kjump_pressed and coyote_timer > 0{
			coyote_timer = coyote_time
			estado = "pulando"	
		}
		
		//wallcoyote
		if _kjump_pressed and wall_coyote_timer > 0{
			estado = "walljump"	
		}
		
		//wallclimb
		if _side_wall and !ground{
			estado = "wallclimb"
			image_index = 0
		}
		break	
	}
	
	case "wallclimb":
	{
		//comportamento
		body_state = "wallclimb"
		
		//alinhando x
		for (var i = 1; i<point_count; i++)
		{
			var p = points[i]
			
			p._x = lerp(p._x,xx,0.2)
		}
		
		//caindo lento
		if vspd > 0{
			vspd_max = 0.75
		}
	
		//resetando coyote
		wall_coyote_timer = wall_coyote_time
		
		//condição de troca
		
		//saindo climb
		if !_side_wall or ground{
			//reset
			vspd_max = dft_vspd_max	
			
			estado = "parado"
			image_index = 0
		}
		
		//walljump
		if _kjump_pressed{
			//reset
			vspd_max = dft_vspd_max	
			
			wall_pulando = true
			estado = "walljump"
			image_index = 0
		}
		break
	}
	
	case "walljump":
	{
		//comportamento
		body_state = "walljump"
		
		//evitando super velocidade
		//diminuindo minha força caso eu esteja andando pro lado contrário da parede
		if move != 0 and sign(hspd) == sign(move_dir){
			//wall_h_power -= 6
		}else{
			//wall_h_power = dft_wall_h_power	
		}
		
		//pulando
		if wall_pulando
		{			
			//mudando limite pra poder pular mais alto
			vspd_min = -wall_jump_power
			
			//reset
			vspd = 0
			
			vspd -= wall_jump_power
			
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
		
		//caindo
		if vspd > 0{
			estado = "caindo"
			image_index = 0
		}
		
		//wallclimb
		if _side_wall and pulando = false{
			estado = "wallclimb"
			image_index = 0
		}
		break
	}
}





#region follow leader
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
		yy = y
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