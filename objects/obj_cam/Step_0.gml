var vw = global.ideal_width  / zoom
var vh = global.ideal_height / zoom

set_camera(0, 0, vw, vh)

var px = 0//obj_player.x - vw /2
var py = 0//obj_player.y - vh /2

camera_set_view_pos(view_camera[0], px, py) 