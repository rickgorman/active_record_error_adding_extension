require "active_record_error_adding_extension/version"

module ActiveRecordErrorAddingExtension
  extend ActiveSupport::Concern

  def add_error_for(error_attribute, &block)
    AddErrorForExpectationTarget.new(self, error_attribute, block)
  end

  def failure_running(&block)
    FailureRunningMatcher.new(block).call
  end

  class ExpectationTarget
    attr_reader :args

    def if(*optional_args, &matcher)
      if block_given?
        result = yield
        positive_call(result)
      elsif optional_args.count == 1
        positive_call(optional_args[0])
      else
        raise 'no params passed in to the matcher'
      end
    end
  end

  class AddErrorForExpectationTarget < ExpectationTarget
    attr_reader :obj, :error_attribute, :block

    def initialize(obj, error_attribute, block)
      @obj = obj
      @error_attribute = error_attribute
      @block = block
    end

    def positive_call(*args)
      return_value = args[0]
      error = args[1]
      if error.nil?
        error = 'default error message'
      end

      add_error(error_attribute, error) if return_value
    end

    private

    def add_error(error_attribute, message)
      @obj.errors.add(error_attribute, message)
    end
  end

  class BaseMatcher
  end

  class FailureRunningMatcher < BaseMatcher
    attr_reader :block

    def initialize(block)
      @block = block
    end

    def call
      success, error = block.call

      # here we answer the question, 'did this call?'
      if success
        # no failure
        false
      else
        # failure
        [true, error]
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordErrorAddingExtension)
