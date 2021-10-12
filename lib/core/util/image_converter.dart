import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

class ImageConverter {
  Uint8List imageToByteListFloat32(File image) {
    Image resized = decodeImage(File(image.path).readAsBytesSync());
    resized = copyResize(resized, width: 150, height: 115);

    var convertedBytes = Float32List(115 * 150 * 1);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < 115; i++) {
      for (var j = 0; j < 150; j++) {
        var pixel = resized.getPixel(j, i);
        buffer[pixelIndex++] =
            (getRed(pixel) + getGreen(pixel) + getBlue(pixel)) / 3 / 255.0;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
