# frozen_string_literal: true
class RailsGraphqlTemplateSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  max_complexity 200
  max_depth 20

  use GraphQL::Batch

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  rescue_from(ActiveRecord::RecordInvalid) do |err, obj, args, ctx, field|
    # Raise a graphql-friendly error with a custom message
    raise GraphQL::ExecutionError.new("", extensions: { code: "RECORD_INVALID", full_messages: err.record.errors.full_messages })
  end

  # Union and Interface Resolution
  def self.resolve_type(_abstract_type, _obj, _ctx)
    # TODO: Implement this method
    # to return the correct GraphQL object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, _type_definition, _query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Given a string UUID, find the object
  def self.object_from_id(global_id, _query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  end
end
