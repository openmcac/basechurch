require "tasks/migrate_sermons"
namespace :sermons do
  desc "Convert bulletins into sermons"
  task migrate: :environment do
    MigrateSermons.new.process
  end
end
