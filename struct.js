/*js script to do pop pyramid thang*/

var margin = {top: 60, right: 80, bottom: 40, left: 80},
    width = 1200 - margin.left - margin.right,
    height = 600 - margin.top - margin.bottom,
    barWidth = Math.floor(width / 17) - 1;

var x = d3.scale.linear()
    .range([barWidth / 2, width - barWidth / 2]);

var y = d3.scale.linear()
    .range([height, 0]);

var formatPercent = d3.format("0.0%");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickSize(width)
    .tickFormat(formatPercent);

var tip = d3.tip()
  .attr('class', 'd3-tip')
  .offset([-10, 0])
  .html(function(d) {console.log(d); var dp = Number(d).toFixed(4);
    return "<strong>Frequency:</strong> <span style='color:white'>" + dp + "</span>";
  })

// An SVG element with a bottom-right origin.
var svg = d3.select("body").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

svg.call(tip);

// A sliding container to hold the bars by birthyear.
var birthyears = svg.append("g")
    .attr("class", "birthyears");

// A label for the current year.
var title = svg.append("text")
    .attr("class", "title")
    .attr("dy", ".71em")
    .attr("x", width - 700)
    .text("Segi");

/*currently cheating as there is a flip somewhere?*/
/*d3.csv("mydata3.csv", type, function(error, data) {*/
d3.csv("mydata4.csv", type, function(error, data) {

  // Convert strings to numbers.
  data.forEach(function(d) {
    d.people = +d.people;
    d.year = +d.year;
    d.age = +d.age;
  });

  // Compute the extent of the data set in age and years.
  var age1 = d3.max(data, function(d) { return d.age; }),
      year0 = d3.min(data, function(d) { return d.year; }),
      year1 = d3.max(data, function(d) { return d.year; }),
      year = year1;
      /*std = function(d) { return d.std; };*/

  /*var stan = function(d) { return d.std; };*/

  // Update the scale domains.
  x.domain([year1 - age1, year1]);
  y.domain([0, d3.max(data, function(d) { return d.people; })]);

  // Produce a map from year and birthyear to [male, female].
  data = d3.nest()
      .key(function(d) { return d.year; })
      .key(function(d) { return d.year - d.age; })
      .rollup(function(v) { return v.map(function(d) { return d.people; }); })
      .map(data);

  // Add an axis to show the population values.
  svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(" + width + ",0)")
      .call(yAxis)
    .selectAll("g")
    .filter(function(value) { return !value; })
      .classed("zero", true);

  // Add labeled rects for each birthyear (so that no enter or exit is required).
  var birthyear = birthyears.selectAll(".birthyear")
      .data(d3.range(year0 - age1, year1 + 1, 5))
    .enter().append("g")
      .attr("class", "birthyear")
      .attr("transform", function(birthyear) { return "translate(" + x(birthyear) + ",0)"; });

  birthyear.selectAll("rect")
      .data(function(birthyear) { return data[year][birthyear] || [0, 0]; })
    .enter().append("rect")
      .attr("x", -barWidth / 2)
      .attr("width", barWidth)
      .attr("y", y)
      .attr("height", function(value) { return height - y(value); })
      .on('mouseover', tip.show)
      .on('mouseout', tip.hide);

  // Add labels to show birthyear.
  /*birthyear.append("text")
      .attr("y", height - 4)
      .text(function(birthyear) { return birthyear; });*/

  // Add labels to show age (separate; not animated).
  svg.selectAll(".age")
      .data(d3.range(0, age1 + 1, 5))
    .enter().append("text")
      .attr("class", "age")
      .attr("x", function(age) { return x(year - age); })
      .attr("y", height + 4)
      .attr("dy", ".71em")
      .text(function(age) { if(age === 0){ return (80 - age + "+"); }else{ return (80 - age + "-" + (84 - age));} });

  // Allow the arrow keys to change the displayed year.
  window.focus();
  d3.select(window).on("keydown", function() {
    switch (d3.event.keyCode) {
      case 37: year = Math.max(year0, year - 90); break;
      case 39: year = Math.min(year1, year + 90); break;
    }
    update();
  });

  function update() {
    if (!(year in data)) return;
    if (year === 900) title.text("Segi");
    if (year === 810) title.text("WHO");
    if (year === 540) title.text("Maori - Census 01");
    if (year === 630) title.text("Maori - Census 06");
    if (year === 720) title.text("Maori - Census 13");
    if (year === 270) title.text("Pacific - Census 01");
    if (year === 360) title.text("Pacific - Census 06");
    if (year === 450) title.text("Pacific - Census 13");
    if (year === 0) title.text("Asian - Census 01");
    if (year === 90) title.text("Asian - Census 06");
    if (year === 180) title.text("Asian - Census 13");

    /*title.text("");
    /*function(data){return(data.std);});*/
    /*function(year) { if(year = 1850){ return("Maori"); }else if(year == 1920){ return("WHO"); }else{ return("Segi"); }});*/

    birthyears.transition()
        .duration(750)
        .attr("transform", "translate(" + (x(year1) - x(year)) + ",0)");

    birthyear.selectAll("rect")
        .data(function(birthyear) { return data[year][birthyear] || [0, 0]; })
      .transition()
        .duration(750)
        .attr("y", y)
        .attr("height", function(value) { return height - y(value); });
  }
});

function type(d) {
  d.people = +d.people;
  return d;
}
