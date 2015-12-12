<html>
    <head>
        <title>The Tanner Times Phone Study (graphs)</title>
        <meta charset=UTF-8>
        <link rel=icon type=image/png href=img/favicon.png sizes=32x32>
        <link rel=stylesheet type=text/css href=style.css>
    </head>
    <body>
        <a target=_blank href=http://thetannertimes.net><img id=header src=img/header.png ></a>
        
        <br>
        <?php
            if (! file_exists("graphs/2048!.png"))
                die("<div class=error>ERROR: No graphs could be found.</div><br><a href=/>Click here</a> to go back to the main page.");
            
            // get "last updated" info from an arbitrary image in the graphs/ directory
            echo "Last updated on ".date("d F Y \a\\t h:i A", filemtime("graphs/2048!.png")-18000).". Extra information can be found at the bottom.<br>"; // -18000 = time zone adjustment

            // display graphs by globbing the graphs/ directory
            foreach (glob("graphs/*") as $graph) {
                echo "<br><img width=70% style='display: block; margin: 0 auto;' src='$graph'>";
            }

            // generate a table by grepping files in the data/ directory
            echo "<br><table><tr style='font-weight: bold; background-color: #2b6ca3; color: #f0f0f0;'><td>Operating System</td><td>n</td>";
            foreach (array("Android","iPhone","Windows Phone") as $phone) {
                echo "<tr><td>".$phone."</td><td>".exec("grep -i ".$phone.".*2048 data/raw.csv | wc -l")."</td></tr>";
            }
            echo "<tr style='color: #2b6ca3;'><td>Total</td><td>".exec("grep 2048 data/raw.csv | wc -l")."</td></tr><table>";
            echo "<br><div style='text-align: center; width: 80%; margin: 0 auto;'>Total responses (including non-smartphone): ".exec("ls responses/ | wc -l")."</div>";

            // link to the raw data
            echo "<br><a href=data/byTrial.csv>Click here</a> to download a formatted .csv file of the data. The delimeter is the vertical bar character (|).<br>";

            echo "<br><a href=/>Click here</a> to go back to the main page.";
        ?>
        <br>

        <div id=footer>
            <br>
            <br><?php echo "Server info: ".$_SERVER["SERVER_SOFTWARE"]." running on ".php_uname("s")." ".php_uname("r")." ".php_uname("m")." port ".$_SERVER["SERVER_PORT"]." | "?>The source code for this project is available on <a target=_blank href=http://github.com/ercas/tannertimes/tree/master/avibench>GitHub</a>.
        </div>
    </body>
</html>
