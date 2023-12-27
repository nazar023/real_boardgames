# frozen_string_literal: true

module Stripe # :nodoc:
  # Webhooks activity handler from stripe
  class BillingPortalController < ApplicationController
    def create
      session = Stripe::BillingPortal::Session.create({
                                                        customer: current_user.stripe_customer_id,
                                                        return_url: pricing_url
                                                      })
      redirect_to session.url, allow_other_host: true
    end
  end
end
