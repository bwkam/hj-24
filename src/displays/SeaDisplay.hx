package displays;

import Main.Data;
import echo.World;
import lime.graphics.Image;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Display;
import peote.view.Program;
import peote.view.Texture;
import sprites.Sea;
import sprites.Waves;
import utils.Loader;

using Lambda;

typedef SeaMembers = {
	sea:Sea,
	fishes: Fishes,
}

class SeaDisplay extends Display {
	public var buffer:Buffer<Sprite>;
    var program:Program;
	var wavesProgram:Program;
	public var members:SeaMembers;
	public var fishThreshold:Int = 100;
	public var curData:Array<Data> = [];
	public var refill:Bool = false;
	public var isReady:Bool = false;
	public var wavesBuffer:Buffer<Waves>;

	var seaBuffer:Buffer<Sea>;

    override public function new(x:Int, y:Int, width:Int, height:Int, world:World, color:Color = 0x00000000) {
		super(x, y, width, height, color);
		var frameSize = 64;

		this.buffer = new Buffer<Sprite>(1, 10, true);
        this.program = new Program(this.buffer);

		seaBuffer = new Buffer<Sea>(1, 1, true);
		var seaProgram = new Program(seaBuffer);

		wavesBuffer = new Buffer<Waves>(1, 1, true);
		wavesProgram = new Program(wavesBuffer);

		var sea = new Sea(seaBuffer, world, Color.WHITE, {
			x: 0,
			y: world.height / 2,
			mass: 0,
			kinematic: true,
			shape: {
				type: RECT,
				width: world.width,
				height: world.height / 2,
			},
		});

		var waves = new Waves(wavesBuffer, world, Color.WHITE, {
			x: 0,
			y: world.height - 340,
			mass: 0,
			kinematic: true,
			shape: {
				type: RECT,
				width: world.width,
				height: 15,
			},
		});

        var fishes = new Fishes(this, world, this.buffer, this.program);

		Loader.image("assets/spritesheet.png", true, function(image:Image) {
			var texture = new Texture(image.width, image.height);
			texture.tilesX = Std.int(image.width / frameSize);
			texture.tilesY = Std.int(image.height / frameSize);
			texture.smoothExpand = true;
			texture.smoothShrink = true;
			texture.setData(image);

			program.addTexture(texture, "custom");
			program.snapToPixel(1);

			seaProgram.addTexture(texture, "custom");
			seaProgram.snapToPixel(1);

			wavesProgram.addTexture(texture, "custom");
			wavesProgram.snapToPixel(1);

			isReady = true;
		});

		this.addProgram(seaProgram);
        this.addProgram(this.program);
		this.addProgram(this.wavesProgram);

		this.members = {
			sea: sea,
			fishes: fishes, 
		}
    }

	public function updateElement(e:Sprite) {
		this.buffer.updateElement(e);
	}

	public function redistribute() {
		var highestFish = this.members.fishes.activeFishes[this.members.fishes.activeFishes.length - 1];
		var distributions = lib.Math.distribute(curData[curData.length - 1].fishThreshold, highestFish.level, 0.2);
		trace(highestFish, distributions);
		var i = 0;

		for (level => distrib in distributions) {
			var fishData = curData[i];

			this.members.fishes.repeat({
				c: 0x00000000,
				w: 50,
				h: 50,
				x: () -> (Std.random(Std.int(width / 2)) + width / 2) - 50,
				y: () -> Std.random(Std.int(height / 2)) + height / 2,
			}, {
				level: fishData.newFish.level,
				gain: fishData.newFish.gain,
				tile: fishData.newFish.tile,
			}, Std.int(distrib));

			i++;
		}
	}

	public function update() {
		var fishes = this.members.fishes;

		for (f in fishes.fishes) {
			f.update();
			if (!this.isPointInside(Std.int(f.x), Std.int(f.y))) {
				fishes.fishes.remove(f);
				fishes.bodies.remove(f.body);
				f.kill();
			}
			if (f.x < (this.width / 2) * 0.1 && f.check) {
				trace("should more");
				fishes.fishes.filter(f -> f.check).iter(f -> f.check = false);
				redistribute();
			}
		}

		if (isReady) {
			this.seaBuffer.update();
			this.buffer.update();
			this.wavesBuffer.update();
		}
    }
}