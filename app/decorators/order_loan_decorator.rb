class OrderLoanDecorator < Draper::Decorator
  delegate_all

  delegate :title, to: :loan, prefix: true

	def unit_price_decimal
    h.price_in_decimal(object.unit_price)
	end

  def unit_price_dollars
    h.price_in_dollars(object.unit_price)
  end

	def subtotal
    h.price_in_dollars(object.unit_price * quantity)
	end
end
