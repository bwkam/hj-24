package sprites;

import echo.World;
import echo.data.Options.BodyOptions;
import peote.view.Buffer;
import peote.view.Color;


typedef FishConfig = {
	tile:Int,
	level:Int,
	gain:Int,
	damage:Int,
	follow:Bool,
}

enum FishState {
	AGGRESSIVE;
	IDLE;
	ESCAPE;
}

enum Powerup {
	Health;
	Bomb;
	Gold;
	Magnet;
	None;
}

class Fish extends Sprite {
	public var level:Int = 1;
	public var tileNumber:Int;
	public var gain:Int;
	public var check:Bool = true;
	public var isSecret:Bool = false;
	public var damage:Int;
	public var state:FishState = IDLE;
	public var follow:Bool = false;
	public var powerup:Powerup = None;
	public var flight:Float = 0.0;


	override public function new(buffer:Buffer<Sprite>, world:World, color:Color, config:FishConfig, options:BodyOptions, ?secret:Bool = false) {
		super(buffer, world, color, options);
		this.buffer = buffer;
		this.level = config.level;
		this.tileNumber = config.tile;
		this.gain = config.gain;
		this.tile = config.tile;
		this.color = color;
		this.damage = config.damage;
		this.follow = config.follow;
		this.w = this.w * -1;
		if (secret != null) {
			isSecret = secret;
		}
	}

	public function update(dt:Float) {
		if (this.y <= 275) {
			trace("increasing flight time");
			flight += dt;
		}

		buffer.update();
	}
}