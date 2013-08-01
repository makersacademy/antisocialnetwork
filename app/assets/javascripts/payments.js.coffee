# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  payment.setupForm()

payment =
  setupForm: ->
    $('#payment_form').submit ->
      console.log("form submitted")
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        payment.processCard()
        false
      else
        false

  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, payment.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#stripe_card_token').val(response.id)
      $('#payment_form')[0].submit()
    else
      $('#stripe_error').append('<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button>' + response.error.message + '</div>')
      $('input[type=submit]').attr('disabled', false)