%include('header_init.tpl', heading='Problem Statement')

<h2>List of current problems:</h2>
<table class="table table-striped">
    <thead>
        <tr>
            <th style='width:50px;'>State</th>
			<th>Type</th>
            <th>Problem Discription</th>
            <th>Unit</th>
            <th>Values</th>
            <th>Method</th>
            <!--<th>Mode</th>-->
            <th>Edit</th>
            <th><button type="button" class="btn btn-danger del_simu"><img src='/static/img/delete.ico' style='width:16px;'/></button></th>
        </tr>
    </thead>
    <tbody id="table_attributes">
    </tbody>
</table>

<br />

<div id="add_problem" style="width:50%;margin-left:25%;margin-bottom:25px;">
    <h2> Add a new problem: </h2>
	
	<div id="button_type" style="text-align:center;">
		<button type="button" class="btn btn-default btn-lg" id="button_discret">Discret</button>
		<button type="button" class="btn btn-default btn-lg" id="button_continuous">Continuous</button>
	</div>
	
    <!------------ FORM FOR A DISCRET PROBLEM ------------>
	<div id="form_discret">
		<div class="form-group">
			<label for="problem_discret">I would like to know the probability of...:</label>
			<input type="text" class="form-control" id="problem_discret" placeholder="Example: The sucess of my company in France">
		</div>

		<!--<div class="form-group">
			<label for="att_unit_quanti">Unit:</label>
			<input type="text" class="form-control" id="att_unit_quanti" placeholder="Unit">
		</div>
		<div class="form-group">
			<label for="att_value_min_quanti">Min value:</label>
			<input type="text" class="form-control" id="att_value_min_quanti" placeholder="Value">
		</div>
		<div class="form-group">
			<label for="att_value_max_quanti">Max value:</label>
			<input type="text" class="form-control" id="att_value_max_quanti" placeholder="Value">
		</div>-->
		
		<div class="form-group">
			<label for="mathod_discret">Method:</label>
			<select class="form-control" id="method_discret">
				<option value="PW">Probability Wheel</option>
				<option value="PARIS">Choice between bets</option>
				<option value="LE">Lottery Equivalence</option>
			</select>
		</div>
		<!--<div class="checkbox">
			<label><input name="mode" type="checkbox" id="att_mode_quanti" placeholder="Mode"> The min value is preferred (decreasing utility function)</label>
		</div>-->

		<button type="submit" class="btn btn-success" id="submit_discret">Submit</button>
	</div>
	
	<!------------ FORM FOR A CONTINUOUS PROBLEM ------------>
	<div id="form_continuous">
		<div class="form-group">
			<label for="problem_continuous">I would like to assess the probability distribuition of...:</label>
			<input type="text" class="form-control" id="problem_continuous" placeholder="Example: the profit of my company in 2020">
		</div>
		
		<div class="form-group">
			<label for="unit_continuous">Unit:</label>
			<input type="text" class="form-control" id="unit_continuous" placeholder="Exemples: Euros, Dollars, Bitcoins..">
		</div>
		<div class="form-group">
			<label for="min_value_continuous">Minimum value:</label>
			<input type="text" class="form-control" id="min_value_continuous" placeholder="Value">
		</div>
		<div class="form-group">
			<label for="max_value_continuous">Maximum value:</label>
			<input type="text" class="form-control" id="max_value_continuous" placeholder="Value">
		</div>-->
		
		<!--<h3> Please rank the values by order of preference: </h3>
		<div class="form-group">
			<label for="att_value_min_quali">Least preferred value:</label>
			<input type="text" class="form-control" id="att_value_min_quali" placeholder="Worst value">
		</div>
		<div class="form-group">
			<label for="att_value_med_quali">Intermediate value(s):</label>
				<input type="button" class="btn btn-default" id="add_value_med_quali" value="Add an item"/>   
				<input type="button" class="btn btn-default" id="del_value_med_quali" value="Delete last item"/>
				<ol id="list_med_values_quali">
					<li class="col-auto"><input type="text" class="form-control col-auto" id="att_value_med_quali_1" placeholder='Intermediate Value 1'/></li>
				</ol>
		</div>
		<div class="form-group">
			<label for="att_value_max_quali">Most preferred value:</label>
			<input type="text" class="form-control" id="att_value_max_quali" placeholder="Best value">
		</div>-->
			
		<button type="submit" class="btn btn-success" id="submit_quali">Submit</button>
	</div>
	
	
</div>

%include('header_end.tpl')
%include('js.tpl')

<script>
//First we hide the attributes creation forms, and we highlight the "Manage" tab
$("#form_discret").hide();
$("#form_continuous").hide();
$('li.manage').addClass("active");
/////////////////////////////////////////////////////////////////////////////////////////
// Fonctions pour ajouter/supprimer des zones de texte pour les valeurs intermédiaires //
/////////////////////////////////////////////////////////////////////////////////////////
var list_med_values = document.getElementById('list_med_values_quali'),
	lists = list_med_values.getElementsByTagName('li'),
	add_value_med = document.getElementById('add_value_med_quali'),
	del_value_med = document.getElementById('del_value_med_quali');
/// Defines what happens when clicking on the "Add an item" button
add_value_med.addEventListener('click', function() {
	var longueur = lists.length;
	var new_item = document.createElement('li');
	new_item.innerHTML = "<input type='text' class='form-control' id='att_value_med_quali_"+ String(longueur+1) +"' placeholder='Intermediate Value " + String(longueur+1) +"'/>";
	lists[longueur-1].parentNode.appendChild(new_item);
});
/// Defines what happens when clicking on the "Delete last item" button
del_value_med.addEventListener('click', function() {
	var longueur = lists.length;
	if (longueur!=1){
		lists[longueur-1].parentNode.removeChild(lists[longueur-1]);
	} else {
		alert("Please put at least one medium value for the attribute "+$('#att_name').val());
	};
});
/// Function that manages the influence of the "button_type" buttons (Continuous/Discret) (just the design : green/white)
function update_method_button(type){
	var list_types = ["discret", "continuous"];
	
	for(var i=0; i<list_types.length; i++){
		if(type==list_types[i]){
			$("#button_"+list_types[i]).removeClass('btn-default');
			$("#button_"+list_types[i]).addClass('btn-success');
		} else {
			$("#button_"+list_types[i]).removeClass('btn-success');
			$("#button_"+list_types[i]).addClass('btn-default');
		}
	}
}
/// Action from Discret/Continuous button
$(function() {
	///  ACTION FROM BUTTON DISCRET
	$("#button_discret").click(function () {
		update_method_button("discret"); //update the active type of new attribute
		$("#form_continuous").fadeOut(500);
		$("#form_discret").fadeIn(500);
		window.scrollBy(0, 500);
	});
	///  ACTION FROM BUTTON CONTINUOUS
	$("#button_continuous").click(function () {
		update_method_button("continuous"); //update the active type of new attribute
		$("#form_discret").fadeOut(500);
		$("#form_continuous").fadeIn(500);
		window.scrollBy(0, 500);
	});
});
$(function() {
	var assess_session = JSON.parse(localStorage.getItem("assess_session")),
		edit_mode = false,
		edited_attribute=0;
		
	// When you click on the RED BIN // Delete the wole session
	$('.del_simu').click(function() {
		if (confirm("You are about to delete all the attributes and their assessments.\nAre you sure ?") == false) {
			return
		};
		localStorage.removeItem("assess_session");
		window.location.reload();
	});
	
	// Create a new session if there is no existing one yet
	if (!assess_session) {
		assess_session = {
			"attributes": [],
			"k_calculus": [{
				"method": "multiplicative",
				"active": "false",
				"k": [],
				"GK": null,
				"GU": null
			}, {
				"method": "multilinear",
				"active": "false",
				"k": [],
				"GK": null,
				"GU": null
			}],
			"settings": {
				"decimals_equations": 3,
				"decimals_dpl": 8,
				"proba_ce": 0.30,
				"proba_le": 0.30,
				"language": "english",
				"display": "trees"
			}
		};
		localStorage.setItem("assess_session", JSON.stringify(assess_session));
	};
	///////////////////////////////////////////////////////////////////////
	//////////////////////         FUNCTIONS         //////////////////////
	///////////////////////////////////////////////////////////////////////
	
	// Function to know if "name" is an existing attribute of the current session
	function isAttribute(name) {
		for (var i = 0; i < assess_session.attributes.length; i++) {
			if (assess_session.attributes[i].name == name) {
				return true;
			};
		};
		return false;
	};
	
	// Function to know if at least one element of val_list is empty
	function isOneValueOfTheListEmpty(val_list){
		var list_len = val_list.length;
		for (var i=0; i<list_len; i++) {
			if(val_list[i] == ""){return true}
		};
		return false;
	};
	
	// Function to know if each typed value is different from the others
	function areAllValuesDifferent(val_list, val_min, val_max){
		var list_len = val_list.length;
		for (var i=0; i<list_len; i++) {
			if (val_list[i] == val_min || val_list[i] == val_max){
				return false;
			};
			for (var j=0; j<list_len; j++) {
				if(val_list[i] == val_list[j] && i!=j){
					return false;
				}
			}
		};
		return true;
	};
	
	// Function to check if there is an underscore in the typed values
	function isThereUnderscore(val_list, val_min, val_max){
		var list_len = val_list.length;
		for (var i=0; i<list_len; i++) {
			if (val_list[i].search("_")!=-1){
				return false;
			};
		};
		if (val_min.search("_")!=-1 || val_max.search("_")!=-1){
			return false;
		};
		return true;
	};
	
	// Function to check if there is a hyphen in the typed values
	function isThereHyphen(val_list, val_min, val_max){
		var list_len = val_list.length;
		for (var i=0; i<list_len; i++) {
			if (val_list[i].search("-")!=-1){
				return false;
			};
		};
		if (val_min.search("-")!=-1 || val_max.search("-")!=-1){
			return false;
		};
		return true;
	};
	
	// Function to check if there is a blank space in the typed values
	function isThereBlankSpace(val_list, val_min, val_max){
		var list_len = val_list.length;
		for (var i=0; i<list_len; i++) {
			if (val_list[i].search(" ")!=-1){
				return false;
			};
		};
		if (val_min.search(" ")!=-1 || val_max.search(" ")!=-1){
			return false;
		};
		return true;
	};
	// Function to change the property of a checked box
	function checked_button_clicked(element) {
		var assess_session = JSON.parse(localStorage.getItem("assess_session")),
			checked = $(element).prop("checked"),
			i = $(element).val();
		assess_session.attributes[i].checked = checked; // we modify the propriety
		localStorage.setItem("assess_session", JSON.stringify(assess_session)); // we update the assess_session storage
	}
	// Function to update the attributes table
	function sync_table() {
		$('#table_attributes').empty();
		if (assess_session) {
			for (var i = 0; i < assess_session.attributes.length; i++) {
				var attribute = assess_session.attributes[i];
				
				var text_table = "<tr>"+
					'<td><input type="checkbox" id="checkbox_' + i + '" value="' + i + '" name="' + attribute.name + '" '+(attribute.checked ? "checked" : "")+'></td>'+
					'<td>' + attribute.type + '</td>'+
					'<td>' + attribute.name + '</td>'+
					'<td>' + attribute.unit + '</td>';
					
				if (attribute.type == "Quantitative") {
					text_table += '<td>[' + attribute.val_min + ',' + attribute.val_max + ']</td>';
				} 
				else if (attribute.type == "Qualitative") {
					text_table += '<td><table><tr><td>' + attribute.val_min + '</td></tr>';
					for (var ii=0, len=attribute.val_med.length; ii<len; ii++){
						text_table += '<tr><td>' + attribute.val_med[ii] + '</td></tr>';
					};
					text_table += '<tr><td>' + attribute.val_max + '</td></tr></table>';
				};
				
				text_table += '<td>' + attribute.method + '</td>'+
					'<td>' + attribute.mode + '</td>'+
					'<td><button type="button" id="edit_' + i + '" class="btn btn-default btn-xs">Edit</button></td>'+
					'<td><button type="button" class="btn btn-default" id="deleteK'+i+'"><img src="/static/img/delete.ico" style="width:16px"/></button></td></tr>';
								
				$('#table_attributes').append(text_table);
				//We define the action when we click on the State check input
				$('#checkbox_' + i).click(function() {
					checked_button_clicked($(this))
				});
				
				// Defines what happens when you click on a Delete button
				(function(_i) {
					$('#deleteK' + _i).click(function() {
						if (confirm("You are about to delete the attribute "+assess_session.attributes[_i].name+".\nAre you sure ?") == false) {
							return
						};
						assess_session.attributes.splice(_i, 1);
						localStorage.setItem("assess_session", JSON.stringify(assess_session));// backup local
						window.location.reload();//refresh the page
					});
				})(i);
				// Defines what happend when you click on the Edit button
				(function(_i) {
					$('#edit_' + _i).click(function() {
						edit_mode=true;
						edited_attribute=_i;
						var attribute_edit = assess_session.attributes[_i];
						
						$('#add_attribute h2').text("Edit attribute "+attribute_edit.name);
						
						if (attribute_edit.type == "Quantitative") {
							update_method_button("Quantitative"); //update the active type of attribute
							$("#form_quali").fadeOut(500);
							$("#form_quanti").fadeIn(500);
							
							// Rewrites the existing values inside the textboxes
							$('#att_name_quanti').val(attribute_edit.name);
							$('#att_unit_quanti').val(attribute_edit.unit);
							$('#att_value_min_quanti').val(attribute_edit.val_min);
							$('#att_value_max_quanti').val(attribute_edit.val_max);
							$('#att_method_quanti option[value='+attribute_edit.method+']').prop('selected', true);
							$('#att_mode_quanti').prop('checked', (attribute_edit.mode=="Normal" ? false : true));
						} 
						else if (attribute_edit.type == "Qualitative") {
							update_method_button("Qualitative"); //update the active type of attribute
							$("#form_quanti").fadeOut(500);
							$("#form_quali").fadeIn(500);
							
							$('#att_name_quali').val(attribute_edit.name);
							$('#att_value_min_quali').val(attribute_edit.val_min);
							$('#att_value_med_quali_1').val(attribute_edit.val_med[0]);
							
							for (var ii=2, len=attribute_edit.val_med.length; ii<len+1; ii++) {
								var longueur = lists.length,
									new_item = document.createElement('li');
								new_item.innerHTML = "<input type='text' class='form-control' id='att_value_med_quali_"+ String(longueur+1) +"' placeholder='Value Med " + String(longueur+1) +"'/>";
								lists[longueur-1].parentNode.appendChild(new_item);
								
								$('#att_value_med_quali_'+ii).val(attribute_edit.val_med[ii-1]);
							};
							
							$('#att_value_max_quali').val(attribute_edit.val_max);
						}
					});
				})(i);
			}
		}
	}
	sync_table();
	/// Defines what happens when you click on the QUANTITATIVE Submit button
	$('#submit_quanti').click(function() {
		var name = $('#att_name_quanti').val(),
			unit = $('#att_unit_quanti').val(),
			val_min = parseInt($('#att_value_min_quanti').val()),
			val_max = parseInt($('#att_value_max_quanti').val());
		var method = "PE";
		if ($("select option:selected").text() == "Probability Equivalence") {
			method = "PE";
		} else if ($("select option:selected").text() == "Lottery Equivalence") {
			method = "LE";
		} else if ($("select option:selected").text() == "Certainty Equivalence - Constant Probability") {
			method = "CE_Constant_Prob";
		} else if ($("select option:selected").text() == "Certainty Equivalence - Variable Probability") {
			method = "CE_Variable_Prob";
		}
		var mode = ($('input[name=mode]').is(':checked') ? "Reversed" : "Normal");
		
		if (!(name || unit || val_min || val_max) || isNaN(val_min) || isNaN(val_max)) {
			alert('Please fill correctly all the fields');
		} else if (isAttribute(name) && (edit_mode == false)) {
			alert ("An attribute with the same name already exists");
		} else if (val_min > val_max) {
			alert ("Minimum value must be inferior to maximum value");
		} else if (val_min<0 || val_max<0 ) {
			alert ("Values must be positive or zero");
		} else if (isThereUnderscore([name, unit], String(val_min), String(val_max))==false) {
			alert("Please don't write an underscore ( _ ) in your values.");
		} else if (isThereHyphen([name, unit], String(val_min), String(val_max))==false) {
			alert("Please don't write a hyphen ( - ) in your values.");
		} else if (isThereBlankSpace([name, unit], String(val_min), String(val_max))==false) {
			alert("Please don't write a blank space in your values.");
		}
		
		else {
			if (edit_mode==false) {
				assess_session.attributes.push({
					"type": "Quantitative",
					"name": name,
					'unit': unit,
					'val_min': val_min,
					'val_med': [
						String(parseFloat(val_min)+.25*(parseFloat(val_max)-parseFloat(val_min))),
						String(parseFloat(val_min)+.50*(parseFloat(val_max)-parseFloat(val_min))), //yes, it's (val_max+val_min)/2, but it looks better ^^
						String(parseFloat(val_min)+.75*(parseFloat(val_max)-parseFloat(val_min)))
					],
					'val_max': val_max,
					'method': method,
					'mode': mode,
					'completed': 'False',
					'checked': true,
					'questionnaire': {
						'number': 0,
						'points': {},
						'utility': {}
					}
				});
			} else {
				if (confirm("Are you sure you want to edit the attribute? All assessements will be deleted") == true) {
					assess_session.attributes[edited_attribute]={
						"type": "Quantitative",
						"name": name,
						'unit': unit,
						'val_min': val_min,
						'val_med': [
							String(parseFloat(val_min)+.25*(parseFloat(val_max)-parseFloat(val_min))),
							String(parseFloat(val_min)+.50*(parseFloat(val_max)-parseFloat(val_min))), //yes, it's (val_max+val_min)/2, but it looks better ^^
							String(parseFloat(val_min)+.75*(parseFloat(val_max)-parseFloat(val_min)))
						],
						'val_max': val_max,
						'method': method,
						'mode': mode,
						'completed': 'False',
						'checked': true,
						'questionnaire': {
							'number': 0,
							'points': {},
							'utility': {}
						}
					};
				}	
				edit_mode=false;
				$('#add_attribute h2').text("Add a new attribute");
			}
			sync_table();
			localStorage.setItem("assess_session", JSON.stringify(assess_session));
			$('#att_name_quanti').val("");
			$('#att_unit_quanti').val("");
			$('#att_value_min_quanti').val("");
			$('#att_value_max_quanti').val("");
			$('#att_method_quanti option[value="PE"]').prop('selected', true);
			$('#att_mode_quanti').prop('checked', false);
			
			$("#form_quanti").fadeOut(500);
			$("#button_Quantitative").removeClass('btn-success');
			$("#button_Quantitative").addClass('btn-default');	
		}
	});
	
	/// Defines what happens when you click on the QUALITATIVE Submit button
	$('#submit_quali').click(function() {
		var name = $('#att_name_quali').val(),
			val_min = $('#att_value_min_quali').val(),
			nb_med_values = document.getElementById('list_med_values_quali').getElementsByTagName('li').length,
			val_med = [],
			val_max = $('#att_value_max_quali').val();
			
		for (var ii=1; ii<nb_med_values+1; ii++){
			val_med.push($('#att_value_med_quali_'+ii).val());
		};
		var method = "PE";
		
		if (name=="" || val_min=="" || val_max=="") {
			alert('Please fill correctly all the fields');
		} else if (isAttribute(name) && (edit_mode == false)) {
			alert ("An attribute with the same name already exists");
		} else if (isOneValueOfTheListEmpty(val_med)) {
			alert("One of your medium values is empty");
		} else if (val_min==val_max) {
			alert("The least preferred and most preferred values are the same");
		} else if (areAllValuesDifferent(val_med, val_min, val_max)==false) {
			alert("At least one of the values is appearing more than once");
		} else if (isThereUnderscore(val_med, val_min, val_max)==false) {
			alert("Please don't write an underscore ( _ ) in your values.\nBut you can put spaces");
		}
		else {
			if (edit_mode==false) {
				assess_session.attributes.push({
					"type": "Qualitative",
					"name": name,
					'unit': '',
					'val_min': val_min,
					'val_med': val_med,
					'val_max': val_max,
					'method': method,
					'mode': 'Normal',
					'completed': 'False',
					'checked': true,
					'questionnaire': {
						'number': 0,
						'points': {},
						'utility': {}
					}
				});
			} else {
				if (confirm("Are you sure you want to edit this attribute? All assessements will be deleted") == true) {
					assess_session.attributes[edited_attribute]={
						"type": "Qualitative",
						"name": name,
						'unit': '',
						'val_min': val_min,
						'val_med': val_med,
						'val_max': val_max,
						'method': method,
						'mode': 'Normal',
						'completed': 'False',
						'checked': true,
						'questionnaire': {
							'number': 0,
							'points': {},
							'utility': {}
						}
					};
				}
				edit_mode=false;
				$('#add_attribute h2').text("Add a new attribute");
			}
			
			sync_table();
			localStorage.setItem("assess_session", JSON.stringify(assess_session));
			
			/// On vide les zones de texte
			$('#att_name_quali').val("");
			$('#att_value_min_quali').val("");
			$('#att_value_med_quali_1').val("");
			$('#att_value_max_quali').val("");
			
			/// On ramène le nombre d'éléments intermédiaires à 1
			for (var ii=val_med.length; ii>1; ii--) {
				var longueur = document.getElementById('list_med_values_quali').getElementsByTagName('li').length;
				lists[longueur-1].parentNode.removeChild(lists[longueur-1]);
			};
			$("#form_quali").fadeOut(500);
			$("#button_Qualitative").removeClass('btn-success');
			$("#button_Qualitative").addClass('btn-default');			
		}
	});
});
</script>
</body>

</html>
