package displays;

import lime.graphics.Image;
import lime.ui.Window;
import peote.ui.PeoteUIDisplay;
import peote.ui.interactive.Interactive;
import peote.ui.interactive.UIElement;
import peote.ui.style.RoundBorderStyle;
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

class UI extends PeoteUIDisplay {
    var scoreScale:Int = 30;
    var text:Text;
    var textProgram:TextProgram;
	var frameSize = 64.0;
	var fishProgram:Program;
	var isReady:Bool = false;
	var fishBuffer:Buffer<FishIcon>;
	var icons:Array<FishIcon> = [];
	var fish:FishIcon;
	var window:Window;
	var maxHealthWidth:Int = 500;
	var healthBar:UIElement;
	var roundBorderStyle:RoundBorderStyle;

    override public function new(window:Window, x:Int, y:Int, width:Int, height:Int, color:Color=0x00000000, maxTouchpoints:Int = 3, availableStyles:Array<StyleID> = null, autoAddStyles:Null<Bool> = null) {
        super(x, y, width, height, color, maxTouchpoints, availableStyles, autoAddStyles);
		this.window = window;

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

	public function updateHealth(x:Int) {
		trace(x);
		var newStyle = roundBorderStyle.copy();

		if (x < 70) {
			newStyle.color = Color.ORANGE;
		} else if (x < 20) {
			newStyle.color = Color.RED;
		}

		healthBar.style = newStyle; 
		healthBar.width = Std.int((x/100) * maxHealthWidth);
		healthBar.update();
		healthBar.updateStyle();
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

