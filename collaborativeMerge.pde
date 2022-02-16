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
//Font setup//
//////////////////////////////////////////////////////////////////////

PFont[] fonts = new PFont[5];
StringList lines = new StringList();
String initialText = new String();
int textInputSize = 128;
float textCursor = 0;
PGraphics textImg;
int textMode = 0;
float tilesX = 8;
float tilesY = 8;
boolean showGrid, showFontGhost;
PGraphics textExport;
int textDeformMode = 0;
int waveStrength = 10;
float sinPhase = 0.01;
int fontSelector = 0;

//////////////////////////////////////////////////////////////////////
//Mode setup//
//////////////////////////////////////////////////////////////////////

int graphicMode = 0;
boolean initiatePhotoMode = false;
boolean initiateBezierMode = false;
boolean initiatePlacementMode = false;
boolean initiateTextPlacement = false;
PGraphics pg;
PGraphics textBuffer;
boolean pastingTextD = false;
boolean pastingTextL = false;


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


    size(600, 600, P2D);
    // fullScreen();

    //PHOTO style setup
    photo = loadImage("1.JPG");
    photo.resize(width, height);
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

    //FONT style setup
    fonts[0] = createFont("Gulax-Regular.otf", height, true);
    fonts[1] = createFont("Anthony.otf", height, true);
    fonts[2] = createFont("PicNic-Regular.otf", height, true);
    fonts[3] = createFont("Lment-v02.otf", height, true);
    fonts[4] = createFont("SolideMirage-Etroit.otf", height, true);
    textFont(fonts[fontSelector]);
    lines.append("");
    textImg = createGraphics(width, height, P2D);
    textImg.smooth(8);
    textExport = createGraphics(width, height, P2D);
    textExport.smooth(8);
}

void draw() {

    if (graphicMode == 0) {
        image(photo, 0, 0);
        if (initiatePlacementMode == false && initiateTextPlacement == false) {
            collaborativePhoto();
        } else if (initiatePlacementMode == true) {
            getUserInputPlacement();

            //prevent the second cursor to go to a place making the paste impossible
            if (cursor2x < cursor1x) {
                cursor2x = cursor1x;
            }
            if (cursor2y < cursor1y) {
                cursor2y = cursor1y;
            }
            image(pg, cursor1x, cursor1y, cursor2x, cursor2y);
        } else if (initiateTextPlacement = true) {
            // Initialise textbuffer  + copy code for placement of text.
            getUserInputPlacement();
            if (cursor2x < cursor1x) {
                cursor2x = cursor1x;
            }
            if (cursor2y < cursor1y) {
                cursor2y = cursor1y;
            }
            image(textExport, cursor1x, cursor1y, cursor2x, cursor2y);

            if (pastingTextD == true) {
                photo.blend(textExport, 0, 0, width, height, cursor1x, cursor1y, cursor2x, cursor2y, DARKEST);
                initiateTextPlacement = false;
                cursor1x = width / 2 - 5;
                cursor1y = height / 2 - 5;
                cursor2x = width / 2 + 5;
                cursor2y = height / 2 + 5;
                pastingTextD = false;
            } else if (pastingTextL){
                photo.blend(textExport, 0, 0, width, height, cursor1x, cursor1y, cursor2x, cursor2y, LIGHTEST);
                initiateTextPlacement = false;
                cursor1x = width / 2 - 5;
                cursor1y = height / 2 - 5;
                cursor2x = width / 2 + 5;
                cursor2y = height / 2 + 5;
                pastingTextL = false;
            }
        }
    } else if (graphicMode == 1) {
        collaborativeBezier();
    } else if (graphicMode == 2) {
        collaborativeFont();
    }
}