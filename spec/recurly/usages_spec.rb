require 'spec_helper'

describe Usage do
  before do
    stub_api_request :get, 'subscriptions/abcdef1234567890', 'subscriptions/show-200'
    stub_api_request(
      :post,
      'subscriptions/abcdef1234567890/add_ons/marketing_email/usages',
      'subscriptions/add_ons/usages/create-201'
    )
  end

  describe ".save" do
    it "must be able to build and save a usage from a susbcription addon" do
      subscription = Subscription.find 'abcdef1234567890'

      # Select your add on by the code you want
      sub_add_on = subscription.subscription_add_ons.detect do |add_on|
        add_on.add_on_code == 'marketing_email'
      end

      usage = sub_add_on.usages.build
      usage.must_be_instance_of Usage
    end
  end
end
