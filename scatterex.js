/*simple scatterplot js*/
var margin = {top: 60, right: 80, bottom: 40, left: 80},
    width = 1200 - margin.left - margin.right,
    height = 600 - margin.top - margin.bottom;

var x = d3.scale.linear()
          .range([0, width]);

var y = d3.scale.linear()
          .range([height, 0]);

var xAxis = d3.svg.axis()
              .scale(x)
              .orient("bottom");

var yAxis = d3.svg.axis()
              .scale(y)
              .orient("left");


var svg = d3.select("body").append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

/*var title = svg.append("text")
               .attr("class", "title")
               .text("Attempt");*/

d3.csv("random.csv", function(error, data) {

  if(error) throw error;

  data.forEach(function(d){
    d.noise = +d.noise;
    d.rand = +d.rand;
  });

  x.domain(d3.extent(data, function(d){ return d.rand; })).nice();
  y.domain(d3.extent(data, function(d){ return d.noise; })).nice();

   svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
      .append("text")
         .attr("class", "label")
         .attr("x", width)
         .attr("y", -6)
         .style("text-anchor", "end")
         .text("Noise");

  svg.append("g")
     .attr("class", "y axis")
     .call(yAxis)
     .append("text")
         .attr("class", "label")
         .attr("transform", "rotate(-90)")
         .attr("y", 6)
         .attr("dy", ".71em")
         .style("text-anchor", "end")
         .text("RNG normals");

  svg.selectAll(".dot")
     .data(data)
     .enter().append("circle")
             .attr("class", "dot")
             .attr("r", 3)
             .attr("cx", function(d){ return x(d.noise); })
             .attr("cy", function(d){ return y(d.rand); })
             .style("fill", "red");

});