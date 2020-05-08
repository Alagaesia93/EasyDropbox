# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar
  has_many_attached :files
end
