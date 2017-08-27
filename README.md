WebScript
===========

A comparison between python and elixir for developing a simple web-app wrapper for a script.
Here are the requirements:

- Call a script from the server. The script should take 10-30 seconds to run, so just let the user wait for it to complete.
- Multiple users should be able to call the script concurrently.
- Make sure to protect the server from overloading by limiting the number of concurrent active scripts.

The frontend is the same for both projects.
Getting and validating user input is not demonstrated in this repo, as it should be straightforward in both languages.
The idea was to compare the concurrency stuff.

## Python

The implementation is based on [aiohttp](https://aiohttp.readthedocs.io/en/latest/index.html), with no much extras.
There is a global counter to track the number of active scripts.
A new POST request checks the counter.
If it reaches the maximal allowed active scripts a 503 error is returned, indicating that the service is unavailable.
Otherwise, first, the counter is incremented.
Then, `asyncio.create_subprocess_exec` is used to call the script.
Lastly, the result is returned to the user, and the counter is decremented under `finally`.

## Elixir

The general idea is very similar.
The server is based on [cowboy](https://github.com/ninenines/cowboy) and [plug](https://github.com/elixir-plug/plug).
Instead of a global counter I'm using [poolboy](https://github.com/devinus/poolboy) to create a pool of workers for calling the script.
On each POST request, if the pool if full, the 503 error is returned.
Otherwise, the script is called and the result is returned to the user.

## Conclusion

I don't have one yet :-).
