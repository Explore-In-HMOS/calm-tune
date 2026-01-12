import { ArcButton, ArcButtonOptions, ArcButtonStyleMode, ColorMetrics } from '@kit.ArkUI';
import { HomeViewModel } from '../viewmodel/HomeViewModel';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { ImageBlur } from '../utils/ImageBlur';

@Component
export struct HomePage {
  homeVm: HomeViewModel = new HomeViewModel();
  @State imagePixelMap: image.PixelMap | null = null;
  private imageBuffer: ArrayBuffer | undefined = undefined;

  async getFileBuffer(): Promise<ArrayBuffer | undefined> {
    try{
      const context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const fileData: Uint8Array = await context.resourceManager.getRawFileContent('home_bg.jpg');
      const buffer: ArrayBuffer = fileData.buffer.slice(0);
      return buffer;
    }catch (err){
      return undefined
    }
  }

  async aboutToAppear(): Promise<void>{
    this.imageBuffer = await this.getFileBuffer();
    if(this.imageBuffer === undefined){
      return;
    }
    this.imagePixelMap = await ImageBlur(this.imageBuffer);
  }

  build() {
    Stack({alignContent: Alignment.Center}) {
      Column({space: 8}) {
        Text('CALMTUNE')
          .fontSize(26)
          .fontWeight(FontWeight.Bolder)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)

        Text('Pomodoro And Music')
          .fontSize(14)
          .fontWeight(FontWeight.Bolder)
          .fontColor('#ffeceaea')
          .textAlign(TextAlign.Center)
      }
      .zIndex(2)

      Image(this.imagePixelMap)
        .zIndex(1)
        .width('100%')
        .height('100%')
        .opacity(0.6)

      ArcButton({
        options: new ArcButtonOptions({
          label: 'START',
          styleMode: ArcButtonStyleMode.CUSTOM,
          backgroundColor: ColorMetrics.resourceColor('#ffa75d1c'),
          onClick: () => {
            this.homeVm.goToNextPage()
          }
        })
      })
        .offset({x: 0, y: 90})
        .zIndex(2)
    }
    .height('100%')
    .width('100%')
  }
}