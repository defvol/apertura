var dataRequestTemplate = '';
var removeDataRequestHtml = '<a class="remove-data-request" href="#" onclick="removeDataRequest(this)"><i class="glyphicon glyphicon-remove"></i></a>';

$(function() {
  $("#email").keydown(toggleDisclaimer);

  // Dynamic fields
  dataRequestTemplate = $('.data-request').first().clone();
});

function toggleDisclaimer(e) {
  var tooltip = $(".disclaimer");
  var val = $(this).val();
  if (val == '' || val == $(this).attr('placeholder')) {
    tooltip.hide();
  } else {
    tooltip.show().fadeIn();
  }
}

function addDataRequest(e) {
  $("#data-requests").append(dataRequestTemplate.clone());
  $(e).replaceWith(removeDataRequestHtml);
  return false;
}

function removeDataRequest(e) {
  $(e).closest(".data-request").remove();
  return false;
}

