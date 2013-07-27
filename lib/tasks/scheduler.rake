desc "This task is for managing the payments"

task :payments => :environment do
  if Time.now.friday?
    Payment.charge_all_users
  end
end

task :fetch_activities => :environment do
  puts "Fetching and saving latest activity data from the last 1 to 2 hours..."
  Activity.save_latest_activity(2.hours)
  puts "Activity data retrieval and saving task complete."
end
