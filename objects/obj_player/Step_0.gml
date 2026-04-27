if keyboard_check_pressed(vk_backspace) room_restart()

// INPUT
var h = keyboard_check(vk_right) - keyboard_check(vk_left)

// movimento horizontal
hspd = h * walkspd

// gravidade
vspd += grv

// pulo (chão)
if (place_meeting(x, y + 1, obj_wall))
{
    if (keyboard_check_pressed(vk_space))
    {
        vspd = jmp
    }
}

// colisão horizontal
if (place_meeting(x + hspd, y, obj_wall))
{
    while (!place_meeting(x + sign(hspd), y, obj_wall))
    {
        x += sign(hspd)
    }
    hspd = 0
}

x += hspd

// colisão vertical
if (place_meeting(x, y + vspd, obj_wall))
{
    while (!place_meeting(x, y + sign(vspd), obj_wall))
    {
        y += sign(vspd)
    }
    vspd = 0
}
y += vspd


//resto segue o anterior
for (var i = 1; i < point_count; i++)
{
	
	var p = points[i]
	var prev = points[i - 1]
	
	var dx = prev._x - p._x
	var dy = prev._y - p._y
	
	var dist = point_distance(p._x, p._y, prev._x, prev._y)
	
	if h == 0// and !position_meeting(p._x, p._y + 1, obj_wall)
	{
		p._y += 16
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




if y_temp_update{
	y_temp = y
}

if h == 0 and place_meeting(x,y_temp+1,obj_wall)
{
	y_temp_update = false
	
	var tip = points[0]
	var last = points[point_count-1]

	//tendência pra cima
	var target_y = y_temp - ((seg_len/1.5) * point_count)
	
	tip._y = lerp(tip._y, target_y, 0.05)
	
	y = tip._y
	
	
	var last_x = x - seg_len*2
	var last_y = y_temp - seg_len/2 * point_count
	
	last._x = lerp(last._x,last_x,0.1)
	last._y = lerp(last._y,last_y,0.1)

	points[0] = tip
	points[point_count-1] = last
}
else{
	y_temp_update = true
}