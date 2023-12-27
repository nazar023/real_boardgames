# frozen_string_literal: true

module Stripe # :nodoc:
  # Webhooks activity handler from stripe
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil
      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, Rails.application.credentials.stripe.endpoint
        )
      rescue JSON::ParserError => e
        # Invalid payload
        status 400
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        status 400
        return
      end

      # Handle the event
      case event.type
      when 'payment_intent.succeeded'
        # payment_intent = event.data.object
      when 'customer.created'
        customer = event.data.object
        user = User.find_by(email: customer.email)
        user.update(stripe_customer_id: customer.id)
      when 'customer.subscription.deleted', 'customer.subscription.updated','customer.subscription.created'
        subscription = event.data.object
        user = User.find_by(stripe_customer_id: subscription.customer)

        case subscription.items.data[0].price.lookup_key
        when 'knight'
          user&.knight!
        when 'king'
          user&.king!
        end

        user&.update(subscription_status: subscription.status,
                     subscription_ends_at: Time.at(subscription.current_period_end).to_datetime)
      else
        puts "Unhandled event type: #{event.type}"
      end

      render json: { message: 'Success' }
    end
  end
end
