require 'spec_helper'
require 'rails'
require 'concerned'
require 'active_support/dependencies'

# The same procedure as one that needed for common #require - It should know path.
$:.unshift File.dirname __FILE__

require 'fixture_user/scopes'
require 'fixture_user/validations'

class FixtureUser
  include Concerned

  concerned_with :scopes, :validations
  shared_concerns :associations
  include_shared_concerns :caching
  include_concerns :validations
end

class FixtureUserNoMeta
  concerned_with :scopes, :validations
  shared_concerns :associations
  include_shared_concerns :caching
  include_concerns :validations
end

class FixtureUserFor
  include_concerns :foo, for: 'fixture_user'
end

class FixtureUserFrom
  include_concerns :bar, from: 'fixture_user'
end


describe 'shared concerns' do
  it 'should require it' do
    expect(Assoc.abc).to be true
  end
end

describe "Concerned" do
  describe "using :for" do
    it 'should include Foo module' do
      FixtureUserFor.new.should respond_to(:foo)
    end
  end

  describe "using :from" do
    it 'should include Foo module' do
      FixtureUserFrom.new.should respond_to(:bar)
    end
  end
end

describe "Concerned" do
  describe "no meta" do
    it 'should not have meta info' do
      FixtureUserNoMeta.should_not respond_to(:my_concerns)
      FixtureUserNoMeta.should_not respond_to(:my_shared_concerns)
      FixtureUserNoMeta.should_not respond_to(:all_my_concerns)
    end
  end
end

describe "Concerned" do
  describe "#concerned_with" do
    it 'should require files from #{name.to_s.underscore}/#{concern}' do
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
