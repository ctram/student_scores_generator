require_relative "../../lib/student_score_generator"

# class MyController < ActionController::Base
#   include ActionController::Live
#
#   def stream
#     response.headers['Content-Type'] = 'text/event-stream'
#     100.times {
#       response.stream.write "hello world\n"
#       sleep 1
#     }
#   ensure
#     response.stream.close
#   end
# end

class StudentScoresController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 300)

    counter = 0

    loop do |x|
      sse.write(StudentScoreGenerator.instance.latest_scores!)
      counter += 1
      sleep(5)
    end
  ensure
    sse.close
  end
end
