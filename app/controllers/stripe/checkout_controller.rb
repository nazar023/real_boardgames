# frozen_string_literal: true

module Stripe # :nodoc:
  # Checkout Contoller
  class CheckoutController < ApplicationController
    before_action :authenticate_user!, only: %i[pricing]

    def pricing
      lookup_keys = %w[knight king]
      @prices = Stripe::Price.list(lookup_keys:,
                                   active: true,
                                   expand: ['data.product']).data.sort_by(&:unit_amount)
    end

    def create
      session = Stripe::Checkout::Session.create({
        customer: current_user.stripe_customer_id,
        mode: 'subscription',
        line_items: [{
          quantity: 1,
          price: params[:price_id]
        }],
        success_url: stripe_success_url,
        cancel_url: stripe_failure_url,
      })

      redirect_to session.url, allow_other_host: true
    end

    def success
      flash[:notice] = 'success'
      redirect_to pricing_path
    end

    def failure
      flash[:alert] = 'failure'
      redirect_to pricing_path
    end

  end
end
