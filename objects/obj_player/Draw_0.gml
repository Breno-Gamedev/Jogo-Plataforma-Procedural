//corpo
for (var i = 0; i < point_count - 1; i++)
{
	draw_line_width(points[i]._x, points[i]._y,points[i+1]._x, points[i+1]._y,5)
}

var p1 = points[1]
var p2 = points[2]

//orelhas
var _c = #F1A99B

draw_circle_colour(xx - 1.5,yy - 2,1.75,c_white,c_white,false)
draw_circle_colour(xx + 1.5,yy - 2,1.75,c_white,c_white,false)
						
draw_circle_colour(xx - 1.5,yy - 2,1,_c,_c,false)
draw_circle_colour(xx + 1.5,yy - 2,1,_c,_c,false)

//cabeça e juntas
for (var i = 1; i < point_count; i++)
{
	draw_circle(points[i]._x, points[i]._y, 2.5, false)
	draw_circle(points[0]._x, points[0]._y, 3.25, false)
}

//olhos
draw_circle_colour(xx - 1.5,yy - 0.5,0.85,c_black,c_black,false)
draw_circle_colour(xx + 1.5,yy - 0.5,0.85,c_black,c_black,false)

//focinho
draw_circle_colour(xx,yy + 1,0.75,_c,_c,false)

//patinhas frontais
draw_circle_colour(patafe_x, patafe_y, 1.75, c_white, c_white, false) //esquerda
draw_circle_colour(patafd_x, patafd_y, 1.75, c_white, c_white, false) //direita

draw_circle_colour(patafe_x, patafe_y, 1, _c, _c, false) //esquerda
draw_circle_colour(patafd_x, patafd_y, 1, _c, _c, false) //direita
									   
//patinhas traseiras				   
draw_circle_colour(patate_x, patate_y, 1, _c, _c, false) //esquerda
draw_circle_colour(patatd_x, patatd_y, 1, _c, _c, false) //direita


