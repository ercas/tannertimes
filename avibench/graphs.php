<html>
    <head>
        <title>The Tanner Times Phone Study (completed)</title>
        <meta charset=UTF-8>
        <link rel=icon type=image/png href=img/favicon.png sizes=32x32>
        <link rel=stylesheet type=text/css href=style.css>
    </head>
    <body>
        <a target=_blank href=http://thetannertimes.net><img id=header src=img/header.png ></a>
        
        <br>These graphs may be a day or two old.
        <?php
            foreach(glob("graphs/*") as $graph) {
                echo "<br><br><img width=100% src='$graph'>";
            }
        ?>
        <br>

        <div id=footer>
            <br>
            <br><?php echo "Server info: ".$_SERVER["SERVER_SOFTWARE"]." running on ".php_uname("s")." ".php_uname("r")." ".php_uname("m")." port ".$_SERVER["SERVER_PORT"]." | "?>The source code for this project is available on <a target=_blank href=http://github.com/ercas/tannertimes/tree/master/avibench>GitHub</a>.
        </div>
    </body>
</html>
