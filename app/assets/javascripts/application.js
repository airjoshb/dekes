// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require materialize-sprockets
//= require_tree .

$('.registrations').ready(function() {
  $.externalScript('https://js.stripe.com/v2/').done(function(script, textStatus) {
      Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
      var subscription = {
        setupForm: function() {
          return $('.card_form').submit(function() {
            $('input[type=submit]').prop('disabled', true);
            if ($('#card_number').length) {
              subscription.processCard();
              return false;
            } else {
              return true;
            }
          });
        },
        processCard: function() {
          var card;
          card = {
            name: $('#user_name').val(),
            number: $('#card_number').val(),
            cvc: $('#card_code').val(),
            expMonth: $('#card_month').val(),
            expYear: $('#card_year').val(),
            address_line1: $('#address_line1').val(),
            address_line2: $('#address_line2').val(),
            address_city: $('#city').val(),
            address_state: $('#state').val(),
            address_zip: $('#zip').val()

          };
          return Stripe.createToken(card, subscription.handleStripeResponse);
        },
        handleStripeResponse: function(status, response) {
          if (status === 200) {
            $('#user_stripe_token').val(response.id)
            $('.card_form')[0].submit()
          } else {
            $('#stripe_error').text(response.error.message).show();
            return $('input[type=submit]').prop('disabled', false);
          }
        }
      };
      return subscription.setupForm();
  });
});
