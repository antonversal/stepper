class OrdersController < ApplicationController
  has_steps :redirect_to => {
      :after_save =>   {:action => :index},
      :after_finish => proc { |controller, resource| controller.order_url(resource.id) }
  }

  def show

  end

  def index

  end
end