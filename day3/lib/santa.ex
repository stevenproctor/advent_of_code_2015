defmodule Santa do
  use GenServer

  ## Client API

  @doc """
  Starts Santa on his trip.
  """
  def start_link(auditor_elf, opts \\ []) do
    GenServer.start_link(__MODULE__, auditor_elf, opts)
  end

  @doc """
  Lets Santa know to move to the next house.
  """
  def next_house(santa, direction: direction) do
    GenServer.call(santa, {:next_house, {direction, 1}})
  end


  ## Server Callbacks

  def init(auditor_elf) do
    {:ok, %{address: {0,0}, auditor_elf: auditor_elf}}
  end

  def handle_call({:next_house, {direction, magnitude}}, _from, state) do
    new_address = do_move_to_next_house(direction, magnitude, state)
    new_state = Map.put(state, :address, new_address)
    {:reply, :ok, new_state}
  end

  ## Private functions

  defp do_move_to_next_house(direction, magnitude, state) do
    address = move_to_next_house(direction, magnitude, state.address)
    House.deliver_present(address)
    AuditorElf.notify_present_delivered(state.auditor_elf, address)

    address
  end

  defp move_to_next_house(:north, magnitude, _address={x, y}), do: {x, y + magnitude}
  defp move_to_next_house(:east, magnitude, _address={x, y}), do: {x + magnitude, y}
  defp move_to_next_house(:south, magnitude, _address={x, y}), do: {x, y - magnitude}
  defp move_to_next_house(:west, magnitude, _address={x, y}), do: {x - magnitude, y}
end
