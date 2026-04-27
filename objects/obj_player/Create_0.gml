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

xx = x
yy = y


y_temp = y
y_temp_update = true

hspd = 0
vspd = 0

walkspd = 4
grv = 0.5
jmp = -8