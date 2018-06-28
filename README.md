# ActiveRecordErrorAddingExtension

A DSL that makes custom validations and `before_*` easier to read.

## Summary 

```
class User < ActiveRecord::Base
  before_save :before_save_run_callback

  def before_save_run_callback
    add_error_for(:some_attribute).if failure_running callback
  end
  
  def before_save_no_bobs
    add_error_for(:name).if user.name == 'bob'
  end
  
  private
  
  def callback
    # bulk of the method
    
    if success
      return [true, '']
    else
      return [false, 'awesome error message']
    end
  end
  
end
```

```
pry> user = User.new
pry> user.name = 'bob'
pry> user.save!
pry> user.errors.messages
=> {:some_attribute=>["awesome error message"], :name=>["default error message"]}

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_error_adding_extension'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_error_adding_extension


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rickgorman/active_record_error_adding_extension.
