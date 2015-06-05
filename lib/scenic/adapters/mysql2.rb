module Scenic
  module Adapters
    module Mysql2
      def self.views
        execute(<<-SQL).map { |result| Scenic::View.new(prepare_result(result)) }
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

      def self.prepare_result(result)
        HashWithIndifferentAccess.new(
          viewname: result[0],
          definition: parse_definition(result[1], result[2])
        )
      end

      def self.parse_definition(definition, dbname)
        definition.split(/`#{dbname}`\./).join('').strip
      end

      def self.execute(sql, base = ActiveRecord::Base)
        base.connection.execute sql
      end
    end
  end
end
