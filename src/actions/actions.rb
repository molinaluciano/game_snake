# logica de los estados se encuentran en este archivo
# los metodos responden el estado-> state
module Actions
  # retorna nuevo estado
  def self.move_snake(state)
    next_direction = state.curr_direction
    next_position = calc_next_position(state)
    # verificar que la siguiente cassilla sea valida
    # si es comida
    if position_is_food?(state, next_position)
      # que crezca la comida
      state = grow_snake_to(state, next_position)
      # generar comida
      generate_food(state)
      # si la posicion es valida movemos la serpiente
    elsif position_is_valid?(state, next_position)
      move_snake_to(state, next_position)
      # si no es valida terminamos el juego
    else
      end_game(state)
    end
  end
  # metodo que cambia direccion
  def self.change_direction(state, direction)
    # comprobar direccion
    if next_direction_is_valid?(state, direction)
      state.curr_direction = direction
    else
      puts "Invalid direction"
    end
    state
  end
# metodos privados
  private
  # genero comidda y retorna estado
  def self.generate_food(state)
    # rand  es parte del obj, usamos stob para hacer objeto falso
    new_food = Model::Food.new(rand(state.grid.rows), rand(state.grid.cols))
    state.food = new_food
    state
  end
# posicion en comida
  def self.position_is_food?(state, next_position)
    state.food.row == next_position.row && state.food.col == next_position.col
  end
# crezca
  def self.grow_snake_to(state, next_position)
    new_positions = [next_position] + state.snake.positions
    state.snake.positions = new_positions
    state
  end
# calcular siguiente posicion
  def self.calc_next_position(state)
    curr_position = state.snake.positions.first
    # hacemos un ripo de switch
    case state.curr_direction
    when Model::Direction::UP
      # decrementar fila
      return Model::Coord.new(
          curr_position.row - 1, 
          curr_position.col)
    when Model::Direction::RIGHT
      # incrementar col
      return Model::Coord.new(
          curr_position.row, 
          curr_position.col + 1)
    when Model::Direction::DOWN
      # incrementar fila
      return Model::Coord.new(
          curr_position.row + 1,
          curr_position.col)
    when Model::Direction::LEFT
      # decrementar col
      return Model::Coord.new(
          curr_position.row, 
          curr_position.col - 1)
    end
  end
  # si posicion es valida
  def self.position_is_valid?(state, position)
    # verificar q este en la grilla
    # verificando posicion y filas y columnas a disposicion
    is_invalid = ((position.row >= state.grid.rows ||
      position.row < 0) || 
      (position.col >= state.grid.cols ||
      position.col < 0))
    return false if is_invalid
    # verificar q no este superponiendo a la serpiente
    # utilizamos el metodo include, para verficiar que no esta incluida
    return !(state.snake.positions.include? position)
  end
# movimiento, usamos estado actual
  def self.move_snake_to(state, next_position)
    new_positions = [next_position] + state.snake.positions[0...-1]
    state.snake.positions = new_positions
    state
  end
# metodo de terminar juego
  def self.end_game(state)
    # modificamos estado
    state.game_finished = true
    state
  end
# validacion de direccciones que no sea la contraria
  def self.next_direction_is_valid?(state, direction)
    case state.curr_direction
    when Model::Direction::UP
      return true if direction != Model::Direction::DOWN
    when Model::Direction::DOWN
      return true if direction != Model::Direction::UP
    when Model::Direction::RIGHT
      return true if direction != Model::Direction::LEFT
    when Model::Direction::LEFT
      return true if direction != Model::Direction::RIGHT
    end

    return false
  end
end
