class TestCompletionJob < ApplicationJob
  queue_as :default

  def perform(logger, test_id, step_id)
    Step.find(step_id).update(:status => Step::STATUS.invert[:COMPLETED])
    active_job = Step.where(test_id: test_id, status: Step::STATUS.invert[:RUNNING])
    if active_job.size == 0
      Test.find(test_id).update(:status => Test::STATUS.invert[:COMPLETED])
      Url.url_site_data_info_update(test_id, logger)
    end
  rescue => e
    Step.find(step_id).update(:status => Step::STATUS.invert[:FAILED])
    Test.find(test_id).update(:status => Test::STATUS.invert[:FAILED])
    logger.info "error in test completion #{e}"
  end
end
