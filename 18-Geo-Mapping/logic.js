//Create the function to determine marker size base on eartkquake magnitude.
function getColor(d) {
    return d > 5  ? '#E31A1C' :
           d > 4  ? '#FC4E2A' :
           d > 3   ? '#FD8D3C' :
           d > 2   ? '#FEB24C' :
           d > 1   ? '#FED976' :
                      '#FFEDA0';
}

var queryURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson";

d3.json(queryURL, function(data){
  createFeatures(data.features);
});

function createFeatures(earthquakeData) {
	function onEachFeature(feature, layer) {
		layer.bindPopup("<h2>" + feature.properties.place + 
		"<h3><hr><p>" + new Date(feature.properties.time) + "<p>" );
	}

	var earthquakes = L.geoJSON(earthquakeData, {
		onEachFeature: onEachFeature, 
		pointToLayer: pointToLayer
	});

	createMap(earthquakes);
  		
   	function pointToLayer(feature,latlng){
   		return new L.circle(latlng,{
   			stroke:false,
			fillOpacity: 0.7,
			//color:"blue",
			fillColor:getColor(feature.properties.mag),
			radius: feature.properties.mag * 50000
           })
           
       }
       
}

function createMap(earthquakes) {
	var outdoorMap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/outdoors-v10/tiles/256/{z}/{x}/{y}?" +
		"access_token=pk.eyJ1IjoibXVzaWNhbGVib255IiwiYSI6ImNqY3NiNXZsYzAyN2Myd251NHgxM3hndTYifQ.6XB6Sol3LwVrKQy5GqGS4Q");
    
    var satelliteMap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v10.html/tiles/256/{z}/{x}/{y}?" +
    	"access_token=pk.eyJ1IjoibXVzaWNhbGVib255IiwiYSI6ImNqY3NiNXZsYzAyN2Myd251NHgxM3hndTYifQ.6XB6Sol3LwVrKQy5GqGS4Q");

    var baseMaps = {
    	"Outdoor Map":outdoorMap,
    	"Satellite Map":satelliteMap
    };

    var overlayMaps = {
    	Earthquakes: earthquakes
    };

    var myMap = L.map("map",{
    	center: [37.09, -95.71],
    	zoom: 5,
    	layers:[outdoorMap, earthquakes]
    });

    L.control.layers(baseMaps,overlayMaps,{
    	collapse: false
    }).addTo(myMap);
    
    var legend = L.control({position: 'bottomright'});

legend.onAdd = function (myMap) {

    var div = L.DomUtil.create('div', 'info legend'),
        grades = [1,2,3,4,5],
        labels = [];

    for (var i = 0; i < grades.length; i++) {
        div.innerHTML +=
            '<i style="background:' + getColor(grades[i] + 1) + '"></i> ' +
            grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
    }

    return div;
};

legend.addTo(myMap);

 };  
