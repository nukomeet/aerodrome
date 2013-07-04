class TwitterFollowersCount
  include Sidekiq::Worker
  include App::Base

  sidekiq_options queue: :kokpit

  # params: Hash
  #   id (required): name of the widget on the screen
  #   handle (required): Twitter account to count followers
  def perform(params)
    name = URI::encode(params['handle'])
    response = HTTParty.get("https://twitter.com/users/#{name}.json")

    if response.code == 200
      count = JSON.parse(response.body)['followers_count']
    else
      count = 0
    end

    self.enqueue(params['id'], { value: count })
  end
end
