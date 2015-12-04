var completedTasks = 0;
var taskQueue = new Array();
var totalTasks;

var outputText = "test results\n    all measurements are in milliseconds unless otherwise specified";

var running = false;

// append text to the output div
function output(arg,header) {
    outputText += "\n";
    if (header)
        outputText += "\ntask: ";
    else
        outputText += "    ";
    outputText += arg;
}

// print summary statistics and extra data of an array of numbers
function summary(array) {
    var n = array.length;
    array.sort(function(a,b) {
        return a - b;
    });

    var sum = 0;
    for (i = 0; i < n; i++) {
        sum += array[i];
    }

    var median;
    var half = Math.floor(n/2);
    if (n % 2 == 1) {
        median = array[half];
    } else {
        median = (array[half]+array[half-1])/2;
    }

    output("items: " + array.join(", "));
    output("n: " + n);
    output("sum: " + sum);
    output("mean: " + sum/n);
    output("median: " + median);
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

    document.getElementById("status").innerHTML = ("Running task: " + currentTask[0] + "<br>The page may appear to be frozen; please do not refresh or leave.<br><br>");
    completedTasks++;
    document.getElementById("progressBarFg").style.width = completedTasks/totalTasks*100 + "%";

    setTimeout(function() {
        currentTask[1]();
        if (taskQueue.length > 0) {
            runNextTask();
        }
    }, delay);
}

function main() {

    // first, queue all tasks

    // dump browser info
    queue("Dumping browser information", function() {
        output("browser information dump",true);
        output("user-agent: " + navigator.userAgent);
    });
    
    // increment
    var incrementIterations = 10000000;
    var incrementReps = 10;
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
    var factorialArg = 2048;
    var factorialReps = 10;
    var factorialAvg;
    var factorialTrials = new Array();
    for (run = 0; run < factorialReps; run++) {
        queue(factorialArg + "!, trial #" + (run + 1), function() {
            var start = Date.now();
            math.config({precision:6000});
            console.log(factorialArg + "!: " + math.factorial(math.bignumber(factorialArg)));
            var dt = (Date.now() - start);
            factorialTrials.push(dt);
        });
    }
    queue("Collecting factorial results", function() {
        output(factorialArg + "!",true);
        summary(factorialTrials);
    });

    // TODO: more benchmarks here

    // finalize results
    queue("Collecting results", function() {
        document.getElementById("output").innerHTML = outputText;
        document.getElementById("outputBox").removeAttribute("style");

        document.getElementById("progressBarBg").style.height = "0px";
        document.getElementById("status").innerHTML = "Tests finished. Please enter any additional information that you'd like to provide into the box below (browser, phone model, how your day is going, etc.) and click the button when finished. The more information, the better! <br><br>The results of your test can be found below the button.";
        document.title = "The Tanner Times Phone Study (waiting for input)";
        
        document.getElementById("button").innerHTML = "Click here to submit your results (does nothing yet)";

        // modify and display the form
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
        document.title = "The Tanner Times Phone Study (working)";
        setTimeout(main,100);
    }
}

