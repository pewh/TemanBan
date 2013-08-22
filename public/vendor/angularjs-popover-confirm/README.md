Bootstrap Popover Confirm
=========================

data-popover-confirm: activates the script and is the evaluated string that is run.

data-title: is the message shown to users.

jQuery Version

    <span
      class='btn btn-success'
      data-title='Confirm order and use selected payment method?'
      data-popover-confirm='Cardonfile.purchase()'>
      Confirm and Purchase
    </span>

Angular JS Directive

View:

    <div 
      class='btn btn-danger' 
      ng-model='record' 
      ng-popover-confirm="deleteRecord()" 
      data-title="Delete this form entry?">
      <i class='icon-remove'></i> Delete
    </div>
    
Controller:

    $scope.deleteRecord = function() {
		$http.delete('/formentries/record/' + this.record.id).then(function(data){
			toastr.success("Record deleted!");
			$scope.loadRecords();
		});
	}
