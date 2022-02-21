class TestCompletionJob < ApplicationJob
  queue_as :default

  def perform(logger, test_id, step_id)
    Step.find(step_id).update(:status => 2)
    active_job = Step.where(test_id: test_id, status: 1)
    if active_job.size == 0
      Test.find(test_id).update(:status => '1')
      Url.url_site_data_info_update(test_id, logger)
    end
  rescue => e
    Step.find(step_id).update(:status => '3')
    Test.find(test_id).update(:status => '2')
    logger.info "error in test completion #{e}"
  end
end
