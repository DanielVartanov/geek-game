require 'active_support/core_ext/object/try'
require 'active_support/core_ext/object/blank'

module GeekGame
  module Connectable
    attr_reader :connection

    def connect_to(facility)
      return connection if connection
      Connection.new bot: self, facility: facility
    end

    def accept_connection(connection)
      self.connection = connection
    end

    def connected_facility
      connection.try(:facility)
    end

    def connected_to_facility?
      connection.present?
    end

    protected

    attr_writer :connection
  end
end
