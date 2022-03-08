class TestCompletionJob < ApplicationJob
  queue_as :default

  def test
    @test ||= Test.find(@test_id)
  end

  def step
    @step ||= Step.find(@step_id)
  end
  
  def perform(logger, test_id, step_id)
    @test_id = test_id
    @step_id = step_id
    step.update(:status => Step::Status::SUCCEED)
    logger.info "Test Id : #{test_id} Step Id : #{ step.id } Message : Completed"
    total_jobs = Step.where(:test_id => test_id).count
    completed_jobs = Step.where(:test_id => test_id, status: Step::Status::SUCCEED).count
    failed_jobs = Step.where(:test_id => test_id, status: Step::Status::FAILED).count
    
    if total_jobs == ( completed_jobs + failed_jobs )
      #Url.url_site_data_info_update(test_id, logger)
      test.update(:status => Test::Status::COMPLETED)
      logger.info "Test Id : #{test_id} Message : Completed"
    end
  rescue => e
    step.update(:status => Step::Status::FAILED)
    logger.info "Test Id : #{test_id} Step Id : #{step_id} Error : #{e}"
  end

end
