namespace :ridgepole do
  desc "ridgepole --apply"
  task 'apply' => :environment do
    system "bundle exec ridgepole -c #{Rails.root}/config/database.yml -E #{Rails.env} -f #{Rails.root}/Schemafile --apply"
    Rake::Task["db:seed_fu"].invoke
  end

  desc "ridgepole --apply --dry-run"
  task 'status' => :environment do
    system "bundle exec ridgepole -c #{Rails.root}/config/database.yml -E #{Rails.env} -f #{Rails.root}/Schemafile --apply --dry-run"
  end
end
