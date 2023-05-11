<?php

use Swoole\Http\Request;
use Swoole\Http\Response;
use Swoole\WebSocket\CloseFrame;
use Swoole\Coroutine\Http\Server;

use function Swoole\Coroutine\run;
use Swoole\Coroutine\Channel;
use Swoole\Coroutine;

run(function () {
    $server = new Server('0.0.0.0', 9502, false);

    $channel = new Channel(1);

    $server->handle('/', function ($request, $response) use ($server) {
        var_dump($request->server);
        $response->end('<h1>hello </h1>');
    });
    $server->handle('/api', function (Request $request, Response $response) use ($server, $channel) {
        $response->header('Content-Type', 'application/json; charset=utf-8');
        $response->header('access-control-allow-credentials', 'true');
        $response->header('access-control-allow-methods', 'GET,HEAD,POST,OPTIONS');
        $response->header('access-control-allow-headers', 'content-type,Authorization');
        $origin = empty($request->header['origin']) ? '*' : $request->header['origin'];
        $response->header('access-control-allow-origin', $origin);
        $request_method = empty($request->header['request_method']) ? '' : $request->header['request_method'];
        if ($request_method == "OPTIONS") {
            $response->header->status(200);
            $response->end();
            return null;
        }

        list($controller, $action) = explode('/', trim($request->server['request_uri'], '/'));

        $controller = empty($controller) ? 'api' : $controller;
        $controller = preg_match('/\w+/', $controller) ? $controller : 'api';
        $controller = ucfirst($controller) . 'Controller';

        $action = empty($action) ? 'index' : $action;
        $action = preg_match('/\w+/', $action) ? $action : 'index';
        $action = lcfirst($action) . 'Action';

        var_dump($action);
        $parameter= $request->getContent();
        $parameter=json_decode($parameter, true);
        var_dump($parameter);
        $branch_name = $parameter['data']['branch_name'];
        $word_dir=realpath(__DIR__ . '/../../');
        $runtime=realpath($word_dir . '/bin/runtime');
        if ($action==='changeBranchAction') {
            $cmd=<<<EOF
         cd $word_dir
         git checkout $branch_name

EOF;
            ob_start();
            passthru($cmd,$result_code);
            $result = ob_get_contents();
            ob_end_clean();
            echo $result;
        }

        $cmd=<<<EOF
        cd $word_dir
        export PATH=${runtime}:\$PATH
        php prepare.php --with-build-type=release +apcu +ds

EOF;



        try {
            $response->end(json_encode(
                [
                'code'=>200,
                "msg"=>'success',
                "data"=>[
                    'result'=>$result
                ]],
                JSON_UNESCAPED_UNICODE
            ));
        } catch (\RuntimeException $e) {
            echo $e->getMessage();
            $response->end(json_encode(["code" => 500, 'msg' => 'system error' . $e->getMessage()]));
        }
    });

    $server->handle('/websocket', function (Request $request, Response $ws) use ($server) {
        $ws->upgrade();
        while (true) {
            $frame = $ws->recv();
            if ($frame === '') {
                $ws->close();
                break;
            } else {
                if ($frame === false) {
                    echo 'errorCode: ' . swoole_last_error() . "\n";
                    $ws->close();
                    break;
                } else {
                    if ($frame->data == 'close' || get_class($frame) === CloseFrame::class) {
                        $ws->close();
                        break;
                    }
                    $ws->push("Hello {$frame->data}!");
                    $ws->push("How are you, {$frame->data}?");
                }
            }
        }
    });

    $server->handle('/stop', function ($request, $response) use ($server) {
        $response->end("<h1>Stop</h1>");
        $server->fp->fclose();
        $server->shutdown();
    });

    $server->start();
});
