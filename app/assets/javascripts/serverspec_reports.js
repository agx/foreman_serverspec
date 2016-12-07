function filter_by_speclevel(item){
  var level = $(item).val();

  if(level == 'passed'){
    $('.label-info').closest('tr').show();
    $('.label-default').closest('tr').hide();
    $('.label-danger').closest('tr').hide();
  } else if(level == 'pending'){
    $('.label-info').closest('tr').hide();
    $('.label-default').closest('tr').show();
    $('.label-danger').closest('tr').hide();
  } else if(level == 'failed'){
    $('.label-info').closest('tr').hide();
    $('.label-default').closest('tr').hide();
    $('.label-danger').closest('tr').show();
  } else {
    $('.label-info').closest('tr').show();
    $('.label-default').closest('tr').show();
    $('.label-danger').closest('tr').show();
  }

  if($("#report_log tr:visible ").length ==1 || $("#report_log tr:visible ").length ==2 && $('#ntsh:visible').length > 0 ){
    $('#ntsh').show();
  }
  else{
    $('#ntsh').hide();
  }
}
