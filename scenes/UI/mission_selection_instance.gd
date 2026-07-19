extends Panel
class_name MissionSelectionInstance

var current_mission_resource : MissionBase
var hidden_labels : Array = []

var name_labels: Array[RichTextLabel] = []
var note_labels: Array[RichTextLabel] = []
var caractere_labels: Array[RichTextLabel] = []

func update_ui(mission_resource):
	current_mission_resource = mission_resource
	%Intitule.text = "La classe de [b]%s[/b] a besoin de vos connaissances en [b]%s[/b] !"%[mission_resource.classname,mission_resource.matiere]
	%MissionInfoContainer.update_objective_label(Global.get_text_for_mission_objective(mission_resource))
	%MissionInfoContainer.update_reward_label("[color=f07c46][b]%s[/b][/color] [img]uid://dfcgw32nv5d56[/img][font_size=12] [i](reste %s cours) [/i] [/font_size]"%[mission_resource.reward,mission_resource.ideal_max_lesson])
	%HeadsContainer.texture = Global.demon_heads[mission_resource.difficulty+1]
	for student_resource in mission_resource.students:
		ManagerList.student_manager.make_labels(student_resource,%StudentInfoContainer,true)
	for label in %StudentInfoContainer.get_children():
		if label in ManagerList.student_manager.name_info_labels:
			label.text.left(-2)
			name_labels.append(label)
		if label in ManagerList.student_manager.note_info_labels:
			hidden_labels.append([label,label.text])
			label.text= "[right][color=326e7d]??/20"
			note_labels.append(label)
		elif label in ManagerList.student_manager.caractere_info_labels:
			hidden_labels.append([label,label.text])
			label.text = "[center][color=326e7d]Inconnu"
			caractere_labels.append(label)



func unhide_label(target_label):
	for label in hidden_labels:
		if label[0] == target_label:
			target_label.text= label[1]

func unhide_all_labels():
	for label in hidden_labels:
		unhide_label(label[0])

func _on_dossier_du_psy_pressed() -> void:
	unhide_all_labels()


func _on_choose_mission_pressed() -> void:
	unhide_all_labels()
	ManagerList.mission_manager.mission_selected(current_mission_resource,name_labels,note_labels,caractere_labels)
