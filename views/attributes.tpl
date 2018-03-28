%include('header_init.tpl', heading='State your problem 9')

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
        <th>Edit</th>
        <th><button type="button" class="btn btn-danger del_simu"><img src='/static/img/delete.ico' style='width:16px;'/></button></th>
      </tr>
  </thead>
  <tbody id="table_problem">
  </tbody>
</table>

<br />

<div id="add_problem" style="width:50%;margin-left:25%;margin-bottom:25px;">
	<h2> Add new problem: </h2>
	
	<div id="button_type" style="text-align:center;">
		<button type="button" class="btn btn-default btn-lg" id="button_discret">DISCRET</button>
		<button type="button" class="btn btn-default btn-lg" id="button_continuous">CONTINUOUS</button>
	</div>
	
<br />

<!------------ FORM FOR A DISCRET PROBLEM ------------>
	
	<div id="form_discret">
		<div class="form-group">
			<label for="problem_discret">I'd like to know the probability of:</label>
			<input type="text" class="form-control" id="problem_discret" placeholder="Example: The success of my company in France">
		</div>
		
		<div class="form-group">
			<label for="method_discret">Method:</label>
			<select class="form-control" id="method_discret">
				<option value="PW">Probability Wheel</option>
				<option value="PARIS">Choice between bets</option>
				<option value="LE">Lottery Equivalence</option>
			</select>
		</div>
		
		<button type="submit" class="btn btn-success" id="submit_discret">Submit</button>
	</div>
	
<!------------ FORM FOR A CONTINUOUS PROBLEM ------------>
	
	<div id="form_continuous">
		<div class="form-group">
			<label for="problem_continuous">I would like to assess the probability distribuition of:</label>
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
		</div>
	
		<button type="submit" class="btn btn-success" id="submit_continuous">Submit</button>
	</div>
</div>

%include('header_end.tpl')
%include('js.tpl')

<script>

//Here we're going to try to hide and show whatever we want

$("#form_discret").hide();
$("#form_continuous").hide();
$('li.manage').addClass("active"); //CHANGER LE NOM APRES

//Here we're going to make the beloveds buttons work:

//First, the function for changing button's color:

function update_problem_button(type){
	var list_types = ["discret","continuous"];
	
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

//Now, we decide what's going to happen when clicking:

$(function() {

	//DISCRET BUTTON:
	$("#button_discret").click(function () {
		update_problem_button("discret");
		$("#form_continuous").fadeOut(500);
		$("#form_discret").fadeIn(500);
		window.scrollBy(0, 500);
	});
	
	//CONTINUOUS BUTTON:
	$("#button_continuous").click(function () {
		update_problem_button("continuous");
		$("#form_discret").fadeOut(500);
		$("#form_continuous").fadeIn(500);
		window.scrollBy(0, 500);
	});
});

<!----------------------------------------------   VALIDÉ JUSQU'ICI :D    --------------------------------------------------->

//This part saves the information and process it to make the assesment
$(function() {
	var assess_session = JSON.parse(localStorage.getItem("assess_session")), //JSON.parse gets the strings for the local storage and tranforms it into js objects.
		edit_mode = false, 
		edited_attribute=0; //CHANGER APRES
	
	// When you click on the RED BIN // Delete the wole session
	$('.del_simu').click(function() {
		if (confirm("You are about to delete all the problem statements and their probability assessments.\nAre you sure ?") == false) {
			return
		};
		localStorage.removeItem("assess_session");
		window.location.reload();
	});
	
	// Create a new session if there is no existing one yet - ADAPTER ENTREES APRES
	if (!assess_session) {
		assess_session = {
			"problem_statements": [],
			"settings": {
				"decimals_equations": 3,
				"decimals_dpl": 8,
				"language": "english",
				"display": "trees"
			}
		};
		localStorage.setItem("assess_session", JSON.stringify(assess_session)); //Here we save the sessions in the server's memory in order to avois the deleting of the information each time we close it.
	};
	
<!-------------------------------------------------   VALIDATION PROCESS ------------------------------>
//This functions are going to be called afterwards.

// Function to know if "name" is an existing attribute of the current session
	function isAttribute(name) {
		for (var i = 0; i < assess_session.attributes.length; i++) {
			if (assess_session.attributes[i].name == name) {
				return true;
			};
		};
		return false;
	};
	
<!-----------------------WE THINK THE VAL LIST IS A LIST WITH THE ENTRY VALUES, WE NEED TO VERIFY THAT AFTER-------------------------->
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
		if (val_min.search("")!=-1 || val_max.search("")!=-1){
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

// Function to update the attributes table
	function sync_table() {
		$('#table_attributes').empty();
		if (assess_session) {
			for (var i = 0; i < assess_session.problem_statements.length; i++) {
				var problemstatement = assess_session.problem_statements[i];
				
				var text_table = "<tr>"+
					'<td><input type="checkbox" id="checkbox_' + i + '" value="' + i + '" name="' + problem_statements.name ></td>'+
					'<td>' + problem_statements.type + '</td>'+
					'<td>' + problem_statements.name + '</td>'+
					'<td>' + problem_statements.unit + '</td>';
					
				if (problem_statements.type == "Discret") {
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

</script>

