HSB[] dither(HSB[] src, int w, int h, HSB[] palette, String method) {
  Kernel kernel = kernelLoader.get(method);

  if(w * h != src.length)
    return null;
    
  if(kernel == null) {
    println("No dithering kernel found with the name " + method);
    return null;
  }

  HSB[] dithered = new HSB[src.length];
  for(int i = 0; i < src.length; i++)
    dithered[i] = new HSB(src[i]);
  
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      HSB c = dithered[y * w + x];
      HSB match = getClosest(c, palette);
      float[] error = subtract(c, match);
      
      dithered[y * w + x].copy(match);

      int sizeHalf = kernel.size / 2;
      int lenHalf = kernel.size * kernel.size / 2 + 1;

      for(int v = 0; v < kernel.values.length; v++) {
        int shifted = v + lenHalf;
        
        int i = shifted % kernel.size;
        int j = (shifted - i) / kernel.size;
        
        int xx = x + i - sizeHalf;
        int yy = y + j - sizeHalf;

        if(xx >= 0 && yy >= 0 && xx < w && yy < h) {
          HSB neighbour = dithered[yy * w + xx];
          float[] ex = multiply(error, kernel.values[v]);
          dithered[yy * w + xx] = add(neighbour, ex);
        }
      }
    }
  }
  
  return dithered;
}

HSB getClosest(HSB c, HSB[] palette) {
  int closest = -1;
  float delta = Float.MAX_VALUE;
  
  for(int i = 0; i < palette.length; i++) {    
    HSB p = palette[i];
    
    float dh = c.h - p.h;
    float ds = c.s - p.s;
    
    dh /= 255;
    ds /= 255;
        
    float distance = pow(dh, 2) + pow(ds, 2);
    if(distance < delta) {
      delta = distance;
      closest = i;
    }    
  }
  
  return palette[closest];
}

float[] subtract(HSB a, HSB b) {
    return new float[] {a.h - b.h, a.s - b.s, a.b - b.b };
}

HSB add(HSB a, HSB b) {
    float r = max(0, min(a.h + b.h, 255));
    float g = max(0, min(a.s + b.s, 255));
    float l = max(0, min(a.b + b.b, 255));

    return new HSB(r, g, l);
}

HSB add(HSB a, float[] b) {
    float br = b[0];
    float bg = b[1];
    float bb = b[2];
    
    float r = max(0, min(a.h + br, 255));
    float g = max(0, min(a.s + bg, 255));
    float l = max(0, min(a.b + bb, 255));

    return new HSB(r, g, l);
}

float[] multiply(float[] a, float b) {
  float[] result = new float[a.length];
  
  for(int i = 0; i < a.length; i++)
    result[i] = a[i] * b;
    
    return result;
}
