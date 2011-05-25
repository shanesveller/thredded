namespace :db do

  desc "Bootstrap and seed the database with your messageboard's information"
  task :bootstrap => :environment do
    require "thredded/setup"
    Thredded::Setup.bootstrap(
      :username     => ENV['USER_NAME'],
      :email        => ENV['USER_EMAIL'],
      :password     => ENV['USER_PASS'],
      :sitename     => ENV['BOARD_SITE'],
      :messageboard => ENV['BOARD_NAME'],
      :security     => ENV['BOARD_SECURITY'],
      :permission   => ENV['BOARD_PERMISSION']
    )
  end

  namespace :seed do
    desc "Randomly generate 50 threads with 3 posts by random people"
    task :fakes => :environment do
      require "thredded/setup"
      Thredded::Setup.with_fake_threads
    end
  end

end
