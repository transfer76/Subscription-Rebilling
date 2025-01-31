# frozen_string_literal: true

# Class Subscription allows database access to subscriptions table
class Subscription
  attr_accessor :id, :amount

  def initialize(id, amount)
    @id = id
    @amount = amount
  end
end
