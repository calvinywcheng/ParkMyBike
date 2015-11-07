# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initialize = ->
  mapOptions =
    zoom: 13
    center: new google.maps.LatLng(49.27, -123.16338)
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  return

$(document).on 'ready page:load', ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDjOrbjfVvqyAucNEt1tP7rC-HfhvdyY1o&callback=initialize"
  document.body.appendChild script
  return
