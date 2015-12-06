<html>
    <head>
        <title>The Tanner Times Phone Study (graphs)</title>
        <meta charset=UTF-8>
        <link rel=icon type=image/png href=img/favicon.png sizes=32x32>
        <link rel=stylesheet type=text/css href=style.css>
    </head>
    <body>
        <a target=_blank href=http://thetannertimes.net><img id=header src=img/header.png ></a>
        
        <br>These graphs may be a day or two old. Extra information can be found at the bottom.
        <br>
        <?php
            foreach(glob("graphs/*") as $graph) {
                echo "<br><img width=70% style='display: block; margin: 0 auto;' src='$graph'>";
            }
            echo "<br><table><tr style='font-weight: bold; background-color: #2b6ca3; color: #f0f0f0;'><td>Operating System</td><td>n</td>";
            foreach(array("Android","iPhone","Windows Phone") as $phone) {
                echo "<tr><td>".$phone."</td><td>".exec("grep -i ".$phone.".*2048 data/raw.csv | wc -l")."</td></tr>";
            }
            echo "<tr style='color: #2b6ca3;'><td>Total</td><td>".exec("grep 2048 data/raw.csv | wc -l")."</td></tr><table>";
            echo "<br><div style='text-align: center; width: 80%; margin: 0 auto;'>Total responses (including non-smartphone): ".exec("ls responses/ | wc -l")."</div>"
        ?>
        <br>

        <div id=footer>
            <br>
            <br><?php echo "Server info: ".$_SERVER["SERVER_SOFTWARE"]." running on ".php_uname("s")." ".php_uname("r")." ".php_uname("m")." port ".$_SERVER["SERVER_PORT"]." | "?>The source code for this project is available on <a target=_blank href=http://github.com/ercas/tannertimes/tree/master/avibench>GitHub</a>.
        </div>
    </body>
</html>
