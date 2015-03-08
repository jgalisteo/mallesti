class MainController < ApplicationController
  # Sólo renderizamos el layout. AngularJS se encargará del resto
  def main
    render text: '', layout: 'application'
  end
end
