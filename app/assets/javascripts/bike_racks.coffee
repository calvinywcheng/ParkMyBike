# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.loadGoogleMaps = ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://maps.googleapis.com/maps/api/js?key=AIzaSyDjOrbjfVvqyAucNEt1tP7rC-HfhvdyY1o&callback=googleMapsLoaded"
  document.body.appendChild script
  return

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
    mapTypeControlOptions:
      position: google.maps.ControlPosition.TOP_RIGHT
    scaleControl: true
    rotateControl: true
  window.map = new google.maps.Map($("#map")[0], mapOptions)
  addCurrentLocation()
  addMarkers()
  return

window.addMarkers = ->
  bounds = new google.maps.LatLngBounds()
  $(".map-marker").each (index, element) =>
    lat = $(element).data("lat")
    lon = $(element).data("lon")
    url = $(element).data("url")
    window.addMarker(lat, lon, url, bounds) if isValidLatLon(lat, lon)
  map.fitBounds(bounds) unless bounds.isEmpty()
  return

window.addMarker = (latitude, longitude, url, bounds) ->
  marker = new google.maps.Marker(
    position:
      lat: latitude
      lng: longitude
    map: map)
  bounds.extend marker.position
  google.maps.event.addListener(marker, 'click', -> window.location.href = url)
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
  navigator.geolocation.getCurrentPosition(placeMarker) if navigator.geolocation
  return

window.renderStreetView = ->
  element = $("#street-view")[0]
  $(element).height($(element).width() * 9/16);
  lat = $(element).data("lat")
  lon = $(element).data("lon")
  if isValidLatLon(lat, lon)
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
  return isNum(lat) && isNum(lon)

window.makeBikeRackPanelTranslucent = ->
  panelBody = $("#bike-rack-detailed-info").parent().parent()[0]
  bgStr = $(panelBody).css("background-color")
  bg = bgStr.substring(4, bgStr.length-1).split(", ")
  newBg = "rgba(" + bg[0] + ", " + bg[1] + ", " + bg[2] + ", " + 0.6 + ")"
  $(panelBody).css("background-color", newBg)
  console.log bgStr + " " + newBg + " " + $(panelBody).css("background-color")
  return

$(document).on 'ready page:load', ->
  loadGoogleMaps()
  makeBikeRackPanelTranslucent()
  return
