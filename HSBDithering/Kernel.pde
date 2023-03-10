import processing.data.*;

class KernelLoader {
  HashMap<String, Kernel> kernelDict;

  public KernelLoader(String path) {
    kernelDict = new HashMap<String, Kernel>();
    JSONObject data = loadJSONObject(path);
    JSONArray kernels = data.getJSONArray("kernels");
    for(int i = 0; i < kernels.size(); i++) {
      JSONObject kernelObject = kernels.getJSONObject(i);
      String name = kernelObject.getString("name");
      kernelDict.put(name, new Kernel(kernelObject));
    }
  }
  
  public Kernel get(String name) {
    return kernelDict.get(name);
  }
}

class Kernel {
  int size;
  float[] values;
  
  Kernel() {}
  
  Kernel(JSONObject data) {
    size = data.getInt("size");
    values = new float[data.getJSONArray("values").size()];
    float divider = data.getFloat("divider");

    for(int i = 0; i < values.length; i++)
      values[i] = data.getJSONArray("values").getInt(i) / divider;
  }
}
