class Order < ActiveRecord::Base
  has_steps :steps => ["step1", "step2", "step3"]
end