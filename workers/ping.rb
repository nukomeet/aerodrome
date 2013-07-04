class Ping
  include Sidekiq::Worker
  include App::Base

  sidekiq_options queue: :kokpit

  def perform(params)
    self.enqueue(params['id'], { value: rand(100) })
  end
end
