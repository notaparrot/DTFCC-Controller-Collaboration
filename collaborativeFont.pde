void collaborativeFont(){
      background(0, 0, 98, 120);
  getFontInput();

  if (textMode == 0) {
    textInput();
  } else if (textMode == 1) {
    textToTiles();
  }
}

void textInput() {

  textSize(textInputSize);
  fill(colorWheelH, colorWheelS, 80);
  if (!initialText.isEmpty()) {
    text(initialText, width / 6, height / 4);
  }

  if (sin(frameCount / 9) > 0) {
    stroke(0);
    line(width / 6 + textCursor, 0, width / 6 + textCursor, height);
  }
}

void textToTiles() {
  background(0, 0, 98);
  textImg.beginDraw();
  textImg.clear();
  textImg.noStroke();
  textImg.colorMode(HSB, 100, 100, 100, 255);
  textImg.textFont(fonts[fontSelector]);
  textImg.textSize(textInputSize);
  textImg.fill(colorWheelH, colorWheelS, 80);
  textImg.text(initialText, width / 6, height / 4);
  textImg.endDraw();

  // image(textImg, 0, 0);
  textExport.beginDraw();
  textExport.noStroke();
  textExport.colorMode(HSB, 100, 100, 100, 255);
  textExport.textFont(fonts[fontSelector]);
  textExport.textSize(textInputSize);
  textExport.fill(colorWheelH, colorWheelS, 80);
  textExport.background(0, 0, 98, 0);


  if (showFontGhost) {
    textExport.fill(colorWheelH, colorWheelS + 20, 100);
    textExport.text(initialText, width / 6, height / 4);
    textExport.fill(colorWheelH, colorWheelS, 80);

    println("showing font ghost");
  }

  int tileW = int(width / tilesX);
  int tileH = int(height / tilesY);

  for (int y = 0; y < tilesY; y++) {
    for (int x = 0; x < tilesX; x++) {


      int wave = int(sin(frameCount * 0.01 + (x * y)) * waveStrength);

      int sx = 0;
      int sy = 0;
      int sw = 0;
      int sh = 0;
      // SOURCE
      if (textDeformMode == 0) {
        sx = x * tileW + wave;
        sy = y * tileH;
        sw = tileW;
        sh = tileH;
      }
      if (textDeformMode == 1) {
        sx = x * tileW;
        sy = y * tileH+ wave;
        sw = tileW;
        sh = tileH;
      }
      if (textDeformMode == 2) {
        sx = x * tileW + wave;
        sy = y * tileH+ wave;
        sw = tileW;
        sh = tileH;
      }
      if (textDeformMode == 3) {
        sx = x * tileW + int(sin(frameCount * 0.01 + x) * waveStrength);
        sy = y * tileH+ int(sin(frameCount * 0.02 + y )* waveStrength);
        sw = tileW;
        sh = tileH;
      }


      // DESTINATION
      int dx = x * tileW;
      int dy = y * tileH;
      int dw = tileW;
      int dh = tileH;



      textExport.copy(textImg, sx, sy, sw, sh, dx, dy, dw, dh);
      ////draw grid
      if (showGrid) {
        textExport.stroke(60, 100, 80);
        textExport.noFill();
        textExport.rect(x * tileW, y * tileH, sw, sh);
        textExport.fill(colorWheelH, colorWheelS, 80);
        textExport.noStroke();
      }
    }
  }
  textExport.endDraw();
  image(textExport, 0, 0);
  textExport.clear();
}


void keyPressed() {

  if (keyCode != 16 && keyCode != 8) {
    initialText += key;
    lines.set(lines.size() - 1, lines.get(lines.size() - 1) + key);
    textCursor = textWidth(lines.get(lines.size() - 1));

    if (keyCode == 10) {
      lines.append("");
      textCursor = textWidth(lines.get(lines.size() - 1));
    }
  } else if (keyCode == 8) {
    if (initialText != null && initialText.length() > 0) {
      initialText = initialText.substring(0, initialText.length() - 1);

      //relative to cursor
      if (textWidth(lines.get(lines.size() - 1)) > 0) {
        int lastLinesItem = lines.size() - 1;
        lines.set(lastLinesItem, lines.get(lastLinesItem).substring(0, lines.get(lastLinesItem).length() - 1));
        textCursor = textWidth(lines.get(lines.size() - 1));
      } else {
        lines.remove(lines.size() - 1);
        textCursor = textWidth(lines.get(lines.size() - 1));
        lines.set(lines.size() - 1, lines.get(lines.size() - 1).substring(0, lines.get(lines.size() - 1).length() - 1));
      }
    }
  }
}