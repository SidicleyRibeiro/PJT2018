%include('header_init.tpl', heading='State your problem')

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
  <tbody id="table_attributes">
  </tbody>
</table>
