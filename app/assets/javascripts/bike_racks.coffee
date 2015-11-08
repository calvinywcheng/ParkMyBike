# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initializeMap = ->
  VANCOUVER_CENTRE = new google.maps.LatLng(49.234424, -123.1023147)
  mapOptions =
    zoom: 12
    maxZoom: 18
    center: VANCOUVER_CENTRE
  window.map = new google.maps.Map(document.getElementById("map"), mapOptions)
  addCurrentLocation()
  addMarkers()
  return

window.addMarkers = ->
  bounds = new google.maps.LatLngBounds()
  $(".map-marker").each (index, element) =>
    lat = $(element).data("lat")
    lon = $(element).data("lon")
    isNum = (n) -> typeof n is 'number' && isFinite n
    window.addMarker(lat, lon, bounds) if isNum(lat) && isNum(lon)
  map.fitBounds(bounds) unless bounds.isEmpty()
  return

window.addMarker = (latitude, longitude, bounds) ->
  latlon = new google.maps.LatLng(latitude, longitude)
  marker = new google.maps.Marker(position: latlon, map: map)
  bounds.extend latlon
  return

window.addCurrentLocation = ->
  placeMarker = (position) ->
    marker = new google.maps.Marker(
      position:
        lat: position.coords.latitude
        lng: position.coords.longitude
      map: map
      icon:
        url: "media/my_location.png"
        scaledSize: new google.maps.Size(25, 25))
    bounds.extend marker.position
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition(placeMarker)
  return

$(document).on 'ready page:load', ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://maps.googleapis.com/maps/api/js?key=AIzaSyDjOrbjfVvqyAucNEt1tP7rC-HfhvdyY1o&callback=initializeMap"
  document.body.appendChild script
  return
