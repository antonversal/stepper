class Company < ActiveRecord::Base
  has_steps :current_step_column => :my_step, :steps => ["step1", "step2", "step3"]

  private

    def validate_step1
      self.validates_presence_of :name
    end

    def validate_step2
      self.validates_numericality_of :code
    end

    def validate_step3
      self.validates_presence_of :city
    end

end