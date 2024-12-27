package displays;

import Main.Data;
import echo.Body;
import echo.World;
import echo.World;
import echo.data.Options.BodyOptions;
import lime.graphics.Image;
import peote.view.Buffer;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Color;
import peote.view.Display;
import peote.view.Element;
import peote.view.Program;
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
	var bgBuffer:Buffer<Background>;
	var bgProgram:Program;
	public var members:SeaMembers;
	public var fishThreshold:Int = 100;
	public var curData:Array<Data> = [];
	public var refill:Bool = false;
	public var isReady:Bool = false;
	public var wavesBuffer:Buffer<Waves>;
	public var bg(default, set):String = "";
	var bgElem:Background;
	

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
		wavesProgram.blendEnabled = true;

		bgBuffer = new Buffer<Background>(1, 1, true);
		bgProgram = new Program(bgBuffer);


		bgProgram.injectIntoVertexShader(" ", true);


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
			program.blendEnabled = true;

			seaProgram.addTexture(texture, "custom");
			seaProgram.snapToPixel(1);

			wavesProgram.addTexture(texture, "custom");
			wavesProgram.snapToPixel(1);

		});

		// bgProgram.injectIntoFragmentShader("
		// 	float normpdf(in float x, in float sigma) { return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma; }
		
		// 	vec4 blur( int textureID )
		// 	{
		// 		const int mSize = 11;
				
		// 		const int kSize = (mSize-1)/2;
		// 		float kernel[mSize];
		// 		float sigma = 7.0;
				
		// 		float Z = 0.0;
				
		// 		for (int j = 0; j <= kSize; ++j) kernel[kSize+j] = kernel[kSize-j] = normpdf(float(j), sigma);
		// 		for (int j = 0; j <  mSize; ++j) Z += kernel[j];
				
		// 		vec3 final_colour = vec3(0.0);
				
		// 		//vec2 texRes = getTextureResolution(textureID);
		// 		//for (int i = -kSize; i <= kSize; ++i)
		// 		//{
		// 			//for (int j = -kSize; j <= kSize; ++j)
		// 			//{
		// 				//final_colour += kernel[kSize+j] * kernel[kSize+i] *
		// 					//getTextureColor( textureID, vTexCoord + vec2(float(i), float(j)) / texRes ).rgb;
		// 			//}
		// 		//}
				
		// 		// fix if kernel-offset is over the border
		// 		vec2 texRes = getTextureResolution(textureID);
		// 		vec2 texResSize = texRes + vec2(float(kSize+kSize),float(kSize+kSize));			
		// 		for (int i = 0; i <= kSize+kSize; ++i)
		// 		{
		// 			for (int j = 0; j <= kSize+kSize; ++j)
		// 			{
		// 				final_colour += kernel[j] * kernel[i] *
		// 					getTextureColor( textureID, (vTexCoord*texRes + vec2(float(i),float(j))) / texResSize ).rgb;
		// 			}
		// 		}
				
		// 		return vec4(final_colour / (Z * Z), 1.0);
		// 	}	
		// ");
		// program.setColorFormula("blur(custom_ID)");

		bgElem = new Background();
		bgElem.x = 0; 
		bgElem.y = (height / 2) - 100;
		bgElem.w = width; 
		bgElem.h = 500;
		bgElem.color = Color.WHITE;

		bgBuffer.addElement(bgElem);
		
		this.addProgram(this.bgProgram);
		this.addProgram(seaProgram);
        this.addProgram(this.program);
		this.addProgram(this.wavesProgram);


		this.members = {
			sea: sea,
			fishes: fishes, 
		}
    }

	public function set_bg(newBg:String) {

		Loader.image('assets/${newBg}', true, function(image:Image) {
			var texture = new Texture(image.width, image.height);

			texture.smoothExpand = true;
			texture.smoothShrink = true;
			texture.setData(image);

			bgProgram.removeAllTexture();

			bgProgram.addTexture(texture, "custom");
			bgProgram.setTexture(texture, "custom", true);

			bgProgram.snapToPixel(1);
			bgProgram.blendEnabled = true;
  
			this.bgProgram.updateTextures();
			this.bgBuffer.update();
			isReady = true;
		});


		return this.bg = newBg;
	}

	public function updateElement(e:Sprite) {
		this.buffer.updateElement(e);
	}

	public function redistribute() {
		var highestFish = this.members.fishes.activeFishes[this.members.fishes.activeFishes.length - 1];
		var distributions = lib.Math.distribute(curData[curData.length - 1].fishThreshold, highestFish.level, 0.2);
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
				damage: fishData.newFish.damage,
			}, Std.int(distrib));

			i++;
		}
	}

	public function update() {
		var fishes = this.members.fishes;
		// if (fishes.fishes.length > 0) redistribute();

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

class Background implements Element {
	@posX @varying @set("Position") public var x:Float = 0.0;
	@posY @varying @set("Position") public var y:Float = 0.0;

	@sizeX public var w:Float = 0.0;
	@sizeY public var h:Float;

	@color public var color:Color = 0x000000ff;

	@pivotX @const @formula("w * 0.5") public var pivotX:Float = 0.0;
	@pivotY @const @formula("h * 0.5") public var pivotY:Float = 0.0;

    @texSizeX @const @formula("1024.0/(w/512.0)") public var twOffset:Int;
	@texPosX @varying @formula("uTime * -20.0") public var txOffset:Int;

    var OPTIONS = { texRepeatX:true, texRepeatY:true, blend:true };
}
