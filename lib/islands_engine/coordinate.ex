defmodule IslandsEngine.Coordinate do
  alias __MODULE__
  @enforce_keys [:row, :col]
  @board_range 1..10

  defstruct [:row, :col]

  def new(row, col) when row in(@board_range) and col in(@board_range) do
    {:ok, %Coordinate{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_coordinate}

  def start_link do
    #Agent.start_link(fn -> %Coordinate{} end)
  end

  def guessed?(coordinate) do
    Agent.get(coordinate, fn state -> state.guessed? end)
  end

  def island(coordinate) do
    Agent.get(coordinate, fn state -> state.in_island end)
  end

  def in_island?(coordinate) do
    case island(coordinate) do
      :none -> false
      _any  -> true
    end
  end

  def hit?(coordinate) do
    in_island?(coordinate) && guessed?(coordinate)
  end

  def guess(coordinate) do
    Agent.update(coordinate, fn state -> Map.put(state, :guessed?,  true) end)
  end

  def set_in_island(coordinate, value) when is_atom value do
    Agent.update(coordinate, fn state -> Map.put(state, :in_island, value) end)
  end

  def to_string(coordinate) do
    "(in_island: #{island(coordinate)}, guessed: #{guessed?(coordinate)})"
  end

  def set_all_in_island(coordinates, value) when is_list coordinates and is_atom value do
    Enum.each(coordinates, fn coord -> set_in_island(coord, value) end)
  end
end
