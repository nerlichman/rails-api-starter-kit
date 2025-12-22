# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }

    describe "unique email" do
      subject { FactoryBot.build(:user) }
      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:sessions) }
  end
end

# == Schema Information
#
# Table name: users
# Database name: primary
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
