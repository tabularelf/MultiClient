/// @description Insert description here
// You can write your code in this editor

var _string = "I am " + string(window_num);
repeat((current_time mod 1000) div 250) _string += ".";

draw_text(32, 32, _string);