defmodule House do
  def deliver_present(address) do
    ensure_house_at(address)

    Agent.update({:global, address}, fn count -> count + 1 end)
  end

  def present_count(address) do
    Agent.get({:global, address}, fn count -> count end)
  end

  defp ensure_house_at(address) do
    unless exists? address do
      start_link(address)
    end
  end

  defp exists?(address) do
    pid = GenServer.whereis({:global, address})
    !is_nil(pid)
  end

  defp start_link(address) do
    Agent.start_link(fn -> 0 end, name: {:global, address})
  end

end

