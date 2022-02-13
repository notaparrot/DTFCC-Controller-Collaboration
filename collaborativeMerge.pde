import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

ControlIO control;
ControlDevice xboxController;

//////////////////////////////////////////////////////////////////////
//Photo setup//
//////////////////////////////////////////////////////////////////////

PImage photo;
boolean isCursor1triggered = false;
boolean isCursor2triggered = false;
boolean paste = false;
boolean initiateCopy = true;
int cursor1x, cursor1y, cursor2x, cursor2y, sx, sy, sw, sh;
int sourceTopX, sourceTopY, sourceWidth, sourceHeight;

//////////////////////////////////////////////////////////////////////
//Bezier setup//
//////////////////////////////////////////////////////////////////////

PFont gulax;
color[] playerPalette = {
    #2ff3e0, 
    #f8d210,
    #fa26a0,
    #f51720
};
int gridSize = 55;
int colorWheelH = 50;
int colorWheelS = 50;
int lineStrokeWeight = 4;
boolean isCapRound = true;

//drawBezier values
PVector[] activeCurvePoints = new PVector[4];

//countdown values
// int time;
// int wait = 1000;
// int counting = 10;
// boolean isCounting = true;

//storeBezier value
boolean stored;
ArrayList < Curve > listCurves = new ArrayList < Curve > ();

//////////////////////////////////////////////////////////////////////
//Mode setup//
//////////////////////////////////////////////////////////////////////

int graphicMode = 0;
boolean initiatePhotoMode = false;
boolean initiateBezierMode = false;
boolean initiatePlacementMode = false;
PGraphics pg;

//////////////////////////////////////////////////////////////////////
// setup //
//////////////////////////////////////////////////////////////////////

void setup() {
    //setup controller
    control = ControlIO.getInstance(this);

    // Find a joystick that matches the configuration file. To match with any 
    // connected device remove the call to filter.
    xboxController = control.getMatchedDevice("Default");
    if (xboxController == null) {
        println("No suitable device configured");
        System.exit(-1); // End the program NOW!
    }

    //general setup functions
    xboxController.getButton("startButton").plug(this, "onStartButtonRelease", ControlIO.ON_RELEASE);
    //Setup functions for PHOTO MODE
    xboxController.getButton("leftSTrig").plug(this, "onLeftSTrigRelease", ControlIO.ON_RELEASE);
    xboxController.getButton("rightSTrig").plug(this, "onRightSTrigRelease", ControlIO.ON_RELEASE);
    //Setup functions BEZIER MODE
    xboxController.getButton("aButton").plug(this, "onaButtonRelease", ControlIO.ON_RELEASE);
    xboxController.getButton("bButton").plug(this, "onbButtonRelease", ControlIO.ON_RELEASE);
    xboxController.getButton("xButton").plug(this, "onxButtonRelease", ControlIO.ON_RELEASE);
    xboxController.getButton("yButton").plug(this, "onyButtonRelease", ControlIO.ON_RELEASE);
    xboxController.getButton("rightThumb").plug(this, "onrightThumbRelease", ControlIO.ON_RELEASE);
    xboxController.getButton("selectButton").plug(this, "onSelectButtonRelease", ControlIO.ON_RELEASE);


    size(600, 600);
    // fullScreen();

    //PHOTO style setup
    photo = loadImage("1.JPG");
    cursor1x = width / 2;
    cursor1y = height / 2;
    cursor2x = width / 2;
    cursor2y = height / 2;
    strokeWeight(3);

    //BEZIER style setup
    colorMode(HSB, 100);
    gulax = createFont("Gulax-Regular.otf", 40);
    textFont(gulax);

    //timer setup
    // time = millis();
    //store the current time
    //initiate the points for the active curve
    for (int i = 0; i < activeCurvePoints.length; i++) {
        activeCurvePoints[i] = new PVector(width / 2, height / 2);
    }

    //initiate the first curve
    storeBezier();
    stored = false;
}

void draw() {

    if (graphicMode == 0) {
        image(photo, 0, 0);
        photo.resize(width, height);
        if (initiatePlacementMode == true) {
            getUserInputPlacement();
            image(pg, cursor1x, cursor1y, cursor2x, cursor2y);

            //prevent the second cursor to go to a place making the paste impossible
            if (cursor2x < cursor1x) {
                cursor2x = cursor1x;
            }
            if (cursor2y < cursor1y) {
                cursor2y = cursor1y;
            }

        } else {
            collaborativePhoto();
        }
    } else if (graphicMode == 1) {
        collaborativeBezier();
    }
}

// void pasteShapeMirror(int blendMode) {
//     int pasteCornerX = Math.min(cursor1x, cursor2x);
//     int pasteCornerY = Math.min(cursor1y, cursor2y);
//     int pasteWidth = Math.max(cursor1x, cursor2x);
//     int pasteHeight = Math.max(cursor1y, cursor2y);

//     photo.blend(pg, 0, 0, width, height, pasteCornerX, pasteCornerY, pasteWidth, pasteHeight, blendMode);
// }