var url = "/";

function optionChanged() {

};

function buildPie() {
  Plotly.d3.json(url, function(error, response) {

    console.log(response);
    var trace1 = {
      type: "scatter",
      mode: "lines",
      name: "Bigfoot Sightings",
      x: response.map(data => data.months),
      y: response.map(data => data.sightings),
      line: {
        color: "#17BECF"
      }
    };

    var data = [trace1];

    var layout = {
      title: "Bigfoot Sightings Per Year",
      xaxis: {
        type: "date"
      },
      yaxis: {
        autorange: true,
        type: "linear"
      }
    };

    Plotly.newPlot("plot", data, layout);
  });
}

buildPie();


<select id="selDataset" onchange="optionChanged(this.value)">
<option value="dataset1">United States</option>
</select>
