# every 1.day, :at => '0:00 am', :roles => [:whenever] do
#   runner "Course.notify_starting", environment: 'release'
#   runner "Course.notify_will_start", environment: 'release'
# end