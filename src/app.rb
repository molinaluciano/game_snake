# require_relative metodo que permite incluir archivos de ruby
require_relative "view/ruby2d"
# referencial al modulo model
require_relative "model/state"
require_relative "actions/actions"

class App
  def initialize
    # nos devevuelte el estado inicial de la aplicacion
    # creamos variable de instancia, los metodos tienen acceso a ella
    @state = Model::initial_state
  end

  def start
    @view = View::Ruby2dView.new(self)
    # thread para mantener actualizado, implementamos el timer
    timer_thread = Thread.new { init_timer }
    @view.start(@state)
    timer_thread.join
  end
# creamos timer para que snake se mueva cada segundo
  def init_timer
    # loop infinito
    loop do
      if @state.game_finished
        puts "Juego finalizado"
        puts "Puntaje: #{@state.snake.positions.length}"
        break
      end
      @state = Actions::move_snake(@state)
      @view.render(@state)
      # duerma 0.5 segundo
      sleep 0.5
    end
  end
# creamos metodo para enviar acciones
  def send_action(action, params)
    # :change_direction, Model::Direction::UP
    new_state = Actions.send(action, @state, params)
    # se compara el hash, es un identificador unico
    if new_state.hash != @state
      # desencadenamos nuevo render
      @state = new_state
      @view.render(@state)
    end
  end
end

# instancio
app = App.new
# llamo metodo start
app.start
