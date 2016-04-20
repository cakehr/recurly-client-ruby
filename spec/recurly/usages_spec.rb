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

  let(:usage) do
    subscription = Subscription.find 'abcdef1234567890'

    # Select your add on by the code you want
    sub_add_on = subscription.subscription_add_ons.detect do |add_on|
      add_on.add_on_code == 'marketing_email'
    end

    sub_add_on.usages.build
  end

  describe ".build" do
    it "must be able to build" do
      usage.must_be_instance_of Usage
    end
  end

  describe ".to_xml" do
    it "must serialize to correct xml" do
      time = DateTime.now
      usage.amount = 10
      usage.merchant_tag = "10 emails delivered for merchant"
      usage.recording_timestamp = time
      usage.usage_timestamp = time
      usage.to_xml.must_equal <<XML.chomp
<usage>\
<amount>10</amount>\
<merchant_tag>10 emails delivered for merchant</merchant_tag>\
<recording_timestamp>#{time}</recording_timestamp>\
<usage_timestamp>#{time}</usage_timestamp>\
</usage>
XML
    end
  end
end
