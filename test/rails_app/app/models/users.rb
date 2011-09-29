class User < ActiveRecord::Base
  has_steps :steps => ["step1", "step2"]
end