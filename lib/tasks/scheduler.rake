desc "This task is for managing the payments"

task :payments => :environment do
  if Time.now.friday?
    puts "Tom rocks !" 
  end
end