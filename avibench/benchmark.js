// header of the output log
var outputText = "test results\n    all measurements are in milliseconds unless otherwise specified";

// base string used for string manipulations, thanks to http://www.lipsum.com/
var baseString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent egestas laoreet porttitor. Quisque eu dignissim turpis, eu feugiat sapien. Duis at vestibulum quam. Sed eget ipsum leo. Duis eu ligula sem. Suspendisse vitae faucibus enim. Aliquam erat volutpat. Vestibulum condimentum ut erat ac rhoncus. Nulla porttitor scelerisque tortor, a pretium sapien pretium quis.";

// used internally
var completedTasks = 0,
    taskQueue = new Array(),
    totalTasks,
    running = false;

// wrappers for repetitive functions
function element(arg) {
    return document.getElementById(arg);
}
function output(arg,header) {
    outputText += "\n";
    if (header)
        outputText += "\ntask: ";
    else
        outputText += "    ";
    outputText += arg;
}
function changeStatus(arg) {
    element("status").innerHTML = arg + "<br><br>";
}
function changeDescription(arg) {
    element("description").innerHTML = "<br>" + arg;
}

// print quick summary statistics and extra data of an array of numbers
function summary(array) {
    var n = array.length,
        half = Math.floor(n/2),
        sum = 0,
        median;

    array.sort(function(a,b) {
        return a - b;
    });

    for (i = 0; i < n; i++) {
        sum += array[i];
    }

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

    var currentTask = taskQueue.shift(),
        delay = currentTask[2];

    if (! delay) {
        delay = 50;
    }

    changeStatus("The page may appear to be frozen; please <span class=highlight>do not</span> refresh, leave the tab, or close the app<br><br>Running task: " + currentTask[0]);
    completedTasks++;
    element("progressBarFg").style.width = completedTasks/totalTasks*100 + "%";

    // recurse
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
    
    // regex
    changeStatus("Loading regex...");
    var regexTrials = 10,
        regexReps = 16,
        regexChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~!@#$%^&_|:<>", // each one is iterated over
        regexData = new Array(),
        regexTitle = regexChars.length + " regex replaces, " + baseString.length + " characters, " + regexReps + " reps",
        regexDesc = "Testing how fast the browser can perform simple text operations";
    for (run = 0; run < regexTrials; run++) {
        queue(regexTitle + ", trial #" + (run + 1), function() {
            changeDescription(regexDesc);
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
    var cryptoPass = "ayy lmao",
        cryptoTrials = 10,
        cryptoReps = 32,
        cryptoData = new Array(),
        cryptoTitle = "SJCL encrypt, decrypt " + baseString.length + " characters, " + cryptoReps + " reps",
        cryptoDesc = "Testing how fast the browser can encrypt and decrypt a string multiple times, using the Stanford JavaScript Crypto Library";
    for (run = 0; run < cryptoTrials; run++) {
        queue(cryptoTitle + ", trial #" + (run + 1), function() {
            changeDescription(cryptoDesc);
            var str = baseString,
                start = Date.now();
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

    // increment
    changeStatus("Loading increment...");
    var incrementIterations = 10000000,
        incrementTrials = 10,
        incrementData = new Array(),
        incrementTitle = incrementIterations + " increments",
        incrementDesc = "Testing how fast the browser can run a ton of loops, incrementing a single variable by one every time";
    for (run = 0; run < incrementTrials; run++) {
        queue(incrementTitle + ", trial #" + (run + 1), function() {
            changeDescription(incrementDesc);
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
    var factorialArg = 2048
        factorialTrials = 10
        factorialData = new Array()
        factorialTitle = factorialArg + "!",
        factorialDesc = "Testing how fast the browser can solve the factorial of 2048";
    for (run = 0; run < factorialTrials; run++) {
        queue(factorialTitle + ", trial #" + (run + 1), function() {
            changeDescription(factorialDesc);
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

    // TODO: more benchmarks here

    // finalize results
    queue("Collecting results", function() {
        element("output").innerHTML = outputText;
        element("outputBox").removeAttribute("style");
        element("description").setAttribute("style","display: none;");

        element("progressBarBg").style.height = "0px";
        element("status").innerHTML = "Tests finished. Please <span class=highlight>enter any additional information</span> that you'd like to provide into the box below (browser, phone model, how your day is going, etc.) and <span class=highlight>click the button</span> when finished. The more information, the better! <br><br>The results of your test can be found below the button.";
        document.title = "The Tanner Times Phone Study (waiting for input)";
        
        element("button").innerHTML = "Click here to submit your results (does nothing yet)";

        // modify and display the form
        element("results").innerHTML = outputText;
        element("form").removeAttribute("style");
    });
    
    // run all queued tasks
    runNextTask();
}

element("button").onclick = function() {
    if (running == false) {
        running = true;
        element("button").innerHTML = "Working...";
        element("button").setAttribute("style","display: none;");
        element("progressBarBg").style.height = "50px";
        changeStatus("Starting...");
        document.title = "The Tanner Times Phone Study (working)";
        element("description").removeAttribute("style");
        setTimeout(main,100);
    }
}

