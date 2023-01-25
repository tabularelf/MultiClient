window_num = MultiClientGetID();
window_set_caption(window_num);

var _i = 0;
repeat(parameter_count()) {
	show_debug_message(parameter_string(_i));
	++_i;
}