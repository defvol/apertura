$(function() {
  $("#email").keydown(toggleDisclaimer);

  // Dynamic fields
  var template = $('.data-request').first().clone();
  $("a#new-data-request").click(function(e) {
    $("#data-requests").append(template.clone());
    e.preventDefault();
  });
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

function removeDataRequest(e) {
  $(e).closest(".data-request").remove();
  return false;
}

