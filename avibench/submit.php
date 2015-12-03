<html>
    <head>
        <title>php sandbox</title>
        <meta charset=UTF-8>
        <link rel=stylesheet type=text/css href=style.css>
    </head>
    <body>
        <a target=_blank href=http://thetannertimes.net><img src=header.png style="display: block; margin: 0 auto;"></a>
        <br>Thank you for participating!
        <br>
        <br>
        Received: 
        <pre><code><?php echo $_POST["results"]; ?></code></pre>
        <br>
        <?php
            echo "your user agent: " . $_SERVER["HTTP_USER_AGENT"];
            echo "<br>your ip address: " . $_SERVER["REMOTE_ADDR"];
            echo "<br><br>submitted at " . gmdate("Y-m-d\TH:i:s\Z",$_SERVER["REQUEST_TIME"]);
            echo "<br><br>server info: " . $_SERVER["SERVER_SOFTWARE"] . " port " . $_SERVER["SERVER_PORT"]; 
        ?>

        <div id=footer>
            <br>
            <br>The source code for this project is available on <a target=_blank href=http://github.com/ercas/tannertimes/tree/master/avibench>GitHub</a>.
        </div>
    </body>
</html>
