# frozen_string_literal: true

module V1
  class Base < Grape::API
    version 'v1', using: :path

    # use V1::Cors::Middleware
    use V1::Middleware::Auth
    use V1::Middleware::Check
    mount V1::UserCares
    mount V1::Suggests
    mount V1::UserComments
    mount V1::UserLikes
    mount V1::Users
    mount V1::Login
    mount V1::Blogs
    mount V1::Awards
    mount V1::Messages
    mount V1::VerifyCodes
  end
end

