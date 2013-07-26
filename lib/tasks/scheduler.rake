desc "This task is for managing the payments"

task :payments => :environment do
  if Time.now.friday?
    Payment.charge_all_users
  end
end

task :fetch_activities => :environment do
  puts "Saving latest activity data..."
  Activity.save_latest_activity
  puts "Activity data fetched and saved."
end
