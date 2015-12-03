// TODO: compile results into json and pass to submit.php

var taskQueue = new Array();
var outputText = "test results";
var running = false;
var totalTasks;
var completedTasks = 0;

// append text to the output div
function output(arg,header) {
    outputText += "<br>";
    if (header)
        outputText += "<br>    task: ";
    outputText += arg;
}

// add a table consisting of a function and its sleep time to the task queue
function queue(name, fn, sleep) {
    taskQueue.push([name, fn, sleep]);
}

// recursive function that iterates over the task queue and gives feedback
function runNextTask() {
    if (! totalTasks) {
        totalTasks = taskQueue.length
    }

    var currentTask = taskQueue.shift();
    var delay = currentTask[2];
    if (! delay) {
        delay = 50;
    }

    document.getElementById("status").innerHTML = ("Running task: " + currentTask[0] + "<br><br>");
    completedTasks++;
    document.getElementById("progressBarFg").style.width = completedTasks/totalTasks*100 + "%";

    setTimeout(function() {
        currentTask[1]();
        if (taskQueue.length > 0) {
            runNextTask();
        }
    }, delay);
}

// print summary statistics and extra data of an array of numbers
function summary(array) {
    var n = array.length;
    var sum = 0;
    for (i = 0; i < n; i++) {
        sum += array[i];
    }
    output("items: " + array.join(", "));
    output("n: " + n);
    output("mean: " + sum/n);
}

function main() {

    // first, queue all tasks

    // dump browser info
    queue("Dumping browser information", function() {
        output("browser information",true);
        output("user-agent: " + navigator.userAgent);
    });
    
    // blank loop
    var incrementIterations = 100000000;
    var incrementReps = 16;
    var incrementAvg;
    var incrementTrials = new Array();
    for (run = 0; run < incrementReps; run++) {
        queue(incrementIterations + " increments, trial #" + (run + 1), function() {
            var start = Date.now();
            var x = 0;
            for (i = 0; i < incrementIterations; i++) {
                x++;
            }
            var dt = (Date.now() - start);
            console.log("x = " + x);
            incrementTrials.push(dt);
        });
    }
    queue("Collecting increment results", function() {
        output(incrementIterations + " increments",true);
        summary(incrementTrials);
    });

    // factorial
    var factorialArg = 4096;
    var factorialReps = 10;
    var factorialAvg;
    var factorialTrials = new Array();
    for (run = 0; run < factorialReps; run++) {
        queue(factorialArg + "!, trial #" + (run + 1), function() {
            var start = Date.now();
            /*
            function factorial(x) {
                if (x == 0) {
                    return 1;
                } else {
                    return x * factorial(x-1);
                }
            }
            console.log(factorialArg + "!: " + factorial(factorialArg));
            */
            math.config({precision:14000});
            console.log(factorialArg + "!: " + math.factorial(math.bignumber(factorialArg)));
            var dt = (Date.now() - start);
            factorialTrials.push(dt);
        });
    }
    queue("Collecting factorial results", function() {
        output(factorialArg + "!",true);
        summary(factorialTrials);
    });

    // finalize results
    queue("Collecting results", function() {
        document.getElementById("output").innerHTML = outputText;
        document.getElementById("outputBox").removeAttribute("style");

        document.getElementById("progressBarBg").style.height = "0px";
        document.getElementById("status").innerHTML = "Tests finished. The results are displayed below. <br>Please click the button when you are done reviewing them.";
        
        document.getElementById("button").innerHTML = "Click here to submit your results (does nothing yet)";

        // reveal form
        document.getElementById("results").innerHTML = outputText;
        document.getElementById("form").removeAttribute("style");
    });
    
    // run all queued tasks
    runNextTask();
}

document.getElementById("button").onclick = function() {
    if (running == false) {
        running = true;
        document.getElementById("button").innerHTML = "Working...";
        document.getElementById("button").setAttribute("style","display: none;");
        document.getElementById("progressBarBg").style.height = "50px";
        document.getElementById("status").innerHTML = "Starting...<br><br>";
        setTimeout(main,100);
    }
}

