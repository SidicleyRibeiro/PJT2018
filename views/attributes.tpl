%include('header_init.tpl', heading='State your problem4')

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
		<button type="button" class="btn btn-default btn-lg" id="button_1">Problem1</button>
		<button type="button" class="btn btn-default btn-lg" id="button_2">Problem2</button>
	</div>
	
<!------------ FORM FOR A DISCRET PROBLEM ------------>
	
	<div id="form_uno">
		<div class="form-group">
			<label for="problem_uno">Name:</label>
			<input type="text" class="form-control" id="problem_uno" placeholder="Temporaire">
		</div>
		
		<button type="submit" class="btn btn-success" id="submit_uno">Submit</button>
	</div>
	
<!------------ FORM FOR A CONTINUOUS PROBLEM ------------>
	
	<div id="form_dos">
		<div class="form-group">
			<label for="problem_dos">Name:</label>
			<input type="text" class="form-control" id="problem_dos" placeholder="Temporaire">
		</div>
		
		<button type="submit" class="btn btn-success" id="submit_dos">Submit</button>
	</div>
</div>

%include('header_end.tpl')
%include('js.tpl')

<!----------------------------------------------   VALIDÉ JUSQU'ICI :D    --------------------------------------------------->

<script>

//Here we're going to try to hide and show whatever we want

$("#form_uno").hide();
$("#form_dos").hide();
$('li.manage').addClass("active"); //CHANGER LE NOM APRES

//Here we're going to make the #!%$ buttons work:

//First, the function for changing button's color:

function update_problem_button(type){
	var list_types = ["1","2"];
	
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

	//FIRST BUTTON:
	$("#button_1").click(function () {
		update_problem_button("1");
		$("#form_uno").fadeOut(500);
		$("#form_dos").fadeIn(500);
		window.scrollBy(0, 500);
	});
	
	//SECOND BUTTON:
	$("#button_2").click(function () {
		update_problem_button("2");
		$("#form_dos").fadeOut(500);
		$("#form_uno").fadeIn(500);
		window.scrollBy(0, 500);
	});
});

</script>
