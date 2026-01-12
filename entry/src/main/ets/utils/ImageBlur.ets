import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';

export function ImageBlur(imageBuffer: ArrayBuffer): Promise<image.PixelMap> {
  return new Promise((resolve) => {
    let imageSource = image.createImageSource(imageBuffer);
    imageSource.createPixelMap().then(async (pixelMap: image.PixelMap) => {
      let radius = 8;
      let headFilter = effectKit.createEffect(pixelMap);
      if (headFilter != null) {
        headFilter.blur(radius);
      }
      headFilter.getEffectPixelMap().then(imageData => {
        resolve(imageData);
      })
    })
  })
}