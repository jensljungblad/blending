# frozen_string_literal: true

require "test_helper"

class MatchTest < ActiveSupport::TestCase
  def test_pending_scope_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established)
    )
    assert Match.pending.include?(match)
  end

  def test_pending_scope_not_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established),
      started_at: 1.day.ago
    )
    assert_not Match.pending.include?(match)
  end

  def test_started_scope_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established),
      started_at: 1.day.ago
    )

    assert Match.started.include?(match)
  end

  def test_started_scope_not_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established)
    )

    assert_not Match.started.include?(match)
  end

  def test_active_scope_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established),
      started_at: 1.day.ago,
      concluded_at: 1.day.from_now
    )

    assert Match.active.include?(match)
  end

  def test_active_scope_not_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established)
    )

    assert_not Match.active.include?(match)
  end

  def test_concluded_scope_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established),
      started_at: 1.day.ago,
      concluded_at: 1.day.ago
    )

    assert Match.concluded.include?(match)
  end

  def test_concluded_scope_not_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established)
    )

    assert_not Match.concluded.include?(match)
  end

  def test_follow_up_mails_scope_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established),
      started_at: 1.month.ago,
      concluded_at: 1.day.from_now
    )

    assert Match.follow_up_mails.include?(match)
  end

  def test_follow_up_mails_scope_not_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established),
      started_at: 1.day.ago,
      concluded_at: 1.day.from_now
    )

    assert_not Match.follow_up_mails.include?(match)
  end

  def test_destroy_concluded_to_destroy_scope_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established),
      started_at: 2.months.ago,
      concluded_at: 2.months.ago
    )

    assert Match.concluded_to_destroy.include?(match)
  end

  def test_destroy_concluded_to_destroy_scope_not_included
    match = create_match(
      newcomer: create_person(status: :newcomer),
      established: create_person(status: :established),
      started_at: 1.month.ago,
      concluded_at: 1.week.ago
    )

    assert_not Match.concluded_to_destroy.include?(match)
  end

  def test_destroy_with_people
    person_1 = create_person(status: :newcomer)
    person_2 = create_person(status: :established)
    match = create_match(newcomer: person_1, established: person_2)
    match.destroy_with_people
    assert person_1.destroyed?
    assert person_2.destroyed?
    assert match.destroyed?
  end
end
