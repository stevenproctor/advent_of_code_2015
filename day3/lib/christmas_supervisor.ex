defmodule Christmas.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @auditor_elf_name AuditorElf
  @santa_name Santa
  @directions_elf_name DirectionsElf

  def init(:ok) do
    children = [
      worker(AuditorElf, [[name: @auditor_elf_name]]),
      worker(Santa, [@auditor_elf_name, [name: @santa_name]]),
      worker(DirectionsElf, [@santa_name, [name: @directions_elf_name]])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
