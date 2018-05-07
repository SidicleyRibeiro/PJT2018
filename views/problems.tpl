%include('header_init.tpl', heading='State your problem 2.7')
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

	///VALIDÉ JUSQU'À ICI (112-135 OMITED)
/// Function that manages the influence of the "button_type" buttons (Discret/Continuous) (just the design : green/white) 
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

					//// VALIDÉ JUSQU'À ICI (168)

$(function() { 
 	var assessproba_session = JSON.parse(localStorage.getItem("assessproba_session")), 
 		edit_mode = false, 
 		edited_attribute=0; 
 		 
 	// When you click on the RED BIN // Delete the wole session 
 	$('.del_simu').click(function() { 
 		if (confirm("You are about to delete all the problem statements and their assessments.\nAre you sure ?") == false) { 
 			return 
 		}; 
 		localStorage.removeItem("assessproba_session"); 
 		window.location.reload(); 
 	}); 
 	 
 	// Create a new session if there is no existing one yet 
 	if (!assessproba_session) { 
 		assessproba_session = { 
 			"problem_statements": [], 
 			"settings": { 
 				"decimals_equations": 3, 
 				"decimals_dpl": 8, 
 				"proba_ce": 0.30, 
 				"proba_le": 0.30, 
 				"language": "english", 
 				"display": "trees" 
 			} 
 		}; 
 		localStorage.setItem("assessproba_session", JSON.stringify(assessproba_session)); 
 	};  ///212
	
	/////////////////////////////////////////////////////////////////////// 
 	//////////////////////         FUNCTIONS         ////////////////////// 
 	/////////////////////////////////////////////////////////////////////// 
 	 
					///215-303 APRES REVISER
					
 	// Function to update the attributes table 
 	function sync_table() { 
 		$('#table_problem').empty(); 
 		if (assessproba_session) { 
 			for (var i = 0; i < assessproba_session.problems.length; i++) { 
 				var problem = assessproba_session.problems[i]; 
 				 
 				var text_table = "<tr>"+ 
 					'<td><input type="checkbox" id="checkbox_' + i + '" value="' + i + '" statement="' + problem.statement + '" '+(problem.checked ? "checked" : "")+'></td>'+ 
 					'<td>' + problem.type + '</td>'+ 
 					'<td>' + problem.statement + '</td>'+ 
 					'<td>' + problem.unit + '</td>'; 
 					 
 				if (problem.type == "continuous") { 
 					text_table += '<td>[' + problem.val_min + ',' + problem.val_max + ']</td>'; 
 				}  
 				else if (problem.type == "discret") { 
 					text_table += '<td></td>';  
 				}; 
 				 
 				text_table += '<td>' + problem.method + '</td>'+ 
 					'<td><button type="button" id="edit_' + i + '" class="btn btn-default btn-xs">Edit</button></td>'+ 
 					'<td><button type="button" class="btn btn-default" id="deleteK'+i+'"><img src="/static/img/delete.ico" style="width:16px"/></button></td></tr>'; 
 								 
 				$('#table_problem').append(text_table); 
  
 				//We define the action when we click on the State check input 
 				$('#checkbox_' + i).click(function() { 
 					checked_button_clicked($(this)) 
 				}); 
 				 
 				// Defines what happens when you click on a Delete button 
 				(function(_i) { 
 					$('#deleteK' + _i).click(function() { 
 						if (confirm("You are about to delete the problem "+assessproba_session.problems[_i].statement+".\nAre you sure ?") == false) { 
 							return 
 						}; 
 						assessproba_session.problems.splice(_i, 1); 
 						localStorage.setItem("assessproba_session", JSON.stringify(assessproba_session));// backup local 
 						window.location.reload();//refresh the page 
 					}); 
 				})(i); 
  
 				// Defines what happend when you click on the Edit button 
 				(function(_i) { 
 					$('#edit_' + _i).click(function() { 
 						edit_mode=true; 
 						edited_problem=_i; 
 						var problem_edit = assessproba_session.problems[_i]; 
 						 
 						$('#add_problem h2').text("Edit problem "+problem_edit.statement); 
 						 
 						if (problem_edit.type == "discret") { 
 							update_method_button("discret"); //update the active type of problem 
 							$("#form_continuous").fadeOut(500); 
 							$("#form_discret").fadeIn(500); 
 							 
367 							// Rewrites the existing values inside the textboxes 
368 							$('#att_name_quanti').val(attribute_edit.name); 
369 							$('#att_unit_quanti').val(attribute_edit.unit); 
370 							$('#att_value_min_quanti').val(attribute_edit.val_min); 
371 							$('#att_value_max_quanti').val(attribute_edit.val_max); 
372 							$('#att_method_quanti option[value='+attribute_edit.method+']').prop('selected', true); 
373 							$('#att_mode_quanti').prop('checked', (attribute_edit.mode=="Normal" ? false : true)); 
374 						}  
375 						else if (attribute_edit.type == "Qualitative") { 
376 							update_method_button("Qualitative"); //update the active type of attribute 
377 							$("#form_quanti").fadeOut(500); 
378 							$("#form_quali").fadeIn(500); 
379 							 
380 							$('#att_name_quali').val(attribute_edit.name); 
381 							$('#att_value_min_quali').val(attribute_edit.val_min); 
382 							$('#att_value_med_quali_1').val(attribute_edit.val_med[0]); 
383 							 
384 							for (var ii=2, len=attribute_edit.val_med.length; ii<len+1; ii++) { 
385 								var longueur = lists.length, 
386 									new_item = document.createElement('li'); 
387 								new_item.innerHTML = "<input type='text' class='form-control' id='att_value_med_quali_"+ String(longueur+1) +"' placeholder='Value Med " + String(longueur+1) +"'/>"; 
388 								lists[longueur-1].parentNode.appendChild(new_item); 
389 								 
390 								$('#att_value_med_quali_'+ii).val(attribute_edit.val_med[ii-1]); 
391 							}; 
392 							 
393 							$('#att_value_max_quali').val(attribute_edit.val_max); 
394 						} 
395 					}); 
396 				})(i); 
397 			} 
398 		} 
399 	} 
400 	sync_table(); 


 }); 

</script> 
</body> 
</html> 
