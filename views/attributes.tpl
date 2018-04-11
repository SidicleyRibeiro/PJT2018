%include('header_init.tpl', heading='State your problem 20')
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

//<!----------------------------------------------   VALIDÉ JUSQU'ICI :D    --------------------------------------------------

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

</script>

