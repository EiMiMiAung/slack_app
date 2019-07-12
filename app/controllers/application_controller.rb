class ApplicationController < ActionController::Base
    protect_from_forgery unless: -> { request.format.json? }
    include SessionsHelper
    include MUsersHelper
    include WorkspacesHelper
    include InvitationsHelper
end
