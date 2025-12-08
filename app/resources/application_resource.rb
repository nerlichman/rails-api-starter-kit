# frozen_string_literal: true

class ApplicationResource
  include Alba::Resource

  helper do
    def with_id
      attributes(:id)
    end
  end
end
