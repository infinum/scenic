module Scenic
	module Views
		module Mysql2

		    attr_reader :name, :definition

		    delegate :<=>, to: :name

		    def initialize(view_row)
		      # @todo
		      # pg returns views according to. map for mysql
		      # @name = view_row["viewname"]
		      # @definition = view_row["definition"].strip

		      # mysql hack to make it work
		      @name = view_row[0]
		      @definition = view_row[1].strip
		    end

		    def remove_dbname
		    end

		    def db_name
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
end

