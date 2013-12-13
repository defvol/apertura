var dataRequestTemplate = '';
var removeDataRequestHtml = '<a class="remove-data-request" href="#" onclick="removeDataRequest(this)"><i class="glyphicon glyphicon-remove"></i></a>';

$(function() {
  // Poll options will submit the form
  $("[id^=option-], .poll-option-wrapper").click(function(e) {
    e.preventDefault();
    var id = $(e.currentTarget).attr("id").replace(/^option-/, '');
    var $form = $(e.currentTarget).closest("form");
    $form.find("input:hidden[name=selected]").val(id)
    $form.submit();
  });

  $("#email").keydown(toggleDisclaimer);

  // Dynamic fields
  dataRequestTemplate = $('.data-request').first().clone();

  // Showing the middle finger to IE
  // IE does not render foreignObject
  if (typeof SVGForeignObjectElement !== 'undefined') {
    $("#chart").addClass("supportsForeignObject");
    // Note: could not find a way to detect this using modernizr
  }
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

function addDataCategory(sel) {
  var selectedOption = $(sel).find(":selected").first()[0];
  var otherCategory = $(sel).find("option.other").first()[0];
  if (selectedOption === otherCategory) {
    var answer = prompt("Sugiere una nueva categoría");
    if (_.isEmpty(answer) === false)
      $(otherCategory).text(answer);
  }
}

