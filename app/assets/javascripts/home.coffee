# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('.most-popular-carousel').slick
    infinite: true
    accessibility: true
    autoplay: true
    adaptiveHeight: true
    autoplaySpeed: 3000
    asNavFor: '.most-popular-carousel-nav'

  $('.most-popular-carousel-nav').slick
    asNavFor: '.most-popular-carousel'
    slidesToShow: 4
    slidesToScroll: 1
    vertical: true

  $('.organizations-carousel').slick
    slidesToShow: 9
    slidesToScroll: 1
    infinite: true
    autoplay: true
    autoplaySpeed: 2000
    vertical: false
  return