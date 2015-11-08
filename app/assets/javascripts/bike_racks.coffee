# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initializeMap = ->
  mapOptions =
    zoom: 13
    center: new google.maps.LatLng(49.27, -123.16338)
  window.map = new google.maps.Map(document.getElementById("map"), mapOptions)
  window.addMarkers()
  return

window.addMarkers = ->
  $(".map-marker").each (index, element) =>
    lat = $(element).data("lat")
    lon = $(element).data("lon")
    isNum = (n) -> typeof n is 'number' and isFinite n
    window.addMarker(lat, lon) if isNum(lat) && isNum(lon)
  return

window.addMarker = (latitude, longitude) ->
  marker = new google.maps.Marker(
    position:
      lat: latitude
      lng: longitude
    map: window.map)
  return

$(document).on 'ready page:load', ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDjOrbjfVvqyAucNEt1tP7rC-HfhvdyY1o&callback=initializeMap"
  document.body.appendChild script
  return
