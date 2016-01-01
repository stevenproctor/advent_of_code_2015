defmodule AuditorElf do
  use GenServer

  ## Client API

  @doc """
  Starts the auditor elf up to track if Santa is performing well for his visits.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def notify_present_delivered(auditor_elf, address) do
    GenServer.cast(auditor_elf, {:present_delivered, address})
  end

  def get_addresses_visited(auditor_elf) do
    {:ok, addresses_visited} = GenServer.call(auditor_elf, :get_addresses_visited)
    :sets.to_list(addresses_visited)
  end

  ## Server Callbacks

  def init(_) do
    {:ok, :sets.new}
  end

  def handle_call(:get_addresses_visited, _from, addresses_visited) do
    {:reply, {:ok, addresses_visited}, addresses_visited}
  end

  def handle_cast({:present_delivered, address}, addresses_visited) do
    new_addresses_visited = add_address_to_visited_listing(address, addresses_visited)
    {:noreply, new_addresses_visited}
  end

  defp add_address_to_visited_listing(address, addresses_visited) do
    :sets.add_element(address, addresses_visited)
  end
end

