defmodule WebScript.Worker do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def call_script(pid, cmd, args, timeout \\ 5_000) do
    GenServer.call(pid, {:call_script, cmd, args}, timeout)
  end

  def handle_call({:call_script, cmd, args}, _from, state) do
    {stdout, status} = System.cmd(cmd, args)
    {:reply, {stdout, status}, state}
  end

end
