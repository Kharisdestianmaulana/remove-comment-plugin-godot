@tool
extends EditorPlugin

var clean_button: Button

func _enter_tree():
	clean_button = Button.new()
	clean_button.text = "Hapus Komentar"
	clean_button.tooltip_text = "Hapus komentar di kode yang di-select (Ctrl + Shift + K)"
	clean_button.focus_mode = Control.FOCUS_NONE 
	
	clean_button.pressed.connect(_remove_comments_from_selection)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, clean_button)

func _exit_tree():
	if is_instance_valid(clean_button):
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, clean_button)
		clean_button.queue_free()

func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.physical_keycode == KEY_K and event.ctrl_pressed and event.shift_pressed:
			_remove_comments_from_selection()
			get_viewport().set_input_as_handled()

func _remove_comments_from_selection():
	var script_editor = EditorInterface.get_script_editor()
	var current_editor = script_editor.get_current_editor()
	
	if current_editor == null: 
		return
	
	var code_edit = current_editor.get_base_editor()
	if not code_edit is CodeEdit: 
		return

	if not code_edit.has_selection():
		print("Gagal: Kamu belum nge-blok (select) kodenya!")
		return
		
	code_edit.begin_complex_operation()
	
	var selected_text = code_edit.get_selected_text()
	var lines = selected_text.split("\n")
	var new_lines = []
	
	for line in lines:
		var comment_pos = _find_comment_pos(line)
		if comment_pos != -1:
			# Ambil teks sebelum komentar dan buang spasi di kanannya
			var clean_line = line.substr(0, comment_pos).strip_edges(false, true)
			
			# LAKUKAN PENGECEKAN:
			# Kalau setelah dihapus ternyata barisnya masih ada isinya (bukan cuma spasi/tab kosong),
			# baru kita masukkan ke dalam daftar. Kalau kosong, BUANG sekalian barisnya!
			if clean_line.strip_edges() != "":
				new_lines.append(clean_line)
		else:
			# Kalau dari awal memang baris kosong (nggak ada komentarnya), tetap pertahankan
			# supaya jarak antar fungsi (func) yang sengaja kamu buat nggak ikut rusak.
			new_lines.append(line)
			
	var new_text = "\n".join(new_lines)
	
	code_edit.delete_selection() 
	code_edit.insert_text_at_caret(new_text)
	
	code_edit.end_complex_operation()

func _find_comment_pos(line: String) -> int:
	var in_string = false
	var string_char = ""
	for i in range(line.length()):
		var c = line[i]
		if c == '"' or c == "'":
			if not in_string:
				in_string = true
				string_char = c
			elif string_char == c:
				in_string = false
		elif c == '#' and not in_string:
			return i
	return -1
