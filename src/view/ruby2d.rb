require "ruby2d"
require_relative "../model/state"

module View
  class Ruby2dView
    # al inicializado le pasamos la app
    def initialize(app)
      # tamaño de cuadro de juego
      @pixel_size = 50
      @app = app
    end
    # metodo de inicio
    def start(state)
      # uso de dsl 
      extend Ruby2D::DSL
      # configurar ventana de aplicacion
      set(
          title: "Snake", 
          # pixel * nro de columnas
          width: @pixel_size * state.grid.cols,
          # pixel x numero de filas
          height: @pixel_size * state.grid.rows)
        # event cuando se presiona tecla
      on :key_down do |event|
        # A key was pressed
        handle_key_event(event)
      end
      show
    end
    # llamado cada vez que el state cambie
    def render(state)
      extend Ruby2D::DSL
      close if state.game_finished
      # reciben el estado
      render_food(state)
      render_snake(state)
    end

    # metodos privados
    private

    def render_food(state)
      # limpiamos el render
      @food.remove if @food
      extend Ruby2D::DSL
      food = state.food
      # nuevo cuadrado
      @food = Square.new(
        x: food.col * @pixel_size,
        y: food.row * @pixel_size,
        size: @pixel_size,
        color: 'yellow'
      )
    end

    def render_snake(state)
      # limpiamos el render (&:) hace refeencia a un elemento que tiene el metodo que lo acompaña
      @snake_positions.each(&:remove) if @snake_positions
      extend Ruby2D::DSL
      snake = state.snake
      # itreamos las posciones de la serpiente
      @snake_positions = snake.positions.map do |pos|
        Square.new(
          x: pos.col * @pixel_size,
          y: pos.row * @pixel_size,
          size: @pixel_size,
          color: 'green'
        )
      end
    end
# metodo donde se ejecuta el cambio al Direction del modelo
    def handle_key_event(event)
      case event.key
      when "up"
        # cambiar direccion hacia arriba
        @app.send_action(:change_direction, Model::Direction::UP)
      when "down"
        # cambiar direccion hacia abajo
        @app.send_action(:change_direction, Model::Direction::DOWN)
      when "left"
        # cambiar direccion hacia izquierda
        @app.send_action(:change_direction, Model::Direction::LEFT)
      when "right"
        # cambiar direccion hacia derecha
        @app.send_action(:change_direction, Model::Direction::RIGHT)
      end
    end
  end

end
