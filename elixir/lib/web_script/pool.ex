defmodule WebScript.Pool do

  @doc """
  Call the worker from the pool to run a script. Make sure that the pool
  is not full before doing so.
  """
  def call_script(pool, cmd, args, timeout \\ 5_000) do
    # poolboy's timeout doesn't affect the call but only checkins the worker
    # back to the pool. Use a single timeout for both.
    {state, _, _, _} = :poolboy.status(pool)
    if state == :full do
      {:error, :full}
    else
      resp = :poolboy.transaction(
        pool,
        fn pid -> WebScript.Worker.call_script(pid, cmd, args, timeout) end,
        timeout
      )
      {:ok, resp}
    end
  end

end
