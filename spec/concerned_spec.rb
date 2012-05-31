require 'spec_helper'
require 'rails'
require 'concerned'
require 'active_support/dependencies'

# The same procedure as one that needed for common #require - It should know path.
$:.unshift File.dirname __FILE__

class FixtureUser
  include Concerned

  concerned_with :scopes, :validations
  shared_concerns :associations
  include_shared_concerns :caching
  include_concerns :validations
end

describe "Concerned" do
  describe "#concerned_with" do
    it 'should require files from #{name.underscore}/#{concern}' do
      [:scopes, :validations].each do |concern|
        FixtureUser.new.should respond_to("method_from_#{concern}_concern")
      end

      FixtureUser.my_concerns.should include(:validations)
      FixtureUser.my_shared_concerns.should include(:caching)
      FixtureUser.all_my_concerns.should include(:caching, :validations)
    end
  end 
   
  describe "#include_shared_concerns" do
    it 'should require and include from shared/#{concern}' do
      FixtureUser.new.should respond_to("method_from_shared_concern")
    end
  end
end
