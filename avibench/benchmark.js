var taskQueue = new Array();
var outputDiv = document.createElement("div");
var outputHtml = "";
var running = false;

// append text to the output div
function output(arg) {
    outputHtml += "<br>" + arg;
}

// add a table consisting of a function and its sleep time to the task queue
function queue(name, fn, sleep) {
    taskQueue.push([name, fn, sleep]);
}

// recursive function that iterates over the task queue
function runNextTask() {
    var currentTask = taskQueue.shift();
    var delay = currentTask[2];
    if (! delay) {
        delay = 50;
    }
    document.getElementById("status").innerHTML = ("running task: " + currentTask[0]);
    setTimeout(function() {
        currentTask[1]();
        if (taskQueue.length > 0) {
            runNextTask();
        }
    }, delay);
}

// print summary statistics and extra data of an array of numbers
function summary(array) {
    var sum = 0;
    var n = array.length;
    for (i = 0; i < n; i++) {
        sum += array[i];
    }
    output("array = "+JSON.stringify(array));
    output("n = "+n);
    output("mean: "+sum/n);
}

function main() {
    
    // blank loop
    var iterations = 100000000;
    var rep = 20;
    var blankLoopAvg;
    var blankLoopTrials = new Array();
    output(iterations + " blank loops (ms)");
    for (run = 0; run < rep; run++) {
        queue(iterations + " blank loops, trial #" + (run + 1), function() {
            var start = Date.now();
            for (i = 0; i < iterations; i++);
            var dt = (Date.now() - start);
            blankLoopTrials.push(dt);
        }, 100);
    }
    queue("collecting blankLoop results", function() {
        summary(blankLoopTrials);
    });

    // display results
    queue("collecting results", function() {
        output("<br>finished");

        outputDiv.innerHTML = outputHtml;
        document.body.appendChild(outputDiv);
        document.getElementById("status").innerHTML = "tests finished; the results are displayed below. <br>please click the button when you are done reviewing them.";
        
        document.getElementById("button").innerHTML = "click here to submit your results (does nothing yet)";
        document.getElementById("button").onclick = function() {
            window.location = "/submit.php";
        }
    });
    
    // start
    runNextTask();
}

document.getElementById("button").onclick = function() {
    if (running == false) {
        running = true;
        document.getElementById("button").innerHTML = "working...";
        document.getElementById("status").innerHTML = "please wait... (running tests, please do not leave or refresh the page. your browser may appear to be frozen for a few minutes.)<br>";
        setTimeout(main,500);
    }
}

