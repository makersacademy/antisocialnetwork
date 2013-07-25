desc "This task is for managing the payments"

task :payments => :environment do
  if Time.now.friday?
    Payment.charge_all_users
  end
end