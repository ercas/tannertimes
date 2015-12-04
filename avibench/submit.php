<html>
    <head>
        <title>The Tanner Times Phone Study (completed)</title>
        <meta charset=UTF-8>
        <link rel=icon type=image/png href=img/favicon.png sizes=32x32>
        <link rel=stylesheet type=text/css href=style.css>
    </head>
    <body>
        <a target=_blank href=http://thetannertimes.net><img id=header src=img/header.png ></a>

        <br><?php
            function err($msg) {
                die("<div class=error>ERROR: ".$msg."</div><br><a href=/>Click here</a> to go back to the main page.");
            }

            if (empty($_POST["results"]))
                err("No results received");

            /* unique hash of ip address and user agent to prevent multiple submissions from same browser */
            $id = hash("md4",$_SERVER["REMOTE_ADDR"].$_SERVER["HTTP_USER_AGENT"]);
            $data = filter_var($_POST["results"]."\n\ncomments:\n    ".$_POST["comments"]."\n");

            if (file_exists("responses/".$id))
                echo "<div class=error>Your previous response has been overwritten.</div><br>";
            file_put_contents("responses/".$id, $data) or err("Could not write response to file");
            
            echo "Thank you for participating in the study!<br><br>The following information was received:";
            echo "<pre><code>".$data."</code></pre>";
            echo "Your identifier hash is ".$id.". Any subsequent tests performed from the same browser on the same device from the same IP address will overwrite previous tests.<br><br>If you want to <a href=/>try again</a> with another browser, feel free to do so; that browser will be given a new hash.";
        ?>

        <div id=footer>
            <br>
            <br><?php echo "Server info: ".$_SERVER["SERVER_SOFTWARE"]." running on ".php_uname("s")." ".php_uname("r")." ".php_uname("m")." port ".$_SERVER["SERVER_PORT"]?> | The source code for this project is available on <a target=_blank href=http://github.com/ercas/tannertimes/tree/master/avibench>GitHub</a>.
        </div>
    </body>
</html>
