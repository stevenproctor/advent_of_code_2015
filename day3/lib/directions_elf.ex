defmodule DirectionsElf do
  use GenServer

  ## Client API

  @doc """
  Starts the Directions Elf
  """
  def start_link(santa, opts \\ []) do
    GenServer.start_link(__MODULE__, santa, opts)
  end

  @doc """
  Lets Santa know to move to the next house.
  """
  def give_directions(directions_elf, directions) do
    GenServer.call(directions_elf, {:give_directions, directions})
  end


  ## Server Callbacks

  def init(santa) do
    {:ok, %{santa: santa}}
  end

  def handle_call({:give_directions, directions}, _from, state=%{santa: santa}) do
    do_give_directions(santa, :unicode.characters_to_list(directions))
    {:reply, :ok, state}
  end

  defp do_give_directions(_santa, []) do
    :ok
  end

  defp do_give_directions(santa, [direction | directions]) do
    next_direction = translate_direction(direction)
    Santa.next_house(santa, direction: next_direction)

    do_give_directions(santa, directions)
  end

  defp next_direction(directions) do
    {codepoint, remaining_directions} = String.next_codepoint(directions)
    {translate_direction(codepoint), remaining_directions}
  end

  defp translate_direction(?^), do: :north
  defp translate_direction(?>), do: :east
  defp translate_direction(?v), do: :south
  defp translate_direction(?<), do: :west
end
