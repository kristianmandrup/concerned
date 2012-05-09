class Module
  def concerned_with(*concerns)
    options = concerns.extract_options!
    concerns.flatten.each do |concern|
      next if concern.blank?
      require_concern name, concern
    end
    shared_concerns([options[:shared]].flatten.compact)
  end

  def include_concerns(*concerns)
    options = concerns.extract_options!
    concerns.flatten.each do |concern|
      next if concern.blank?
      require_concern name, concern
      concern_ns = [name, concern.to_s.camelize].join('::')
      self.send :include, concern_ns.constantize
      begin
        self.extend [concern_ns, 'ClassMethods'].join('::').constantize
      rescue
      end
    end
    include_shared_concerns([options[:shared]].flatten.compact)
  end

  def shared_concerns(*concerns)
    concerns.flatten.each do |concern|
      next if concern.blank?
      Concerned.require_shared concern
    end
  end

  def include_shared_concerns(*concerns)
    concerns.flatten.each do |concern|
      next if concern.blank?
      Concerned.require_shared concern
      concern_ns = concern.to_s.camelize

      self.send :include, Concerned.shared_const(concern_ns)

      begin
        self.extend [concern_ns, 'ClassMethods'].join('::').constantize
      rescue
      end
    end
  end

  alias_method :shared_concern, :shared_concerns
  alias_method :include_concern, :include_concerns
  alias_method :include_shared_concern, :include_shared_concerns

  protected

  def require_concern name, concern
    require_method "#{name.underscore}/#{concern.to_s.underscore}"
  end 

  def require_method path
    defined?(require_dependency) ? require_dependency(path) : require(path)
  end
end
