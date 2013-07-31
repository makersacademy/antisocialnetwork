$('document').ready(function(){
  $('#loading_modal').modal('show');
  $.post('/activities', function(data){
    $('#loading_modal').modal('hide');
    d3.json("/activities.json", function(error, data) {
      displayChart(error, data);
      $(window).on("resize", function() {      
        $('#chart_area').empty();            
        displayChart(error, data);
      });
    });
  });
});

function displayChart(error, data) {

  // deep copy of the array of objects
  var data = $.map(data, function(e, i) { return $.extend(true, {}, e) });
  
  var margin = {top: 40, right: 100, bottom: 40, left: 60};
  var width = $('#chart_area').width() - margin.left - margin.right;
  var height = $('#chart_area').height() - margin.top - margin.bottom;

  var x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1);

  var y = d3.scale.linear()
    .rangeRound([height, 0]);

  var colors_array = ["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]

  var color = d3.scale.ordinal().range(colors_array);

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickFormat(d3.format(".2s"));

  var svg = d3.select("#chart_area").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


  function draw(error, data) {

    // get the categories and add to the color domain
    color.domain(
      d3.keys(data[0]).filter(
      function(key) { return key !== "date"; }
    ));

    data.forEach(function(d) {
      var y0 = 0;
      d.categories = color.domain().map(function(name) { return {name: name, y0: y0, y1: y0 += +d[name]}; });
      d.total = d.categories[d.categories.length - 1].y1;
    });

    // sort function to sort the x-values in date order
    data.sort(function(a, b) { 
      var d1 = new Date(a.date);
      var d2 = new Date(b.date);
      return d1 - d2; 
    });

    // get the x-values
    x.domain(data.map(function(d) { return d.date; }));

    // calculate the range of possible y-values
    y.domain([0, d3.max(data, function(d) { return d.total * 1.5; })]);

    // add the x-axis and position it
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    // add the y-axis and position
    // rotate the axis label anticlockwise by 90 degrees
    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90, " + -margin.top + ", 0)")
        .attr("x", -height/2)
        .style("text-anchor", "end")
        .text("Facebook activity");


    var column = svg.selectAll(".date")
        .data(data)
      .enter().append("g")
        .attr("class", "g")
        .attr("transform", function(d) { return "translate(" + x(d.date) + ",0)"; });

    column.selectAll("rect")
        .data(function(d) { return d.categories; })
      .enter().append("rect")
        .attr("width", x.rangeBand())
        .attr("y", 0)
        .attr("height", 0)
        .style("fill", function(d) { return color(d.name); });

    // transition animation
    column.selectAll("rect")
      .transition()
      .delay(function(d, i){ return i / data.length * 1000 })
      .attr("height", function(d) { return y(d.y0) - y(d.y1); })
      .attr("y", function(d) { return y(d.y1); })

    // create the legend
    var legend = svg.selectAll(".legend")
        .data(color.domain().slice().reverse())
      .enter().append("g")
        .attr("class", "legend")
        .attr("transform", function(d, i) { return "translate(100," + i * 20 + ")"; });

    // add a box to show the color of the corresponding box
    legend.append("rect")
        .attr("x", width - 18)
        .attr("width", 18)
        .attr("height", 18)
        .style("fill", color);

    // add the text to the legend
    legend.append("text")
        .attr("x", width - 24)
        .attr("y", 9)
        .attr("dy", ".35em")
        .style("text-anchor", "end")
        .text(function(d) { return d; });

  }  

  draw(error, data);

}