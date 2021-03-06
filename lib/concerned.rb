require 'concerned/module_ext'

module Concerned
  def self.included(base)
    base.extend MetaMethods
  end

  module MetaMethods
    attr_writer :my_concerns, :my_shared_concerns

    def all_my_concerns
      my_concerns + my_shared_concerns
    end

    def my_concerns
      @my_concerns ||= []
    end

    def my_shared_concerns
      @my_shared_concerns ||= []
    end
  end

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

    def extend_enable!
      @extend_enabled = true
    end

    def extend_disable!
      @extend_enabled = false
    end

    def extend_enabled?
      @extend_enabled
    end
  end
end