package sprites;

import echo.World;
import echo.data.Options.BodyOptions;
import peote.view.Buffer;
import peote.view.Color;


typedef FishConfig = {
	tile:Int,
	level:Int,
	gain:Int,
}

class Fish extends Sprite {
	public var level:Int = 1;
	public var tileNumber:Int;
	public var gain:Int;
	public var check:Bool = true;

	override public function new(buffer:Buffer<Sprite>, world:World, color:Color, config:FishConfig, options:BodyOptions) {
		super(buffer, world, color, options);
		this.buffer = buffer;
		this.level = config.level;
		this.tileNumber = config.tile;
		this.gain = config.gain;
		this.tile = config.tile;
		this.color = Color.WHITE;
		this.w = this.w * -1;
	}

	public function update() {
		buffer.update();
	}
}