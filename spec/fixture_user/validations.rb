class FixtureUser
  def method_from_validations_concern
  end
end

class FixtureUser
  module Validations
    def validate!
      true
    end
  end
end