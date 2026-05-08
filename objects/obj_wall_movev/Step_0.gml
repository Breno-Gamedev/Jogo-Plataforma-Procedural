switch estado
{
	case "free":
	{
		//comportamento
		pode_mover = false
		
		//troca
		if switch_mode
		{
			if dir = 1{
				estado = "descendo"	
			}else{
				estado = "subindo"	
			}
		}
		else if place_meeting(x,y-1,obj_player)
		{
			if dir = 1{
				estado = "descendo"	
			}else{
				estado = "subindo"	
			}
		}
		break
	}
	
	case "parado":
	{
		pode_mover = false
		break
	}
	
	case "descendo":
	{
		//comportamento
		pode_mover = true
		dir = 1
		ty = yy + dist * dir
		
		//troca
		if y >= ty
		{
			if switch_mode{
				estado = "subindo"
			}else{
				estado = "parado"
			}
		}
		break
	}
	
	case "subindo":
	{
		//comportamento
		pode_mover = true
		
		if switch_mode{
			spd += incr
		}
		
		dir = -1
		ty = yy + dist * dir
		
		//troca
		if y <= ty
		{
			if switch_mode{
				estado = "descendo"
			}else{
				obj_player.vspd = -spd * 1.5
				estado = "parado"
			}
		}
		break
	}
}

if pode_mover{
	y += spd * dir
}
vspd = y - yprevious