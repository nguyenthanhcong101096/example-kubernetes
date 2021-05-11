# frozen_string_literal: true

class DemoScheduleWorker
  include Sidekiq::Worker

  sidekiq_options queue: "demo"

  def perform
    count = Count.find_or_initialize_by(name: "k8s")
    count.increment(:view_count, 1)
    count.save!
  end
end
