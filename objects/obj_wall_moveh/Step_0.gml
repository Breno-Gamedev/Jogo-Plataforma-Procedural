/*switch estado
{
	case "free":
	{
		//comportamento
		pode_mover = false
		
		//troca
		if switch_mode
		{
			if dir = 1{
				estado = "direita"	
			}else{
				estado = "esquerda"	
			}
		}
		else if place_meeting(x+1,y,obj_player) or place_meeting(x-1,y,obj_player) 
		{
			if dir = 1{
				estado = "direita"	
			}else{
				estado = "esquerda"	
			}
		}
		break
	}
	
	case "parado":
	{
		pode_mover = false
		break
	}
	
	case "direita":
	{
		//comportamento
		pode_mover = true
		dir = 1
		tx = xx + dist * dir
		
		//troca
		if x >= tx
		{
			if switch_mode{
				estado = "esquerda"
			}else{
				obj_player.hspd_input += (spd * 2) * dir
				estado = "parado"
			}
		}
		break
	}
	
	case "esquerda":
	{
		//comportamento
		pode_mover = true
		
		if switch_mode{
			spd += incr
		}
		
		dir = -1
		tx = xx + dist * dir
		
		//troca
		if x <= tx
		{
			if switch_mode{
				estado = "direita"
			}else{
				obj_player.hspd_impulse = (spd * 1.5) * dir
				estado = "parado"
			}
		}
		break
	}
}

if pode_mover{
	x += spd * dir
}
hspd = x - xprevious