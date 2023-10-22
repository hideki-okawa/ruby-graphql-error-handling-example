# frozen_string_literal: true
module Mutations
  class CreateSample < BaseMutation
    description 'サンプルを作成する'

    argument :name, String, required: true, description: 'サンプル名'

    field :sample, Types::SampleType, null: true, description: '作成したサンプル'
    field :user_errors, [Types::UserErrorType], null: false, description: 'ユーザーエラー'

    def resolve(name:)
      sample = Sample.new(name:)

      if sample.save
        { sample: sample, user_errors: [] }
      else
        debugger
        errors = sample.errors.details.map do |attribute, message|
          {
            message: sample.errors.full_messages_for(attribute).join(", "),
            path: [attribute.to_s]
          }
        end
        { sample: nil, user_errors: errors }
      end
    end
  end
end
