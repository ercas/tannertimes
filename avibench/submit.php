<html>
    <head>
        <title>php sandbox</title>
        <meta charset=UTF-8>
    </head>
    <body>
        <?php
            $data = $_SERVER["REQUEST_TIME"] . "," . $_SERVER["REMOTE_ADDR"] . "," . $_SERVER["HTTP_USER_AGENT"] . "\n";
            file_put_contents("responses.txt", $data, FILE_APPEND | LOCK_EX) or die("error");

            echo "your user agent: " . $_SERVER["HTTP_USER_AGENT"];
            echo "<br>your ip address: " . $_SERVER["REMOTE_ADDR"];
            echo "<br><br>submitted at " . gmdate("Y-m-d\TH:i:s\Z",$_SERVER["REQUEST_TIME"]);
            echo "<br><br>server info: " . $_SERVER["SERVER_SOFTWARE"] . " port " . $_SERVER["SERVER_PORT"]; 
        ?>
    </body>
</html>
