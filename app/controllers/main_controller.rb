class MainController < ApplicationController
  skip_before_action :authenticate_user!
  # Sólo renderizamos el layout. AngularJS se encargará del resto
  def main
    render text: '', layout: 'application'
  end
end
