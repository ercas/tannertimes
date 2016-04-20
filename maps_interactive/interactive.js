// config
var renderDiv = document.getElementById("render");

// setup
document.getElementById("needs-js").setAttribute("style","display: none;");
renderDiv.removeAttribute("style");

var scene = new THREE.Scene();
scene.fog = new THREE.Fog(0xdefbff, 1.75, 2.5);
var camera = new THREE.PerspectiveCamera(90,
        window.innerWidth/window.innerHeight);
var renderer = new THREE.WebGLRenderer({alpha: true});
renderer.setClearColor(0xdefbff);
renderer.setSize(window.innerWidth, window.innerHeight);
renderDiv.appendChild(renderer.domElement);
window.onresize = function() {
    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.aspect = (window.innerWidth/window.innerHeight);
    camera.updateProjectionMatrix();
};


// function to create a plane from an image
function createPlane(image, width, height, alphamap) {
    return new THREE.Mesh(
        new THREE.PlaneGeometry(width, height),
        new THREE.MeshBasicMaterial({
            side: THREE.DoubleSide,
            map: new THREE.TextureLoader().load(image),
            alphaMap: new THREE.TextureLoader().load(alphamap),
            transparent: true
        })
    );
};

// create planes
var firstFloor = createPlane("1.jpg", 1.059, 1.477, "1-alpha.jpg");
scene.add(firstFloor);
var secondFloor = createPlane("2.jpg", 1.059, 1.477, "2-alpha.jpg");
scene.add(secondFloor);
var thirdFloor = createPlane("3.jpg", 1.059, 1.477, "3-alpha.jpg");
scene.add(thirdFloor);
var ground = createPlane("map.png", 7, 7, "map-alpha.jpg");
scene.add(ground);

// positioning
firstFloor.rotation.x = 90;
secondFloor.rotation.x = 90;
secondFloor.position.y = 0.175
thirdFloor.rotation.x = 90;
thirdFloor.position.y = 0.35
ground.rotation.x = 90;
ground.rotation.z = -0.56;
ground.position.y = -0.01;

// start rendering
var rotatePerFrame = 0.004
function render() {
    requestAnimationFrame(render);

    firstFloor.rotation.z += rotatePerFrame
    secondFloor.rotation.z += rotatePerFrame
    thirdFloor.rotation.z += rotatePerFrame
    ground.rotation.z += rotatePerFrame

    renderer.render(scene, camera);
};
render();

// controls ///////////////////////////////////////////////////////

// camera controls
var cameraPositions = [
    {
        x: 0,
        y: 0,
        z: 0.8,
        rotation: -0.1
    },
    {
        x: 0,
        y: 0.4,
        z: 0.7,
        rotation: -0.6
    },
    {
        x: 0,
        y: 0.8,
        z: 0.4,
        rotation: -1
    }
];
var currentPosition = -1;
function changeCamera() {
    currentPosition = (currentPosition + 1) % cameraPositions.length;
    var position = cameraPositions[currentPosition];
    camera.position.x = position.x;
    camera.position.y = position.y;
    camera.position.z = position.z;
    camera.rotation.x = position.rotation;
}
changeCamera();

// toggle floor visibility
var firstButton = document.getElementById("toggle-first")
function toggleFirst() {
    firstFloor.visible = ! firstFloor.visible;
    if (firstFloor.visible)
        firstButton.setAttribute("class","button active");
    else
        firstButton.setAttribute("class","button inactive");
}
var secondButton = document.getElementById("toggle-second")
function toggleSecond() {
    secondFloor.visible = ! secondFloor.visible;
    if (secondFloor.visible)
        secondButton.setAttribute("class","button active");
    else
        secondButton.setAttribute("class","button inactive");
}
var thirdButton = document.getElementById("toggle-third")
function toggleThird() {
    thirdFloor.visible = ! thirdFloor.visible;
    if (thirdFloor.visible)
        thirdButton.setAttribute("class","button active");
    else
        thirdButton.setAttribute("class","button inactive");
}

// toggle rotation
var defaultRotation = rotatePerFrame;
var rotateButton = document.getElementById("toggle-rotate");
function toggleRotation() {
    if (rotatePerFrame == defaultRotation) {
        rotatePerFrame = 0;
        rotateButton.setAttribute("class","button inactive");
    } else {
        rotatePerFrame = defaultRotation;
        rotateButton.setAttribute("class","button active");
    }
}
