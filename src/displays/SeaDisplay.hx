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
import sprites.Player;
import sprites.Sea;
import sprites.Waves;
import utils.Loader;

using Lambda;
typedef SeaMembers = {
	sea:Sea,
	fishes: Fishes,
	waves:Waves,
	platforms:Platforms,
	coins:{sprts: Array<Sprite>, bodies: Array<Body>},
}


typedef Platform = {
	tiles: Array<Sprite>, 
	x: Float, 
	y: Float,
	body: Body,
}

typedef Platforms = {
	platforms: Array<Platform>,
	bodies: Array<Body>,
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
	public var islandsBuffer:Buffer<Sprite>;
	public var islandsProgram:Program;
	public var tileNum = 0;
	public var coins:{sprts: Array<Sprite>, bodies: Array<Body>} = {sprts: [], bodies: []};
	var bgElem:Background;
	var platformSpawnChance:Float = 0.1;
	var lastPlatform:Platform;
	var platformSpacing:Int = 50;
	var platforms:Platforms = {platforms: [], bodies: []};
	var world:World;
	public var triggerDistance = 200;
	public var escapeTimer:Float = 0;
	public var escapeDistance = 60;
	public var escapeDuration = 1.5;


	var seaBuffer:Buffer<Sea>;

    override public function new(x:Int, y:Int, width:Int, height:Int, world:World, color:Color = 0x00000000) {
		super(x, y, width, height, color);
		var frameSize = 64;

		this.world = world;

		this.buffer = new Buffer<Sprite>(1, 10, true);
        this.program = new Program(this.buffer);

		seaBuffer = new Buffer<Sea>(1, 1, true);
		var seaProgram = new Program(seaBuffer);

		wavesBuffer = new Buffer<Waves>(1, 1, true);
		wavesProgram = new Program(wavesBuffer);
		wavesProgram.blendEnabled = true;

		bgBuffer = new Buffer<Background>(1, 1, true);
		bgProgram = new Program(bgBuffer);

		islandsBuffer = new Buffer<Sprite>(1, 5, true);
		islandsProgram = new Program(islandsBuffer);

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
			y: world.height - 315,
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

		Loader.image("assets/platform.png", true, function(image:Image) {
			var texture = new Texture(image.width, image.height);
			texture.tilesX = Std.int(image.width / frameSize);
			texture.tilesY = Std.int(image.height / frameSize);
			// texture.smoothExpand = true;
			// texture.smoothShrink = true;
			texture.setData(image);

			islandsProgram.addTexture(texture, "custom");
			islandsProgram.snapToPixel(1);
			islandsProgram.blendEnabled = true;
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


		// islandsProgram.injectIntoVertexShader(" ", true);
		
		this.addProgram(this.bgProgram);
		this.addProgram(this.islandsProgram);
		this.addProgram(seaProgram);
		this.addProgram(this.wavesProgram);
		this.addProgram(this.program);


		this.members = {
			sea: sea,
			fishes: fishes, 
			waves: waves,
			platforms: platforms,
			coins: coins,
		}
    }

	public function createPlatform(x:Float, y:Float, w:Int, h:Int, withCoin:Bool):Platform {
		var tileScale = 30;

		var platform:Platform = {tiles: [], x: 0, y: 0, body: null};

		var dirt = tileNum; 
		var l = tileNum + 1;
		var m = tileNum + 2;
		var r = tileNum + 3;

		for (yTile in 0...h) {
			for (xTile in 0...w) {
				var tileN = 0;

				var tile = new Sprite(islandsBuffer, world, Color.WHITE, {
					x: (xTile*tileScale)+x,
					y: (yTile*tileScale)+y,
					kinematic: true,
					velocity_x: -50,
					mass: 10,
					shape: {
						type: RECT,
						width: tileScale,
						height: tileScale,
					},
				});

				if (xTile == 0 && yTile == 0) tileN = l; 
				else if (xTile == w - 1 && yTile == 0) tileN = r;
				else if (xTile < w - 1 && yTile == 0) tileN = m;
				else if (yTile > 0) tileN = dirt; 

				tile.tile = tileN;

				platform.tiles.push(tile);
				platforms.bodies.push(tile.body);
			}
		}

		platform.x = platform.tiles[0].x;
		platform.y = platform.tiles[0].y;
		platform.body = platform.tiles[0].body;


		platforms.platforms.push(platform);

		if (withCoin) {
			var randomTile = platform.tiles[Std.random(w)];
			var coin = new Sprite(islandsBuffer, world, Color.YELLOW, {
				x: randomTile.body.x, 
				y: randomTile.body.y - 80, 
				kinematic: true,
				velocity_x: randomTile.body.velocity.x, 
				mass: 10,
				shape: {
					type: CIRCLE, 
					width: 50, 
					height: 50
				}
			});

			coin.tile = 14;

			coins.sprts.push(coin);
			coins.bodies.push(coin.body);
		}

		return platform;
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
				c: Color.WHITE,
				w: 50,
				h: 50,
				x: () -> (Std.random(Std.int(width / 2)) + width / 2) - 50,
				y: () -> Std.random(Std.int(height / 2)) + height / 2,
			}, {
				level: fishData.newFish.level,
				gain: fishData.newFish.gain,
				tile: fishData.newFish.tile,
				follow: fishData.newFish.follow,
				damage: fishData.newFish.damage,
			}, Std.int(distrib));

			i++;
		}
	}

	public function update(player:Player, world:World, dt:Float) {
		var fishes = this.members.fishes;
		// if (fishes.fishes[0] != null) {
		// 	var f = fishes.fishes[0];
		// 	f.color = Color.BLUE;
		// 	// trace(player.x, fishes.fishes[0]?.x);

		// 	var dx = f.x - player.x;
		// 	var dy = f.y - player.y;
		// 	var d = Math.sqrt(dx * dx + dy * dy);

		// 	trace(d);
		// }

		for (f in fishes.fishes) {
			var dx = f.x - player.x;
			var dy = f.y - player.y;
			var d = Math.sqrt(dx * dx + dy * dy);

			if (f.follow) {
				switch (f.state) {
					case IDLE:
						if (d < triggerDistance) {
							f.state = AGGRESSIVE;
						}
					case AGGRESSIVE:
						if (d > triggerDistance) {
							f.state = IDLE;
						} else if (d < escapeDistance) {
							f.state = ESCAPE;
							escapeTimer = escapeDuration;
						} else {
							var angle = Math.atan2(dy, dx);
							f.body.velocity.x = -Math.cos(angle) * 300;
							f.body.velocity.y = -Math.sin(angle) * 300;
							f.angle = angle * (180 / std.Math.PI);
							f.update(dt);
						}
					case ESCAPE:
						if (escapeTimer > 0 && player.isMoving) {
							escapeTimer -= 1 / 60;
							var angle = Math.atan2(dy, dx);
							f.angle = 0;
							f.body.velocity.x = -500;
							f.body.velocity.y = 0;
							f.isSecret = true;
						} else {
							f.state = IDLE;
						}
				}
			}
		}

		if (player.x - (lastPlatform?.body.x ?? -platformSpacing) >= platformSpacing) {
			if (std.Math.random() < platformSpacing) {
				var num = Std.random(3) + 1;
				var platform:Platform = null;
				var xpos = Std.random(Std.int(this.width / 2)) + this.width / 2;
				var lucks = [for (i in 0...num) Std.random(2) == 1];


				for (i in 0...num) {
					platform = createPlatform(xpos, Std.int(this.height / 2) - 100, 5, 3, lucks[i]);
					
					platforms.platforms.push(platform);

					xpos += lib.Math.randomRange(150, 200);
				}
				

				lastPlatform = platform;

				// trace("PLAYER X: " + player.x);
				// trace("LAST X: " + lastPlatform.body.x);
			} else {
				lastPlatform = {y: 0, x: 0, tiles: [], body: world.make({x: player.x + platformSpacing, velocity_x: -50, kinematic: true, mass: 2})};
			}
		}

		if (curData.length > 0 && fishes.fishes.length < 0.4 * fishThreshold) {
			redistribute();
		}

		for (f in fishes.fishes) {
			f.update(dt);

			if (!this.isPointInside(Std.int(f.x), Std.int(f.y))) {
				fishes.fishes.remove(f);
				fishes.bodies.remove(f.body);
				f.kill();
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

    var OPTIONS = { texRepeatX: true, texRepeatY: true, blend: true };
}


