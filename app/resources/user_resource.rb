# frozen_string_literal: true

class UserResource < ApplicationResource
  with_id

  attributes :name, :email
end
