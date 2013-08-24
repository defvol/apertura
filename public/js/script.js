$(function() {
  $("#email").keydown(toggleDisclaimer);
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

