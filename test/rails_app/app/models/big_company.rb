class BigCompany < Company
  has_steps :current_step_column => :my_step, :steps => ["step4", "step5", "step6"]

end