void collaborativePhoto() {
    image(photo, 0, 0);
    photo.resize(width, height);

    triggerCursors();
    drawCursors();

    if (isCursor1triggered || isCursor2triggered) {
        copyProcess();
    }
    if (paste == true) {
        pasteProcess();
    }

}
void drawCursors() {
    noFill();
    if (isCursor1triggered) {
        fill(playerPalette[0]);
    }
    stroke(playerPalette[0]);
    circle(cursor1x, cursor1y, 10);
    noFill();
    if (isCursor2triggered) {
        fill(playerPalette[3]);
    }
    stroke(playerPalette[3]);
    circle(cursor2x, cursor2y, 10);
    noFill();
}

void copyProcess() {

    if (initiateCopy) {
        sx = cursor1x;
        sy = cursor1y;
        sw = cursor2x - cursor1x;
        sh = cursor2y - cursor1y;

        //define origins
        sourceTopX = Math.min(cursor1x, cursor2x);
        sourceTopY = Math.min(cursor1y, cursor2y);
        sourceWidth = Math.max(cursor1x, cursor2x) - sourceTopX;
        sourceHeight = Math.max(cursor1y, cursor2y) - sourceTopY;

        initiateCopy = false;

        //mirror
        // angleCopy = degrees(new PVector(cursor1x - cursor2x, cursor1y - cursor2y).heading());
    }

    stroke(playerPalette[1]);
    rect(cursor1x, cursor1y, cursor2x - cursor1x, cursor2y - cursor1y);

    int pasteCornerX = Math.min(cursor1x, cursor2x);
    int pasteCornerY = Math.min(cursor1y, cursor2y);
    int pasteWidth = Math.max(cursor1x, cursor2x) - pasteCornerX;
    int pasteHeight = Math.max(cursor1y, cursor2y) - pasteCornerY;
    copy(photo,sourceTopX, sourceTopY, sourceWidth, sourceHeight, pasteCornerX, pasteCornerY, pasteWidth, pasteHeight);

    // copy(photo, sx, sy, sw, sh, cursor1x, cursor1y, cursor2x - cursor1x, cursor2y - cursor1y);

}

void pasteProcess() {
    paste = false;
    initiateCopy = true;

    //here we define the new corner were we paste        
    int pasteCornerX = Math.min(cursor1x, cursor2x);
    int pasteCornerY = Math.min(cursor1y, cursor2y);
    int pasteWidth = Math.max(cursor1x, cursor2x) - pasteCornerX;
    int pasteHeight = Math.max(cursor1y, cursor2y) - pasteCornerY;

    photo.copy(sourceTopX, sourceTopY, sourceWidth, sourceHeight, pasteCornerX, pasteCornerY, pasteWidth, pasteHeight);
}