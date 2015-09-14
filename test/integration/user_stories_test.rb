require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  LineItem.delete_all
  Order.delete_all
  ruby_book = products(:ruby)

  get '/'
  assert_response :success
  assert_template "index"

  post_via_redirect "/orders",
      order: {name: "Kane Nguyen",
      address: "123 Hidden Street",
      email: "khanhthietbi@gmail.com",
      pay_type: "Check"}
  assert_response :success
  assert_template "index"
  cart = Cart.find(session[:cart_id])
  assert_equal 0, cart.line_items.size

  orders = Order.all
  assert_equal 1, orders.size
  order = order[0]

  assert_equal "Kane Nguyen", order.name
  assert_equal "123 Hidden Street", order.address
  assert_equal "khanhthietbi@gmail.com", order.email
  assert_equal "Check", order.pay_type

  assert_equal 1, order.line_items.size
  line_item = order.line_items[0]
  assert_equal ruby_book, line_item.product
end
