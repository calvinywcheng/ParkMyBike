# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.googleMapsLoaded = ->
  renderMainMap()
  renderStreetView()
  return

window.renderMainMap = ->
  VANCOUVER_CENTRE = new google.maps.LatLng(49.234424, -123.1023147)
  mapOptions =
    zoom: 12
    maxZoom: 18
    center: VANCOUVER_CENTRE
  window.map = new google.maps.Map($("#map")[0], mapOptions)
  addCurrentLocation()
  addMarkers()
  return

window.addMarkers = ->
  bounds = new google.maps.LatLngBounds()
  $(".map-marker").each (index, element) =>
    lat = $(element).data("lat")
    lon = $(element).data("lon")
    window.addMarker(lat, lon, bounds) if isValidLatLon(lat, lon)
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
        url: "/assets/my_location.png"
        scaledSize: new google.maps.Size(25, 25))
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition(placeMarker)
  return

window.renderStreetView = ->
  element = $("#street-view")[0]
  lat = $(element).data("lat")
  lon = $(element).data("lon")
  if isValidLatLon(lat, lon)
    console.log "lat lon valid"
    window.streetView = new google.maps.StreetViewPanorama(
      element,
      position: new google.maps.LatLng(lat, lon)
      addressControl: true
      clickToGo: true
      enableCloseButton: false)
  return

window.isValidLatLon = (lat, lon) ->
  isNum = (n) ->
    return typeof n is 'number' && isFinite n
  isNum(lat) && isNum(lon)

$(document).on 'ready page:load', ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://maps.googleapis.com/maps/api/js?key=AIzaSyDjOrbjfVvqyAucNEt1tP7rC-HfhvdyY1o&callback=googleMapsLoaded"
  document.body.appendChild script
  return

$(document).on 'ready page:load', ->
  streetViewElem = $("#street-view")[0]
  $(streetViewElem).height($(streetViewElem).width() * 9/16);
