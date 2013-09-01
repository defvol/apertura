var dataRequestTemplate = '';
var removeDataRequestHtml = '<a class="remove-data-request" href="#" onclick="removeDataRequest(this)"><i class="glyphicon glyphicon-remove"></i></a>';
var PEF = [];

$(function() {
  $("#email").keydown(toggleDisclaimer);

  // Dynamic fields
  dataRequestTemplate = $('.data-request').first().clone();

  // Load data and build visualization
  // Presupuesto de Egresos de la Federación (SHCP)
  // Reference: http://goo.gl/NizYV
  d3.json("/PEF_2013.json", function(error, json) {
    if (error) return console.warn(error);
    PEF = json.rows;
    visualize();
  });

});

function toggleDisclaimer(e) {
  var disclaimer = $(".disclaimer");
  var val = $(this).val();
  if (val == '' || val == $(this).attr('placeholder')) {
    disclaimer.hide();
  } else {
    disclaimer.show().fadeIn();
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

