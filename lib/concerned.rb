require 'concerned/module_ext'

module Concerned
  class << self
    def require_shared concern
      require_method "shared/#{concern.to_s.underscore}"
    end

    def shared_const concern_ns
      concern_ns.constantize
    rescue NameError
      shared_ns_const concern_ns
    end

    def shared_ns_const concern_ns
      const_name = "Shared::#{concern_ns}"
      const_name.constantize
    rescue NameError
      raise "No module could be found for: #{concern_ns} or #{const_name}"
    end

  end
end