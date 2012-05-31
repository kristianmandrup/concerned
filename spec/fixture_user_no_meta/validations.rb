class FixtureUserNoMeta
  def method_from_validations_concern
  end
end

class FixtureUserNoMeta
  module Validations
    def validate!
      true
    end
  end
end