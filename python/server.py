import asyncio
import subprocess

from aiohttp import web

MAX_ACTIVE_SCRIPTS = 10


async def index(request):
    return web.FileResponse('../frontend/index.html')


async def call_script(request):
    if request.app['active_scripts'] == MAX_ACTIVE_SCRIPTS:
        raise web.HTTPServiceUnavailable()

    request.app['active_scripts'] = request.app['active_scripts'] + 1
    try:
        p = await asyncio.create_subprocess_exec(
            'sh',
            '../script.sh',
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        stdout, _ = await p.communicate()
        return web.Response(text=stdout.decode('utf8'))
    finally:
        request.app['active_scripts'] = request.app['active_scripts'] - 1


app = web.Application()
app['active_scripts'] = 0
app.router.add_static('/static/', '../frontend/static')
app.router.add_get('/', index)
app.router.add_post('/call-script', call_script)

web.run_app(app, host='127.0.0.1', port=8000)
