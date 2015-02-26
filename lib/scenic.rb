require "scenic/adapters/postgres"
require "scenic/adapters/mysql2"

require "scenic/command_recorder"
require "scenic/definition"
require "scenic/railtie"
require "scenic/schema_dumper"
require "scenic/statements"
require "scenic/version"
require "scenic/view"

module Scenic
  def self.load
    ActiveRecord::ConnectionAdapters::AbstractAdapter.include Scenic::Statements
    ActiveRecord::Migration::CommandRecorder.include Scenic::CommandRecorder
    ActiveRecord::SchemaDumper.include Scenic::SchemaDumper
  end

  def self.database
    adapter_type = ActiveRecord::Base.connection.adapter_name.downcase.to_sym

    case adapter_type
    when :mysql2
      Scenic::Adapters::Mysql2
    when :postgresql
      Scenic::Adapters::Postgres
    else
      raise NotImplementedError, "Unknown adapter type '#{adapter_type}'"
    end
  end
end
