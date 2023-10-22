# frozen_string_literal: true

module Types
  class UserErrorType < Types::BaseObject
    description "A user-readable error"

    field :message, String, "A description of the error", null: false
    field :path, [String], "Which input value this error came from", null: true
  end
end
