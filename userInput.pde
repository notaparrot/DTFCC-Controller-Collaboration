//////////////////////////////////////////////////////////////////////
//Overview controls//
//////////////////////////////////////////////////////////////////////

//Switch to different mode

void onStartButtonRelease() {
  if (graphicMode == State.PHOTO) {
    initiateBezierMode = true;
    listCurves.clear();
    storeBezier();
    stored = false;
    graphicMode = State.BEZIER;
    initiateTextPlacement = false;
  } else if (graphicMode == State.BEZIER) {
    //store svg drawing and switch to placement mode
    pg = createGraphics(width, height);
    pg.smooth(8);
    pg.beginDraw();
    if (isCapRound == false) {
      pg.strokeCap(SQUARE);

    } else {
      pg.strokeCap(ROUND);
    }
    pg.colorMode(HSB, 100, 100, 100, 255);
    pg.strokeWeight(lineStrokeWeight);
    pg.stroke(colorWheelH, colorWheelS, 80);
    pg.noFill();
    //pg.background(0, 0, 0, 0);
    for (int i = 0; i < listCurves.size(); i++) {
      pg.beginShape();
      listCurves.get(i).transferPg(pg);
      pg.endShape();
    }
    pg.endDraw();

    // initiatePhotoMode = true;
    initiatePlacementMode = true;
    graphicMode = State.FONT;
    //move cursor in an appropriate place to paste the shape
    cursor1x = 0;
    cursor1y = 0;
    cursor2x = width;
    cursor2y = height;
  } else if (graphicMode == State.FONT) {
    initiateTextPlacement = true;
    graphicMode = State.PHOTO;
    //move cursor in an appropriate place to paste the shape
    cursor1x = 0;
    cursor1y = 0;
    cursor2x = width;
    cursor2y = height;

  }
}

void getUserInputPlacement() {
  float cursorSpeed = 7.5;

  //left joystick
  if (xboxController.getSlider("lsx").getValue() > 0.2) {
    cursor1x += abs(xboxController.getSlider("lsx").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("lsx").getValue() < -0.2) {
    cursor1x -= abs(xboxController.getSlider("lsx").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("lsy").getValue() > 0.2) {
    cursor1y += abs(xboxController.getSlider("lsy").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("lsy").getValue() < -0.2) {
    cursor1y -= abs(xboxController.getSlider("lsy").getValue()) * cursorSpeed;
  }

  //right joystick
  if (xboxController.getSlider("rsx").getValue() > 0.2) {
    cursor2x += abs(xboxController.getSlider("rsx").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("rsx").getValue() < -0.2) {
    cursor2x -= abs(xboxController.getSlider("rsx").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("rsy").getValue() > 0.2) {
    cursor2y += abs(xboxController.getSlider("rsy").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("rsy").getValue() < -0.2) {
    cursor2y -= abs(xboxController.getSlider("rsy").getValue()) * cursorSpeed;
  }
}

//in bezier mode:  store the curve in the list
//in photo mode: print svg on image
void onSelectButtonRelease() {
  if (graphicMode == State.BEZIER) {
    storeBezier();
  }

  if (graphicMode == State.FONT) {
    if (textMode == 0) {
      textMode = 1;
    } else {
      textMode = 0;
    }
  }

  if (graphicMode == State.PHOTO) {
    initiatePlacementMode = false;
    graphicMode = State.FONT;
  }
}

//////////////////////////////////////////////////////////////////////
//Photo Control//
//////////////////////////////////////////////////////////////////////


public void getUserInputPhoto() {

  float cursorSpeed = 7.5;

  //left joystick
  if (xboxController.getSlider("lsx").getValue() > 0.2) {
    cursor1x += abs(xboxController.getSlider("lsx").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("lsx").getValue() < -0.2) {
    cursor1x -= abs(xboxController.getSlider("lsx").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("lsy").getValue() > 0.2) {
    cursor1y += abs(xboxController.getSlider("lsy").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("lsy").getValue() < -0.2) {
    cursor1y -= abs(xboxController.getSlider("lsy").getValue()) * cursorSpeed;
  }

  //right joystick
  if (xboxController.getSlider("rsx").getValue() > 0.2) {
    cursor2x += abs(xboxController.getSlider("rsx").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("rsx").getValue() < -0.2) {
    cursor2x -= abs(xboxController.getSlider("rsx").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("rsy").getValue() > 0.2) {
    cursor2y += abs(xboxController.getSlider("rsy").getValue()) * cursorSpeed;
  }
  if (xboxController.getSlider("rsy").getValue() < -0.2) {
    cursor2y -= abs(xboxController.getSlider("rsy").getValue()) * cursorSpeed;
  }

  //prevent cursors from going offscreen
  cursor1x = constrain(cursor1x, 0, width);
  cursor2x = constrain(cursor2x, 0, width);
  cursor1y = constrain(cursor1y, 0, height);
  cursor2y = constrain(cursor2y, 0, height);
}

void triggerCursors() {
  if (xboxController.getButton("lb").pressed()) {
    isCursor1triggered = true;
  }
  if (xboxController.getButton("rb").pressed()) {
    isCursor2triggered = true;
  }
}

void onlbRelease() {
  isCursor1triggered = false;
  paste = true;
}

void onrbRelease() {
  isCursor2triggered = false;
  paste = true;
}


//////////////////////////////////////////////////////////////////////
//Bezier Controls//
//////////////////////////////////////////////////////////////////////

public void getUserInputBezier() {

  int cursorSpeed = 3;

  //left joystick
  if (xboxController.getSlider("lsx").getValue() > 0.5) {
    activeCurvePoints[0].x += cursorSpeed;
  }
  if (xboxController.getSlider("lsx").getValue() < -0.5) {
    activeCurvePoints[0].x -= cursorSpeed;
  }
  if (xboxController.getSlider("lsy").getValue() > 0.5) {
    activeCurvePoints[0].y += cursorSpeed;
  }
  if (xboxController.getSlider("lsy").getValue() < -0.5) {
    activeCurvePoints[0].y -= cursorSpeed;
  }

  //right joystick
  if (xboxController.getSlider("rsx").getValue() > 0.5) {
    activeCurvePoints[3].x += cursorSpeed;
  }
  if (xboxController.getSlider("rsx").getValue() < -0.5) {
    activeCurvePoints[3].x -= cursorSpeed;
  }
  if (xboxController.getSlider("rsy").getValue() > 0.5) {
    activeCurvePoints[3].y += cursorSpeed;
  }
  if (xboxController.getSlider("rsy").getValue() < -0.5) {
    activeCurvePoints[3].y -= cursorSpeed;
  }

  //directional cross 

  if (xboxController.getHat("dpad").left()) {
    activeCurvePoints[1].x -= cursorSpeed;
  }
  if (xboxController.getHat("dpad").right()) {
    activeCurvePoints[1].x += cursorSpeed;
  }
  if (xboxController.getHat("dpad").up()) {
    activeCurvePoints[1].y -= cursorSpeed;
  }
  if (xboxController.getHat("dpad").down()) {
    activeCurvePoints[1].y += cursorSpeed;
  }
  //right buttons

  if (xboxController.getButton("a").pressed()) {
    activeCurvePoints[2].y += cursorSpeed;
  }

  if (xboxController.getButton("y").pressed()) {
    activeCurvePoints[2].y -= cursorSpeed;
  }

  if (xboxController.getButton("x").pressed()) {
    activeCurvePoints[2].x -= cursorSpeed;
  }

  if (xboxController.getButton("b").pressed()) {
    activeCurvePoints[2].x += cursorSpeed;
  }


  // round position of cursor mapped to joysticks
  ////left joystick
  if (xboxController.getSlider("lsx").getValue() < 0.5 && xboxController.getSlider("lsx").getValue() > -0.5) {
    activeCurvePoints[0].x = roundToGrid(int(activeCurvePoints[0].x));
  }
  if (xboxController.getSlider("lsy").getValue() < 0.5 && xboxController.getSlider("lsy").getValue() > -0.5) {
    activeCurvePoints[0].y = roundToGrid(int(activeCurvePoints[0].y));
  }
  ////right joystick
  if (xboxController.getSlider("rsx").getValue() < 0.5 && xboxController.getSlider("rsx").getValue() > -0.5) {
    activeCurvePoints[3].x = roundToGrid(int(activeCurvePoints[3].x));
  }
  if (xboxController.getSlider("rsy").getValue() < 0.5 && xboxController.getSlider("rsy").getValue() > -0.5) {
    activeCurvePoints[3].y = roundToGrid(int(activeCurvePoints[3].y));
  }
  ////directional cross
  if (xboxController.getHat("dpad").left() == false && xboxController.getHat("dpad").right() == false) {
    activeCurvePoints[1].x = roundToGrid(int(activeCurvePoints[1].x));
  }
  if (xboxController.getHat("dpad").up() == false && xboxController.getHat("dpad").down() == false) {
    activeCurvePoints[1].y = roundToGrid(int(activeCurvePoints[1].y));
  }

  //prevent cursors from going offscreen
  activeCurvePoints[0].x = constrain(activeCurvePoints[0].x, 0, width);
  activeCurvePoints[0].y = constrain(activeCurvePoints[0].y, 0, height);
  activeCurvePoints[1].x = constrain(activeCurvePoints[1].x, 0, width);
  activeCurvePoints[1].y = constrain(activeCurvePoints[1].y, 0, height);
  activeCurvePoints[2].x = constrain(activeCurvePoints[2].x, 0, width);
  activeCurvePoints[2].y = constrain(activeCurvePoints[2].y, 0, height);
  activeCurvePoints[3].x = constrain(activeCurvePoints[3].x, 0, width);
  activeCurvePoints[3].y = constrain(activeCurvePoints[3].y, 0, height);

  //change line strokeWeight
  if (xboxController.getButton("rb").pressed()) {
    lineStrokeWeight += 1;
  }
  if (xboxController.getButton("lb").pressed()) {
    lineStrokeWeight -= 1;
    if (lineStrokeWeight < 1) {
      lineStrokeWeight = 1;
    }
  }

  //change color
  if (xboxController.getSlider("lrt").getValue() > 0.2) {
    colorWheelH += 1;
    if (colorWheelH >= 100) {
      colorWheelH = 0;
    }
  }
  if (xboxController.getSlider("lrt").getValue() < -0.2) {
    colorWheelS += 1;
    if (colorWheelS >= 100) {
      colorWheelS = 0;
    }
  }
}



// events to round cursor position when the button is not pressed anymore
void onaButtonRelease() {
  if (graphicMode == State.BEZIER) {
    activeCurvePoints[2].y = roundToGrid(int(activeCurvePoints[2].y));
  } else if (graphicMode == State.PHOTO && initiatePlacementMode == true) {
    //paste the generated shape
    photo.blend(pg, 0, 0, width, height, cursor1x, cursor1y, cursor2x, cursor2y, LIGHTEST);
    initiatePlacementMode = false;

    cursor1x = width / 2 - 5;
    cursor1y = height / 2 - 5;
    cursor2x = width / 2 + 5;
    cursor2y = height / 2 + 5;

    //odd bug workaround
    paste = false;
  } else if (graphicMode == State.PHOTO && initiateTextPlacement == true) {
pastingTextL = true;

  } else if (graphicMode == State.FONT) {
    showGrid = !showGrid;
  }
}
void onyButtonRelease() {
  if (graphicMode == State.BEZIER) {
    activeCurvePoints[2].y = roundToGrid(int(activeCurvePoints[2].y));
  } else if (graphicMode == State.FONT) {
    textDeformMode++;
    if (textDeformMode == 4) {
      textDeformMode = 0;
    }
  }
}
void onxButtonRelease() {
  if (graphicMode == State.BEZIER) {
    activeCurvePoints[2].x = roundToGrid(int(activeCurvePoints[2].x));
  } else if (graphicMode == State.FONT) {
    fontSelector++;
    if (fontSelector >= 5) {
      fontSelector = 0;
    }
    textFont(fonts[fontSelector]);
    textCursor = textWidth(lines.get(lines.size() - 1));

  }
}
void onbButtonRelease() {
  if (graphicMode == State.BEZIER) {

    activeCurvePoints[2].x = roundToGrid(int(activeCurvePoints[2].x));
  } else if (graphicMode == State.PHOTO && initiatePlacementMode == true) {
    // paste the generated shape
    photo.blend(pg, 0, 0, width, height, cursor1x, cursor1y, cursor2x, cursor2y, DARKEST);
    initiatePlacementMode = false;

    cursor1x = width / 2 - 5;
    cursor1y = height / 2 - 5;
    cursor2x = width / 2 + 5;
    cursor2y = height / 2 + 5;
    //odd bug workaround
    paste = false;
  } else if (graphicMode == State.FONT) {
    showFontGhost = !showFontGhost;
  } else if (graphicMode == State.PHOTO && initiateTextPlacement == true) {
pastingTextD = true;

  }
}

void onrightThumbRelease() {
  if (isCapRound) {
    strokeCap(SQUARE);
    isCapRound = false;
  } else {
    strokeCap(ROUND);
    isCapRound = true;
  }
}

//////////////////////////////////////////////////////////////////////
//font Controls//
//////////////////////////////////////////////////////////////////////

void getFontInput() {

  if (xboxController.getButton("rb").pressed()) {
    textInputSize += 1;
    textCursor = textWidth(lines.get(lines.size() - 1));

  }
  if (xboxController.getButton("lb").pressed()) {
    textInputSize -= 1;
    textCursor = textWidth(lines.get(lines.size() - 1));

    if (textInputSize < 12) {
      textInputSize = 12;
    }
  }
  //right joystick
  if (xboxController.getSlider("rsx").getValue() > 0.2) {
    tilesX -= 0.1;
    if (tilesX < 4) {
      tilesX = 4;
    }
  }
  if (xboxController.getSlider("rsx").getValue() < -0.2) {
    tilesX += 0.1;

  }
  if (xboxController.getSlider("rsy").getValue() > 0.2) {
    tilesY -= 0.1;
    if (tilesY < 4) {
      tilesY = 4;
    }
  }
  if (xboxController.getSlider("rsy").getValue() < -0.2) {
    tilesY += 0.1;
  }

  //    //left joystick
  if (xboxController.getSlider("lsx").getValue() > 0.2) {
    waveStrength += 1;
  }
  if (xboxController.getSlider("lsx").getValue() < -0.2) {
    waveStrength -= 1;
    if (waveStrength < 5) {
      waveStrength = 5;
    }
  }
  if (xboxController.getSlider("lsy").getValue() > 0.2) {
    sinPhase += 0.01;
  }
  if (xboxController.getSlider("lsy").getValue() < -0.2) {
    sinPhase -= 0.01;
    if (sinPhase < 0.1) {
      sinPhase = 0.1;
    }
  }


  //triggers
  if (xboxController.getSlider("lrt").getValue() > 0.2) {
    colorWheelH += 1;
    if (colorWheelH >= 100) {
      colorWheelH = 0;
    }
  }
  if (xboxController.getSlider("lrt").getValue() < -0.2) {
    colorWheelS += 1;
    if (colorWheelS >= 100) {
      colorWheelS = 0;
    }
  }
}