import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { AMBIENCES, AMBIENCE_ENUMS } from '../viewmodel/Ambiences';
import { AmbienceViewModel } from '../viewmodel/AmbienceViewModel';
import { DataModel } from '../viewmodel/DataModel';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { ImageBlur } from '../utils/ImageBlur';

@Builder
function buildText() {
  Column() {
    Text('Select Ambience')
      .fontSize(28)
      .fontWeight(FontWeight.Bolder)
      .fontColor(Color.White)
  }
  .margin(6)
}

@Component
export struct AmbiencePage {
  context: UIContext = this.getUIContext()
  header: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(buildText));
  @State showLoading : boolean = false
  ambienceVm : AmbienceViewModel = new AmbienceViewModel()

  @State imagePixelMap: image.PixelMap | null = null;
  private imageBuffer: ArrayBuffer | undefined = undefined;

  async getFileBuffer(): Promise<ArrayBuffer | undefined> {
    try{
      const context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const fileData: Uint8Array = await context.resourceManager.getRawFileContent('ambience_bg.jpg');
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
    Stack() {
      LoadingProgress()
        .width(60)
        .height(60)
        .zIndex(4)
        .enableLoading(this.showLoading)

      Image(this.imagePixelMap)
        .objectFit(ImageFit.Fill)
        .zIndex(1)
        .width('100%')
        .height('100%')
        .opacity(0.8)
        .onComplete(() => {
          this.showLoading = !this.showLoading
        })

      ArcList({
        initialIndex: 0, header: this.header
      }) {
        ForEach(AMBIENCES, (item: string, index: number) => {
          ArcListItem() {
            Row({space: 20}) {
              Text(item)
                .fontSize(22)
                .fontColor('#ffeceaea')
                .fontWeight(FontWeight.Bold)
            }
            .padding({
              left: 26,
              bottom: 12,
              top: 12,
              right: 26
            })
            .backgroundColor('#7ab06b3e')
            .width('100%')
            .height('100px')
            .borderRadius(48)
            .borderWidth(1)
            .borderColor('#ffeceaea')

          }
          .onClick(() => {
            if (item === AMBIENCE_ENUMS.Lofi) {
              AppStorage.setOrCreate('songList', DataModel.LOFI);
            } else if (item === AMBIENCE_ENUMS.Rain) {
              AppStorage.setOrCreate('songList', DataModel.RAIN);
            } else if (item === AMBIENCE_ENUMS.Coffee_shop) {
              AppStorage.setOrCreate('songList', DataModel.COFFEE_SHOP);
            } else if (item === AMBIENCE_ENUMS.Fireplace) {
              AppStorage.setOrCreate('songList', DataModel.FIREPLACE);
            } else if (item === AMBIENCE_ENUMS.Waves_ocean) {
              AppStorage.setOrCreate('songList', DataModel.WAVES_OCEAN);
            } else if (item === AMBIENCE_ENUMS.Forest_birds) {
              AppStorage.setOrCreate('songList', DataModel.FOREST_BIRDS);
            } else if (item === AMBIENCE_ENUMS.White_noise) {
              AppStorage.setOrCreate('songList', DataModel.WHITE_NOISE);
            }
            this.ambienceVm.goToNextPage()
          })
          .width('90%')
          .margin({ bottom: 10 })
        }, (item: string, index: number) => item);
      }
      .visibility(this.showLoading ? Visibility.Hidden : Visibility.Visible)
      .scrollBar(BarState.Off)
      .zIndex(2)
      .margin({top: 6})
      .padding({top:8, bottom: 8})
      .height('100%')
      .width('100%')
    }
  }
}