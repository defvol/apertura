// Inspired in:
// http://www.nytimes.com/interactive/2012/02/13/us/politics/2013-budget-proposal-graphic.html

// Style

var fillColor = d3.scale.ordinal()
      .domain([-3,-2,-1,0,1,2,3])
      .range(["#d84b2a", "#ee9586","#e4b7b2","#AAA","#beccae", "#9caf84", "#7aa25c"]),
    strokeColor = d3.scale.ordinal()
      .domain([-3,-2,-1,0,1,2,3])
      .range(["#c72d0a", "#e67761","#d9a097","#999","#a7bb8f", "#7e965d", "#5a8731"]);

// Format

var toCurrency = d3.format("$,.2f"),
    toPercentage = d3.format(".2%");

// Layout

var width = 900,
    height = 300,
    center = { x: width / 2, y: height / 2 },
    radiusScale = d3.scale.pow().exponent(0.5).domain([0,1000000000000]).range([1,90]),
    changeScale = d3.scale.linear().domain([-1,1]).range([300, 0]).clamp(true);

// Render

function visualize() {

  var svg = d3.select("#viz").append("svg")
      .attr("width", width)
      .attr("height", height);

  var circle = svg.selectAll("circle")
      .data(PEF)
      .enter()
      .append("circle")
      .style("fill", function(d) { return fillColor(categorizeChange(d.cambio)) })
      .style("stroke-width", 0.8)
      .style("stroke", function(d) { return strokeColor(categorizeChange(d.cambio)) })
      .on("mouseover", function(d, i) { showDetails(d, i, this) })
      .on("mouseout", function(d, i) { hideDetails(d, i, this) })
      .call(d3.behavior.drag().on("drag", move));

  circle.attr("cx", function(d, i) {
    var r = radiusScale(d.presupuesto_2013);
    var centerScale = d3.scale.linear().range([r, width - r]).clamp(true);
    return centerScale(Math.random());
  });

  circle.attr("cy", function(d) {
    return changeScale(d.cambio);
  });

  d3.selectAll("circle").transition()
    .duration(750)
    .delay(function(d, i) { return i * 10 })
    .attr("r", function(d) { return radiusScale(d.presupuesto_2013) });

}

// UI

function showDetails(d, i, element) {
  var html = "<div class='custom-tooltip'>";
  html += "<p>" + d.ramo + "</p>";
  html += "<p>" + toCurrency(d.presupuesto_2013) + " (" + toPercentage(d.cambio) + ")</p>";
  html += "</div>";

  $(element).tooltip({
    container: "body",
    html: true,
    title: html
  });

  $(element).tooltip('show');
  d3.select(element).style("stroke", "#333");
}

function hideDetails(d, i, element) {
  $(element).tooltip('hide');
  var color = strokeColor(categorizeChange(d.cambio));
  d3.select(element).style("stroke", color);
}

function move() {
  var dragTarget = d3.select(this);
  dragTarget
    .attr("cx", function() { return d3.event.dx + parseInt(dragTarget.attr("cx")) });
}

// Helpers

function categorizeChange(c) {
  if (isNaN(c)) { return 0;
  } else if ( c < -0.25) { return -3;
  } else if ( c < -0.05){ return -2;
  } else if ( c < -0.001){ return -1;
  } else if ( c <= 0.001){ return 0;
  } else if ( c <= 0.05){ return 1;
  } else if ( c <= 0.25){ return 2;
  } else { return 3; }
}

