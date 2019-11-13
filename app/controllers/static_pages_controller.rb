class StaticPagesController < ApplicationController
  skip_load_and_authorize_resource

  def home; end
end
