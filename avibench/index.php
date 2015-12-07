<html>
    <head>
        <meta charset=UTF-8>
        <title>The Tanner Times Phone Study</title>
        <link rel=icon type=image/png href=img/favicon.png sizes=32x32>
        <link rel=stylesheet type=text/css href=style.css>
    </head>
    <body>
        <a target=_blank href=http://thetannertimes.net><img id=header src=img/header.png></a>
        <br>
        <div class=error>WORK IN PROGRESS - PILOT RUN<br><br></div>
        <div id=status>
            Thank you for choosing to participate in the smartphone study! Click the button below to begin the automated testing.
            <br>
            <br> Please do not leave or refresh the page while the test is running.
            <br>
            <br>
        </div>
        
        <!-- please do not edit this information with inspect element or whatnot -->
        <form id=form action=submit.php method=post style="display: none;">
            <textarea id=results name=results readonly style="display: none;">test</textarea>
            <br><textarea id=commentsField name=comments></textarea>
            <br>
            <br><input id=submit type=submit value="Submit results">
        </form>

        <div id=progressBarBg>
            <div id=progressBarFg></div>
        </div>

        <div id=description style="display: none;"></div>

        <button id="button" type="button">Loading resources...</button>

        <pre id="outputBox" style="display: none;"><code id=output></code></pre>

        <div id=footer>
            <br>
            <br><?php echo "Server info: ".$_SERVER["SERVER_SOFTWARE"]." running on ".php_uname("s")." ".php_uname("r")." ".php_uname("m")." port ".$_SERVER["SERVER_PORT"]." | "?>The source code for this project is available on <a target=_blank href=http://github.com/ercas/tannertimes/tree/master/avibench>GitHub</a>.
        </div>

        <script src=https://cdnjs.cloudflare.com/ajax/libs/mathjs/2.4.2/math.min.js></script>
        <script src=https://cdnjs.cloudflare.com/ajax/libs/sjcl/1.0.0/sjcl.min.js></script>
        <script>
            if (! navigator.userAgent.match(/android|iphone|windows phone/i))
                document.getElementById("status").innerHTML = document.getElementById("status").innerHTML + "<span style='color: #ff0000;'>It has been detected that you may not currently be using a smartphone. If you are, or would like to run the test anyway, feel free to continue.</span><br><br>";
            document.getElementById("button").innerHTML = "Start";
        </script>
        <script src=benchmark.js></script>
    </body>
</html>
