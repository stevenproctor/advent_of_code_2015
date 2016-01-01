defmodule AdventOfCodeDay3 do
  use Application

  def start(_type, _args) do
    Christmas.Supervisor.start_link
  end

  def run(directions) do
    DirectionsElf.give_directions(DirectionsElf, directions)
    addresses_visited = AuditorElf.get_addresses_visited(AuditorElf)
    IO.puts "Santa visited #{length(addresses_visited)} houses"
  end
end

