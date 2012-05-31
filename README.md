# Concerned

Use the "concerns" pattern in any Ruby or Rails project.

## Rails 3

In Gemfile:

`gem 'concerned'`

### Usage

This gem comes with the following three helpers, that are added to `Module`.
To require concern modules (or classes)

* concerned_with
* shared_concerns

And to include concern modules

* include_concerns
* include_shared_concerns

The `concerned_with` helper method expects to find a module or class matching the current namespace, fx the following will include `FixtureUser::Scopes` and `FixtureUser::Validations` into `FixtureUser`.

```ruby
class FixtureUser
  include_concerns :scopes, :validations  
end
```

The `include_shared_concerns` expects to find a module in a `shared` folder somewhere in the _load path_ that has a name of either `Caching` or `Shared::Caching` for the following example:

```ruby
class FixtureUser
  include_shared_concerns :caching
end
```

The `concerned_with` and `shared_concerns` methods are used simply to require shared files following the namespace convention, here: `project/job_matches` and `shared/associations`.

```ruby
class Project
  concerned_with :job_matches
  shared_concerns :associations
end
```

## Concerns currently included

You can now include the Concerned module in your class or module and get acces to the meta-info: which concerns are currently included

```ruby
class FixtureUser
  include Concerned
  include_concerns :scopes, :validations 
  include_shared_concerns :caching 
end
```

```ruby
FixtureUser.my_concerns # => [:scopes, :validations]
FixtureUser.my_shared_concerns # => [:caching]
FixtureUser.all_my_shared_concerns # => [:scopes, :validations, :caching]
```

## Global config

You can use the `Concerned.extend_enable!` to let the concern helpers also attempt to extend the host module/class with the ClassMethods module of the concerns module (if such exists). Disable it by using: `Concerned.extend_disable!`

Use `Concerned.extend_enabled?` to see if it is currently enabled or not.
By default this feature is turned off. 

It is usually better to use `ActionSupport::Concern` using `extend ActiveSupport::Concern`. 

See fx [concerns](http://www.fakingfantastic.com/2010/09/20/concerning-yourself-with-active-support-concern/)

## Contributing to concerned
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Kristian Mandrup. See LICENSE.txt for
further details.

