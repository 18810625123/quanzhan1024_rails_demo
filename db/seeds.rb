
if ARGV[0] == 'all'
  puts 'all'
  sleep 2
  require "#{Rails.root}/db/seeds/users.rb"
  require "#{Rails.root}/db/seeds/curriculums.rb"
  require "#{Rails.root}/db/seeds/comments.rb"
  require "#{Rails.root}/db/seeds/blogs.rb"
  require "#{Rails.root}/db/seeds/messages.rb"
  require "#{Rails.root}/db/seeds/orders.rb"
else
  puts ARGV
  sleep 2
  ARGV.each do |a|
    require "#{Rails.root}/db/seeds/#{a}.rb"
  end
end
