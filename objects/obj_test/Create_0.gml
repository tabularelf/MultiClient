window_num = 0;

call_later(2, time_source_units_seconds, function() {
	window_num = MultiClientGetID();
	show_debug_message(window_num);
	window_set_caption("Window Id: " + string(window_num));
});