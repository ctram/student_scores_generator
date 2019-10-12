require 'faker'
require 'singleton'

class StudentScoreGenerator
  include Singleton

  def initialize
    @store = []
  end

  def start
    should_run = true

    Thread.new do
      while should_run
        @store << { name: Faker::Name.name, email: Faker::Internet.email }
        sleep(1)
      end
    end

    Proc.new do
      should_run = false
    end
  end

  def latest_scores!
    copy = @store
    @store = []
    copy
  end
end
