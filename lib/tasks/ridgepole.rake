namespace :ridgepole do
  desc "ridgepole --apply"
  task 'apply' => :environment do
    exec "bundle exec ridgepole -c #{Rails.root}/config/database.yml -E #{Rails.env} -f #{Rails.root}/Schemafile --apply"
  end

  desc "ridgepole --apply --dry-run"
  task 'status' => :environment do
    exec "bundle exec ridgepole -c #{Rails.root}/config/database.yml -E #{Rails.env} -f #{Rails.root}/Schemafile --apply --dry-run"
  end
end
