module ApplicationHelper

  def recent_activity_cost(user, amount=50)
    if user.payments.length > 0
      payment = user.payments.last.created_at
      activity = user.activities.where(:created_at => payment..DateTime.now).count
      activity * amount / 100.00
    else
      join_date = user.created_at
      activity = user.activities.where(:created_at => join_date..DateTime.now).count
      activity * amount / 100.00
    end
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

