%include('header_init.tpl', heading='State your problem 27')
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
				<option value="GAMBLE">Gamble like method</option>
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
		<div class="form-group">
			<label for="method_continuous">Method:</label>
			<select class="form-control" id="method_continuous">
				<option value="FRACTILE">Fractile Method</option>
			</select>
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

//<!----------------------------------------------   VALIDÉ JUSQU'ICI :D    --------------------------------------------------

// SESSION CREATION AND SETTING
$(function() {
	var assess_session = JSON.parse(localStorage.getItem("assess_session")),
		edit_mode = false,
		edited_problem_statetement=0;
		
	// When you click on the RED BIN // Delete the wole session
	$('.del_simu').click(function() {
		if (confirm("You are about to delete all the attributes and their assessments.\nAre you sure ?") == false) {
			return
		};
		localStorage.removeItem("assess_session");
		window.location.reload();
	});
	
						// ON A CHANGÉ RIEN AVANT CE POINT
	
	// Create a new session if there is no existing one yet
	if (!assess_session) {
		assess_session = {
			"problem_statetement": [],  //WE'VE CHANGED THE VARIABLE "ATTRIBUTES" TO "PROBLEM_STATEMENT"
			"settings": {
				"decimals_equations": 3,
				"decimals_dpl": 8,
				"language": "english",
				"display": "trees"
			}
		};
		localStorage.setItem("assess_session", JSON.stringify(assess_session));
		
	};

// VERIFICATION FONCTIONS OF THE ENTRIES
	function isAttribute(name) {
		for (var i = 0; i < assess_session.problem_statement.length; i++) {
			if (assess_session.problem_statement[i].name == name) {
				return true;
			};
		};
		return false;
	};

// SESSION ENDING AND SUBMITTING
/// Defines what happens when you click on the DISCRET Submit button
	$('#submit_discret').click(function() {
		var name = $('#problem_name_discret').val();
		var method = "PW";
		if ($("select option:selected").text() == "Probability Wheel") {
			method = "PW";
		} else if ($("select option:selected").text() == "Gamble like method") {
			method = "GAMBLE";
		}
		
		if (!(name)) {
			alert('Please fill correctly the name field');
		} else if (isProblem(name) && (edit_mode == false)) {
			alert ("This problem statement is already submitted");
		}
		
		else {
			if (edit_mode==false) {
				assess_session.problem_statetement.push({
					"type": "Discret",
					"name": name,
					'method': method,
					'completed': 'False',
				});
			} else {
				if (confirm("Are you sure you want to edit the problem statement? All assessements will be deleted") == true) {
					assess_session.problem_statetement[edited_problem_statetement]={
						"type": "Discret",
						"name": name,
						'method': method,
						'completed': 'False',
					};
				}	
				edit_mode=false;
				$('#add_problem_statetement h2').text("Add a new problem statement");
			}
			sync_table();
			localStorage.setItem("assess_session", JSON.stringify(assess_session));
			$('#problem_name_discret').val("");
			$('#problem_method_discret option[value="PW"]').prop('selected', true);
			
			$("#form_discret").fadeOut(500);
			$("#button_discret").removeClass('btn-success');
			$("#button_discret").addClass('btn-default');	
		}
	});
							//TESTED UNTIL HERE
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
