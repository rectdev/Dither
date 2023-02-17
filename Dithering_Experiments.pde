color[] palette = {
  color(255, 0, 0),
  color(255, 255, 255),
  color(0, 255, 0),
  color(0, 0, 255),
  color(255, 255, 0),
  color(255, 128, 0),
  color(0, 0, 0)
};

color[] dominantPalette;
color[] bwPalette;
PImage img;
PImage bw;

int colorCount = 8;
int bwCount = 8;

boolean init = true;

void setup() {
  img = loadImage("kas.jpg");
  surface.setResizable(true);
  surface.setSize(img.width, img.height);

  dominantPalette = reducedPalette(img, colorCount);
  bw = blackAndWhite(img);
  bwPalette = new color[bwCount];
  for (int i = 0; i < bwCount; i++)
    bwPalette[i] = color(255f * i / (bwCount - 1));
}

void draw() {
  if (init) {
    image(img, 0, 0);
    init = false;
  }
}

void keyPressed() {
  if (key == 'f') {
    PImage dithered = kernelDither(img, dominantPalette, floydSteinbergKernel, fsSize);
    background(dithered);
  } else if (key == 's') {
    PImage dithered = kernelDither(img, dominantPalette, stuckiKernel, sSize);
    background(dithered);
  } else if (key == 'j') {
    PImage dithered = kernelDither(img, dominantPalette, jarvisJudiceNinkeKernel, jSize);
    background(dithered);
  } else if (key == 'i') {
    PImage dithered = kernelDither(img, dominantPalette, sierraKernel, sierraSize);
    background(dithered);
  } else if (key == 'a') {
    PImage dithered = kernelDither(img, dominantPalette, atkinsonKernel, atkinsonSize);
    background(dithered);
  } else if (key == ' ') {
    background(img);
  } else if (key == 'w') {
    PImage dithered = kernelDither(bw, bwPalette, atkinsonKernel, atkinsonSize);
    background(dithered);
  } else if (key == 'o') {
    background(img);
  }
}
