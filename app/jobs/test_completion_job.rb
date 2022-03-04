class TestCompletionJob < ApplicationJob
  queue_as :default

  

  def perform(logger, test_id, step_id)
    Step.find(step_id).update(:status => Step::Status::COMPLETED)
    logger.info "Test Id: #{test_id} \nStep Id : #{step_id} \nMessage: Step completed"
    total_jobs = Step.where(:test_id => test_id).count
    completed_jobs = Step.where(:test_id => test_id, status: Step::Status::COMPLETED).count
    if total_jobs == completed_jobs
      Test.find(test_id).update(:status => Test::Status::COMPLETED)
      Url.url_site_data_info_update(test_id, logger)
    end
  rescue => e
    Step.find(step_id).update(:status => Step::Status::FAILED)
    Test.find(test_id).update(:status => Test::Status::FAILED)
    logger.info "Test Id: #{test_id} \nStep Id: #{step_id} \nError: #{e}"
  end

end
