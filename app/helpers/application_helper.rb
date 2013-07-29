module ApplicationHelper

  def recent_activity_cost(user, amount=50)
    if user.payments.length > 0
      payment = user.payments.last
      activity = user.activities.where(:created_at => payment.created_at..DateTime.now).count
      activity * amount / 100
    else
      join_date = user.created_at
      activity = user.activities.where(:created_at => join_date..DateTime.now).count
      activity * amount / 100
    end
  end  

end

