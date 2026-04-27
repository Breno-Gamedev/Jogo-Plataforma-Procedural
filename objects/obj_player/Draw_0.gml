draw_self()

for (var i = 0; i < point_count - 1; i++)
{
	draw_line_width(points[i]._x, points[i]._y,points[i+1]._x, points[i+1]._y,4)
}

for (var i = 0; i < point_count; i++)
{
	draw_circle(points[i]._x, points[i]._y, 2, false)
}

//draw_circle_colour(x,y_temp,3,c_red,c_red,false)
//draw_circle_colour(x,y,2,c_lime,c_lime,false)