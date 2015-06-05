require "rails"

module Scenic
  module SchemaDumper
    extend ActiveSupport::Concern

    included { alias_method_chain :tables, :views }

    def tables_with_views(stream)
      tables_without_views(stream)
      views(stream)
    end

    def views(stream)
      views_in_database.each do |view|
        stream.puts(view.to_schema)
      end
    end

    def views_in_database
      @views_in_database ||= Scenic.database.views.sort
    end
  end
end
