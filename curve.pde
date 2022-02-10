class Curve {
    PVector[] storedCurve = new PVector[4];

    Curve() {
        for (int i = 0; i < storedCurve.length; i++) {
            storedCurve[i] = new PVector(0, 0);
        }
    }

    void drawCurve() {
        strokeWeight(lineStrokeWeight);
        stroke(colorWheelH, colorWheelS, 80);

        bezier(storedCurve[0].x, storedCurve[0].y, storedCurve[1].x, storedCurve[1].y, storedCurve[2].x, storedCurve[2].y, storedCurve[3].x, storedCurve[3].y);

        // println(storedCurve[0]);
    }

    void drawPlayer() {
        //dessine les repères des joueurs
        strokeWeight(3);
        noFill();
        for (int i = 0; i < playerPalette.length; i++) {
            stroke(playerPalette[i], 100);
            circle(activeCurvePoints[i].x, activeCurvePoints[i].y, 10);
        }
    }

    void move(PVector a, PVector b, PVector c, PVector d) {
        storedCurve[0] = a;
        storedCurve[1] = b;
        storedCurve[2] = c;
        storedCurve[3] = d;

    }
    void transferPg(PGraphics pg) {
        pg.vertex(storedCurve[0].x, storedCurve[0].y);
        pg.bezierVertex(storedCurve[1].x, storedCurve[1].y, storedCurve[2].x, storedCurve[2].y, storedCurve[3].x, storedCurve[3].y);

    }
}