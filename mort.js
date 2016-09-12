/*simple scatterplot js*/
var margin = {top: 60, right: 80, bottom: 40, left: 80},
    width = 1200 - margin.left - margin.right,
    height = 600 - margin.top - margin.bottom;

var formatDate = d3.time.format("%Y");

var x = d3.time.scale()
          .range([0, width]);

var y = d3.scale.linear()
          .range([height, 0]);

var xAxis = d3.svg.axis()
              .scale(x)
              .orient("bottom")
              .tickFormat(formatDate);

var yAxis = d3.svg.axis()
              .scale(y)
              .orient("left");

var line = d3.svg.line()
             .x(function(d){ return x(d.year); })
             .y(function(d){ return y(d.rate); });

var line2 = d3.svg.line()
              .x(function(d){ return x(d.year); })
              .y(function(d){ return y(d.rate2); });

var line3 = d3.svg.line()
              .x(function(d){ return x(d.year); })
              .y(function(d){ return y(d.rate3); });

var color = d3.scale.category10();

var svg = d3.select("body").append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var title = svg.append("text")
    .attr("class", "title")
    .attr("dy", ".71em")
    .attr("x", width - 700)
    .text("Total Mortality");

d3.csv("ratemulti.csv", type, function(error, data) {

  if(error) throw error;

  x.domain(d3.extent(data, function(d){ return d.year; })).nice();
  y.domain([0, d3.max(data, function(d){ return d.ratem; })]);

   svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
      .append("text")
         .attr("class", "label")
         .attr("x", width)
         .attr("y", -6)
         .style("text-anchor", "end")
         .text("Year");

  svg.append("g")
     .attr("class", "y axis")
     .call(yAxis)
     .append("text")
         .attr("class", "label")
         /*.attr("transform", "rotate(-90)")*/
         .attr("y", -25)
         .attr("x", 70)
         .attr("dy", ".71em")
         .style("text-anchor", "end")
         .text("Mortality rate per 100,000");

  svg.append("path")
     .datum(data)
     .attr("class", "line")
     .attr("d", line)
     .attr("stroke", "green")
     .attr("fill", "none");

  svg.append("path")
     .datum(data)
     .attr("class", "line")
     .attr("d", line2)
     .attr("stroke", "red")
     .attr("fill", "none");

  svg.append("path")
     .datum(data)
     .attr("class", "line")
     .attr("d", line3)
     .attr("stroke", "orange")
     .attr("fill", "none");

  svg.selectAll(".dot")
     .data(data)
     .enter().append("circle")
             .attr("class", "dot")
             .attr("r", 3)
             .attr("cx", function(d){ return x(d.year); })
             .attr("cy", function(d){ return y(d.rate); })
             .style("fill", "green");

  svg.selectAll(".dot2")
     .data(data)
     .enter().append("circle")
             .attr("class", "dot2")
             .attr("r", 3)
             .attr("cx", function(d){ return x(d.year); })
             .attr("cy", function(d){ return y(d.rate2); })
             .style("fill", "red");

  svg.selectAll(".dot3")
     .data(data)
     .enter().append("circle")
             .attr("class", "dot3")
             .attr("r", 3)
             .attr("cx", function(d){ return x(d.year); })
             .attr("cy", function(d){ return y(d.rate3); })
             .style("fill", "orange");

});

function type(d){
  d.year = formatDate.parse(d.year);
  d.rate = +d.rate;
  d.rate2 = +d.rate2;
  d.rate3 = +d.rate3;
  d.ratem = +d.ratem;
  return d;
}