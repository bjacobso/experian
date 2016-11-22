require 'test_helper'

describe Experian::BusinessIq::Request do

  it "creates a request in xml format" do

    client = Experian::BusinessIq::Client.new

    params = {
      business_name: '1400 WILLOW COUNCIL OF CO-OWNERS, IN',
      street: '1400 WILLOW AVE OFC',
      city: 'LOUISVILLE',
      state: 'KY',
      zip: '40204',
    }

    # resp = client.get_premier_profile(params)
  end

end
