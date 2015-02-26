module Scenic
  class View
    attr_reader :name, :definition, :dbname

    delegate :<=>, to: :name

    def initialize(view_row)
      # @todo
      # pg returns views according to. map for mysql
      # @name = view_row["viewname"]
      # @definition = view_row["definition"].strip

      # mysql hack to make it work
      @name = view_row[0]
      @dbname = view_row[2]
      @definition = parse_definition(view_row[1].strip, @dbname)
    end

    def parse_definition(definition, dbname)
      # initial
      # "select `some_db_name`.`dealerships`.`id` AS `id` from `some_db_name`.`dealerships` " 
      
      # final
      # "select `dealerships`.`id` AS `id` from `dealerships`" 
      re = /`#{dbname}`\./
      definition.split(re).join("").strip
    end

    def ==(other)
      name == other.name && 
        definition == other.definition
    end

    def to_schema
       <<-DEFINITION.strip_heredoc
        create_view :#{name}, sql_definition:<<-\SQL
          #{definition}
        SQL

      DEFINITION
    end
  end
end
