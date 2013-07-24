module Helpers
  
  def stub_stripe       
    Stripe::Charge.stub(:create) {}
  end
  
end  