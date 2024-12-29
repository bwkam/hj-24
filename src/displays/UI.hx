package displays;

import lime.graphics.Image;
import lime.ui.Window;
import peote.text.Font;
import peote.ui.PeoteUIDisplay;
import peote.ui.interactive.Interactive;
import peote.ui.interactive.UIElement;
import peote.ui.interactive.UITextLine;
import peote.ui.style.RoundBorderStyle;
import peote.ui.style.interfaces.FontStyle;
import peote.ui.style.interfaces.StyleID;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Element;
import peote.view.Program;
import peote.view.Texture;
import peote.view.element.Elem;
import peote.view.text.Text;
import peote.view.text.TextProgram;
import sprites.Fish;
import utils.Loader;

using tweenxcore.Tools;

@packed // this is need for ttfcompile fonts (gl3font)
@globalLineSpace // all pageLines using the same page.lineSpace (gap to next line into page)
@:structInit
class MyFontStyle implements FontStyle
{
	public var color:Color = Color.GREEN;
	//public var color:Color = Color.GREEN.setAlpha(0.5);
	public var width:Float = 80; // (<- is it still fixed to get from font-defaults if this is MISSING ?)
	public var height:Float = 80;
	@global public var weight = 0.5; //0.49 <- more thick (only for ttfcompiled fonts)
}

class UI extends PeoteUIDisplay {
    var scoreScale:Int = 30;
    var text:Text;
    var textProgram:TextProgram;
	var frameSize = 64.0;
	var fishProgram:Program;
	var fishBuffer:Buffer<FishIcon>;
	var icons:Array<FishIcon> = [];
	var fish:FishIcon;
	var window:Window;
	var maxHealthWidth:Int = 500;
	var healthBar:UIElement;
	public var isReady:Bool = false;
	var roundBorderStyle:RoundBorderStyle;
	var finishedSliding:Bool = false;
	var curTitle:UITextLine<MyFontStyle>;
	public var startTime:Float = 0.0; 
	public var endTime:Float = 0.0;
	public var font:Font<MyFontStyle>;
	public var fs:MyFontStyle;

	public static var TOTAL_FRAME:Int = 180;

    override public function new(window:Window, x:Int, y:Int, width:Int, height:Int, color:Color=0x00000000, maxTouchpoints:Int = 3, availableStyles:Array<StyleID> = null, autoAddStyles:Null<Bool> = null) {
        super(x, y, width, height, color, maxTouchpoints, availableStyles, autoAddStyles);
		this.window = window;

		new Font<MyFontStyle>("assets/fonts/config.json").load(onReady);
    }

	public function onReady(_font:Font<MyFontStyle>) {
		isReady = true;
		font = _font;
		fs = new MyFontStyle();
		// var bs = new BoxStyle


		fishBuffer = new Buffer<FishIcon>(1, 1, true);

		fishProgram = new Program(fishBuffer);
		fishProgram.blendEnabled = true;


		Loader.image("assets/spritesheet.png", true, function(image:Image) {
			var texture = new Texture(image.width, image.height);
			texture.tilesX = Std.int(image.width / frameSize);
			texture.tilesY = Std.int(image.height / frameSize);
			texture.smoothExpand = true;
			texture.smoothShrink = true;
			texture.setData(image);

			fishProgram.addTexture(texture, "custom");
			fishProgram.snapToPixel(1);

			isReady = true;
		});


        textProgram = new TextProgram();
        
		text = new Text(0, 10, '0', {letterWidth: scoreScale, letterHeight: scoreScale});
		text.x = this.width - (text.text.length * scoreScale) - 40 - 10; 
        text.fgColor = Color.BLACK;
        
        textProgram.add(text);

		fish = new FishIcon();
		fish.x = width - 20;

		fishBuffer.addElement(fish);

		// HEALTH BAR
		roundBorderStyle = new RoundBorderStyle(Color.GREEN, Color.WHITE, 2.0, 10.0);

		var style = roundBorderStyle.copy();
		healthBar = new UIElement(20, 10, maxHealthWidth, 30, style);

		this.add(healthBar);

		PeoteUIDisplay.registerEvents(window);
		//

        this.addProgram(textProgram);
		this.addProgram(fishProgram);
	}

	public function updateScore(x:Int, f:Fish) {
		var icon = new FishIcon();
		icon.tile = f.tile;

		icon.x = f.x;
		icon.y = f.y;

		fishBuffer.addElement(icon);

		icons.push(icon);

		text.text = '${x}';
		text.x = this.width - (text.text.length * text.letterWidth) - 40 - 10;

        textProgram.update(text, true);
	}

	public function updateScoreOnly(x:Int) {
		text.text = '${x}';
		text.x = this.width - (text.text.length * text.letterWidth) - 40 - 10;

		textProgram.update(text, true);
	}

	public function newLevel(name:String) {
		if (isReady) {
			// curTitle = new Text(0, Std.int((this.height - 100) / 2), name, {letterWidth: 100, letterHeight: 100});
			curTitle = font.createUITextLine(0, Std.int(this.height / 2), Std.int(this.width / 2), Std.int(this.height / 2), name, fs);
			this.add(curTitle);
		}

	}

	public function updateTitle(time:Float) {
		var rate:Float = 0;
		
		if (curTitle != null && endTime != 0 && time >= endTime) {
			// uiDisplay.remove
			this.remove(curTitle);
			curTitle = null;
		}

		else if (curTitle != null && curTitle.x <= (this.width/2)) {
			// trace("lerping");
			var scale = curTitle.width;
			if (time > startTime && time < endTime ) {
				rate = (time-startTime) / (endTime);
				// trace(rate);
				curTitle.x = Math.round(rate.cubicOut().lerp(-scale, ((this.width / 2) + 50)));
				curTitle.y = Std.int(this.height / 2);
			}
			curTitle.update();
			curTitle.updateStyle();
		}
	}

	public function updateHealth(x:Float) {
		if (isReady) {
			var newStyle = roundBorderStyle.copy();
	
			if (x < 20) {
				newStyle.color = Color.RED;
			} else if (x < 70) {
				newStyle.color = Color.ORANGE;
			} else {
				newStyle.color = Color.GREEN;
			}
	
			healthBar.style = newStyle; 
			healthBar.width = Std.int((x/100) * maxHealthWidth);
			healthBar.update();
			healthBar.updateStyle();
		}
	}

	public function updateIcon() {
		for (i in icons) {
			i.update(fishBuffer, fish, icons);
		}
	}
}

class FishIcon implements Element {
	@posX @varying @set("Position") public var x:Float = 0.0;
	@posY @varying @set("Position") public var y:Float = 22.0;

	@sizeX public var w:Float = 40.0;
	@sizeY public var h:Float = 40.0;

	@color public var color:Color = 0x000000ff;

	@pivotX @const @formula("w * 0.5") public var pivotX:Float = 0.0;
	@pivotY @const @formula("h * 0.5") public var pivotY:Float = 0.0;

	@rotation var angle:Float = 0.0;

	@texTile() public var tile:Int = 72;

	public function update(buffer:Buffer<FishIcon>, fish:FishIcon, icons:Array<FishIcon>) {
		if (Math.abs(this.x - fish.x) > 0.1 || Math.abs(this.y - fish.y) > 0.1) {
			this.x = lib.Math.lerp(this.x, fish.x, 0.3);
			this.y = lib.Math.lerp(this.y, fish.y, 0.3);
		} else {
			buffer.removeElement(this);
			icons.remove(this);
		}

		buffer.update();
	}
}


