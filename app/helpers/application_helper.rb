module ApplicationHelper

  def recent_activity_cost(user, amount=50)
    period = Payment.users_current_payment_period(user)
    activity = user.activities.where(:activity_updated_time => period).count
    activity * amount / 100.00
  end  

  def total_donations(user)
    if user.payments.length > 0
      payments = user.payments
      sum_of_payments = payments.sum(:bill_amount)
      sum_of_payments / 100.00
    else
      0
    end
  end
 
end

