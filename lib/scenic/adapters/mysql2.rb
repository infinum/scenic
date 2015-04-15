module Scenic
  module Adapters
    module Mysql2
      def self.views
        execute(<<-SQL).map { |result| Scenic::View.new(result) }
          SELECT TABLE_NAME, VIEW_DEFINITION, TABLE_SCHEMA 
          FROM information_schema.VIEWS 
          WHERE TABLE_SCHEMA = DATABASE();
        SQL
      end

      def self.create_view(name, sql_definition)
        execute "CREATE OR REPLACE VIEW #{name} AS #{sql_definition};"
      end

      def self.drop_view(name)
        execute "DROP VIEW #{name};"
      end

      private

      def self.execute(sql, base = ActiveRecord::Base)
        base.connection.execute sql
      end
    end
  end
end