set_resolution(1920, false, false, false, 1)

zoom = 3

vw = global.ideal_width  / zoom
vh = global.ideal_height / zoom

function move_cam(){
	
	static gridw = vw
	static gridh = vh

	var gridx, gridy;
	
	gridx = (obj_player.x div gridw) * gridw
	gridy = (obj_player.y div gridh) * gridh

	var camx = lerp(camera_get_view_x(view_camera[0]), gridx, 0.1)
	var camy = lerp(camera_get_view_y(view_camera[0]), gridy, 0.1)
	
	show_debug_message(camx)

	camera_set_view_pos(view_camera[0], camx, camy)
	
}