package sprites;

import echo.World;
import echo.data.Options.BodyOptions;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Program;


class Fish extends Sprite {
	public var level:Int = 1;

	override public function new(buffer:Buffer<Sprite>, world:World, c:Color, _options:BodyOptions) {
		super(buffer, world, c, _options);
		this.buffer = buffer;
	}

	public function update(dt:Float) {
		buffer.update();
	}
}