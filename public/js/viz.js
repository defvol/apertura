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
    toPercentage = d3.format(".2%"),
    tickChangeFormat = d3.format("+%");

// Layout

var width = 900,
    height = 300,
    center = { x: width / 2, y: height / 2 },
    radiusScale = d3.scale.pow().exponent(0.5).domain([0,1000000000000]).range([1,90]),
    changeScale = d3.scale.linear().domain([-1,1]).range([300, 0]).clamp(true),
    changeTickValues = [-0.25, 0, 0.25];

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

  // Grid

  d3.select("#overlay").style("height", height + "px");

  for (var i=0; i < this.changeTickValues.length; i++) {
    d3.select("#overlay").append("div")
      .html("<p>"+this.tickChangeFormat(this.changeTickValues[i])+"</p>")
      .style("top", this.changeScale(this.changeTickValues[i])+'px')
      .style("width", width+'px')
      .classed('tick', true)
      .classed('zeroTick', this.changeTickValues[i] === 0);
  };

  var sources = {
    2012: "http://www.transparenciapresupuestaria.gob.mx/ptp/ServletImagen?tipo=zip&idDoc=712",
    2013: "http://www.transparenciapresupuestaria.gob.mx/ptp/ServletImagen?tipo=csv&idDoc=711"
  };

  var linkHtml = "<a href='http://www.transparenciapresupuestaria.gob.mx/ptp/contenidos/?id=16&group=Preguntas&page=%C2%BFPara%20qu%C3%A9%20gasta?'>Presupuesto de Egresos de la Federación</a>. SHCP. Año <a href='" + sources['2012'] + "'>2012</a> y <a href='" + sources['2013'] + "'>2013</a>"
  $(".sources")
    .html("<p>Fuente: " + linkHtml + "</p>")
    .css("font-size", "0.8em")
    .css("text-align", "center");

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
  var dragTarget = d3.select(this),
      newPosition = parseInt(dragTarget.attr("cx")) + d3.event.dx,
      radius = parseInt(dragTarget.attr("r"));

  // Keep inside the box
  if (newPosition - radius > 0 && newPosition + radius < width)
    dragTarget.attr("cx", function() { return newPosition });
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

