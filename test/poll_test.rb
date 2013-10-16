require_relative './test_helper'

class PollTest < Test::Unit::TestCase

  def setup
    Option.delete_all
    Option.create(pseudo_uid: 1, text: "Lorem")
    Option.create(pseudo_uid: 2, text: "Ipsum")
    Option.create(pseudo_uid: 3, text: "Dolor")
    Option.create(pseudo_uid: 100, parent_uid: 1, text: "Lorem ipsum dolor")
  end

  def test_poll_initializes_with_two_options
    poll = Poll.new
    assert_equal 2, poll.options.length
  end

  def test_poll_may_initialize_with_n_options
    n = 3
    poll = Poll.new(n)
    assert_equal n, poll.options.length
  end

  def test_poll_picks_children
    poll = Poll.new
    assert_equal Option.where(parent_uid: 1).count, poll.pick(1, 1).count
  end

  def test_poll_picks_all_found_options
    poll = Poll.new
    assert_equal Option.where(:parent_uid.exists => false).count, poll.pick(0).count
  end

end

