// header of the output log
var outputText = "test results\n    all measurements are in milliseconds unless otherwise specified";

// base string used for string manipulations, thanks to http://www.lipsum.com/
var baseString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent egestas laoreet porttitor. Quisque eu dignissim turpis, eu feugiat sapien. Duis at vestibulum quam. Sed eget ipsum leo. Duis eu ligula sem. Suspendisse vitae faucibus enim. Aliquam erat volutpat. Vestibulum condimentum ut erat ac rhoncus. Nulla porttitor scelerisque tortor, a pretium sapien pretium quis.";

var completedTasks = 0;
var taskQueue = new Array();
var totalTasks;

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

// change the status easily
function changeStatus(arg) {
    document.getElementById("status").innerHTML = arg + "<br><br>"
}

// print quick summary statistics and extra data of an array of numbers
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

    changeStatus("Running task: " + currentTask[0] + "<br>The page may appear to be frozen; please do not refresh or leave.");
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
    changeStatus("Loading increment...");
    var incrementIterations = 10000000;
    var incrementTrials = 10;
    var incrementData = new Array();
    var incrementTitle = incrementIterations + " increments";
    for (run = 0; run < incrementTrials; run++) {
        queue(incrementTitle + ", trial #" + (run + 1), function() {
            var start = Date.now();
            var x = 0;
            for (i = 0; i < incrementIterations; i++) {
                x++;
            }
            var dt = (Date.now() - start);
            console.log("x = " + x);
            incrementData.push(dt);
        });
    }
    queue("Collecting increment results", function() {
        output(incrementTitle,true);
        summary(incrementData);
    });

    // factorial (math.js 2.4.2)
    changeStatus("Loading factorial...");
    var factorialArg = 2048;
    var factorialTrials = 10;
    var factorialData = new Array();
    var factorialTitle = factorialArg + "!";
    for (run = 0; run < factorialTrials; run++) {
        queue(factorialTitle + ", trial #" + (run + 1), function() {
            var start = Date.now();
            math.config({precision:6000});
            console.log(factorialArg + "!: " + math.factorial(math.bignumber(factorialArg)));
            var dt = (Date.now() - start);
            factorialData.push(dt);
        });
    }
    queue("Collecting factorial results", function() {
        output(factorialTitle,true);
        summary(factorialData);
    });

    // regex
    changeStatus("Loading regex...");
    var regexTrials = 10;
    var regexReps = 16;
    var regexChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~!@#$%^&_|:<>"; // each one is iterated over
    var regexData = new Array();
    var regexTitle = regexChars.length + " regex matches, " + baseString.length + " characters, " + regexReps + " reps";
    for (run = 0; run < regexTrials; run++) {
        queue(regexTitle + ", trial #" + (run + 1), function() {
            var start = Date.now();
            for (r = 0; r < regexReps; r++) {
                var str = baseString;
                for (i = 0; i < regexChars.length; i++) {
                    var regex = new RegExp(regexChars.charAt(i),"g");
                    str = str.replace(regex,"0");
                }
                console.log(str);
            }
            var dt = (Date.now() - start);
            regexData.push(dt);
        });
    }
    queue("Collecting regex results", function() {
        output(regexTitle,true);
        summary(regexData);
    });
    

    // crypto (sjcl 1.0.0)
    changeStatus("Loading crypto...");
    var cryptoPass = "ayy lmao";
    var cryptoTrials = 10;
    var cryptoReps = 32;
    var cryptoData = new Array();
    var cryptoTitle = "SJCL encrypt, decrypt " + baseString.length + " characters, " + cryptoReps + " reps";
    for (run = 0; run < cryptoTrials; run++) {
        queue(cryptoTitle + ", trial #" + (run + 1), function() {
            var str = baseString;
            var start = Date.now();
            for (i = 0; i < cryptoReps; i++) {
                console.log(sjcl.decrypt(cryptoPass,sjcl.encrypt(cryptoPass,str)));
            }
            var dt = (Date.now() - start);
            cryptoData.push(dt);
        });
    }
    queue("Collecting crypto results", function() {
        output(cryptoTitle,true);
        summary(cryptoData);
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
        changeStatus("Starting...");
        document.title = "The Tanner Times Phone Study (working)";
        setTimeout(main,100);
    }
}

