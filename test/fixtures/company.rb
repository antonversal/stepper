class Company < ActiveRecord::Base
  has_steps :current_step_column => :my_step, :steps => ["step1", "step2", "step3"]
end