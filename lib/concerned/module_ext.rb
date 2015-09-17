class Module
  def concerned_with(*concerns)
    options = concerns.extract_options!
    concerns.flatten.each do |concern|
      next if concern.blank?
      if options[:require]
        require_concern name, concern
      else
        include_concern name, concern
      end
    end
    shared_concerns([options[:shared]].flatten.compact)
  end

  def shared_concerns(*concerns)
    concerns.flatten.each do |concern|
      next if concern.blank?
      Concerned.require_shared concern
    end
  end

  def include_concerns(*concerns)
    options = concerns.extract_options!
    scope_name = name if options[:ns] == true
    scope_name ||= options[:for] || options[:from] || options[:ns]

    concerns.flatten.each do |concern|
      next if concern.blank?
      require_concern scope_name, concern if options[:require]

      concern_ns ||= if scope_name
         [scope_name.to_s.camelize, concern.to_s.camelize].join('::')
      else
        concern.to_s.camelize
      end

      self.send :include, concern_ns.constantize

      if Concerned.extend_enabled?
        begin
          self.extend [concern_ns, 'ClassMethods'].join('::').constantize
        rescue
        end
      end
    end

    class_eval do
      self.my_concerns += concerns.flatten if self.respond_to?(:my_concerns)
    end

    include_shared_concerns([options[:shared]].flatten.compact)
  end

  def include_shared_concerns(*concerns)
    concerns.flatten.each do |concern|
      next if concern.blank?
      Concerned.require_shared concern
      concern_ns = concern.to_s.camelize

      self.send :include, Concerned.shared_const(concern_ns)

      if Concerned.extend_enabled?
        begin
          self.extend [concern_ns, 'ClassMethods'].join('::').constantize
        rescue
        end
      end
    end

    class_eval do
      self.my_shared_concerns += concerns.flatten if self.respond_to?(:my_shared_concerns)
    end
  end

  alias_method :shared_concern, :shared_concerns
  alias_method :include_concern, :include_concerns
  alias_method :include_shared_concern, :include_shared_concerns
  alias_method :include_shared, :include_shared_concerns

  protected

  def require_concern name, concern
    require_method "#{name.to_s.underscore}/#{concern.to_s.underscore}"
  end

  def require_method path
    defined?(require_dependency) ? require_dependency(path) : require(path)
  end
end
