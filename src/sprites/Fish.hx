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
}

class Fish extends Sprite {
	public var level:Int = 1;
	public var tileNumber:Int;
	public var gain:Int;
	public var check:Bool = true;
	public var isSecret:Bool = false;
	public var damage:Int;

	override public function new(buffer:Buffer<Sprite>, world:World, color:Color, config:FishConfig, options:BodyOptions, ?secret:Bool = false) {
		super(buffer, world, color, options);
		this.buffer = buffer;
		this.level = config.level;
		this.tileNumber = config.tile;
		this.gain = config.gain;
		this.tile = config.tile;
		this.color = Color.WHITE;
		this.damage = config.damage;
		this.w = this.w * -1;
		if (secret != null)
			isSecret = secret;
	}

	public function update() {
		buffer.update();
	}
}