class TestCompletionJob < ApplicationJob
  queue_as :default

  def test
    @test ||= V2::Test.find(@test_id)
  end

  def step
    @step ||= V2::Step.find(@step_id)
  end

  def perform(logger, test_id, step_id)
    @test_id = test_id
    @step_id = step_id
    step.update(:status => V2::Step::Status::SUCCEED)
    logger.info "Test Id : #{test_id} Step Id : #{ step.id } Message : Completed"
    total_jobs = V2::Step.where(:test => test_id)
    completed_jobs = total_jobs.completed
    if (total_jobs.count - completed_jobs.count) == 0
      #Url.url_site_data_info_update(test_id, logger)
      test.update(:status => V2::Test::Status::COMPLETED)
      logger.info "Test Id : #{test_id} Message : Completed"
    end
  rescue => e
    step.update(:status => V2::Step::Status::FAILED)
    logger.info "Test Id : #{test_id} Step Id : #{step_id} Error : #{e.message} Backtrace : #{e.backtrace}"
  end

end
