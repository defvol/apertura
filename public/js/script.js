$(function() {
  $("#email").keydown(toggleDisclaimer);

  var templateHtml = $('#data-request-template').html()
  $("#data-requests").append(_.template(templateHtml));

  $("a#new-data-request").click(function(e) {
    e.preventDefault();
    $("#data-requests").append(_.template(templateHtml));
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

