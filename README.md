web-script
==========

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

## Conclusions

I'm a complete asyncio newby, and wasn't sure how complex the implementetion will be.
It always feel a bit restrictive for me.
For example, without the already implemented `asyncio.subprocess` module, following the requirements would be much more difficult.
I'm also more confident with elixir, as I use it almost exclusively for everything web-based.
With elixir you can use whatever library you want and make use of all of the concurrency feature of the language without any special adapters.
Surprisingly, the python solution ended up much simpler than I thought, and it is much shorter than the elixir solution (mainly due to the way a project is structured in elixir).
So, I ended with two easy to use options, hence the decision between them will be even harder.
Or maybe it's time to properly learn asyncio.
