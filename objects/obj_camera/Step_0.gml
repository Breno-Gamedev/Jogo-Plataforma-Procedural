//setando tamanho da camera
var vw = global.ideal_width / zoom
var vh = global.ideal_height / zoom

set_camera(0 , 0, vw, vh)

//seguindo o player
if instance_exists(obj_player){
	x = obj_player.x
	y = obj_player.y
}

//grid
gridx = (x div vw) * vw
gridy = (y div vh) * vh

//setando posição e suavização
alvo_x = gridx
alvo_y = gridy

cam_x = lerp(cam_x, alvo_x, cam_lerp)
cam_y = lerp(cam_y, alvo_y, cam_lerp)

camera_set_view_pos(view_camera[0], cam_x, cam_y)