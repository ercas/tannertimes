// TODO: compile results into json and pass to submit.php

var taskQueue = new Array();
var outputHtml = "";
var running = false;
var totalTasks;
var completedTasks = 0;

// append text to the output div
function output(arg) {
    outputHtml += "<br>" + arg;
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

    // first, queue all tasks
    
    // blank loop
    var iterations = 100000000;
    var rep = 20;
    var incrementAvg;
    var incrementTrials = new Array();
    for (run = 0; run < rep; run++) {
        queue(iterations + " increments, trial #" + (run + 1), function() {
            var start = Date.now();
            var x = 0;
            for (i = 0; i < iterations; i++) {
                x++;
            }
            var dt = (Date.now() - start);
            incrementTrials.push(dt);
        }, 100);
    }
    queue("Collecting increment results", function() {
        output(iterations + " increments (ms)");
        summary(incrementTrials);
    });

    // display results
    queue("Collecting results", function() {
        document.getElementById("output").innerHTML = outputHtml;

        document.getElementById("progressBarBg").style.height = "0px";
        document.getElementById("status").innerHTML = "Tests finished. The results are displayed below. <br>Please click the button when you are done reviewing them.";
        
        document.getElementById("button").innerHTML = "Click here to submit your results (does nothing yet)";
        document.getElementById("button").removeAttribute("style");
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
        document.getElementById("button").style = "visibility: hidden;";
        document.getElementById("progressBarBg").style.height = "50px";
        document.getElementById("status").innerHTML = "Setting up...<br><br>";
        setTimeout(main,500);
    }
}

