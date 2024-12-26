package;

import displays.PlayerDisplay;
import displays.SeaDisplay;
import displays.UI;
import echo.Echo;
import echo.World;
import echo.math.Vector2;
import fishes.*;
import haxe.CallStack;
import lime.app.Application;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Display;
import peote.view.PeoteView;
import peote.view.Program;
import sprites.Player;

using Lambda;

class Main extends Application {
	var world:World;
	var entered:Bool;

	var playerDisplay:PlayerDisplay;
	var seaDisplay:SeaDisplay;
	var uiDisplay:UI;

	var triggered:Bool = false;
	var times:Int = 0;
	var spawnFactor:Float = 0.7;
	var player:Player;
	var sea:Sprite;
	var zoom = 1.0;
	var fishes:Fishes;

	// TODO: so for example AND BOOST AND HEALTH UI AND PERIODIC INCREASE IN SPEED
	// level 1 fish: 80 percent
	// level 2 fish: 10 percent
	var unlockedFishes:Fishes;

	public function new() {
		super();
	}

	override function onWindowCreate():Void {
		switch (window.context.type) {
			case WEBGL, OPENGL, OPENGLES:
				try {
					start(window);
				} catch (_)
					trace(CallStack.toString(CallStack.exceptionStack()), _);
			default:
				throw("Sorry, only works with OpenGL");
		}
	}
	
	public function start(window:Window) {
		initEcho();
		
		var peoteView = new PeoteView(window);
		
		playerDisplay = new PlayerDisplay(0, 0, window.width, window.height, world);
		seaDisplay = new SeaDisplay(0, 0, window.width, window.height, world, Color.WHITE);
		uiDisplay = new UI(0, 0, window.width, window.height);

		playerDisplay.zoom = zoom;
		seaDisplay.zoom = zoom;
		
		peoteView.addDisplay(seaDisplay);
		peoteView.addDisplay(playerDisplay);
		peoteView.addDisplay(uiDisplay);

		player = playerDisplay.members.player;
		sea = seaDisplay.members.sea;
		fishes = seaDisplay.members.fishes;

		world.listen(player.body, sea.body, {
			separate: false,
			enter: (a, b, c) -> {
				a.material.gravity_scale = 0;
				player.color = Color.RED;
				// a.velocity.x = player.vx;
				playerDisplay.update();
				player.entered = true;
			},
			stay: (a, b, c) -> {
				if (a.velocity.y > 0 && player.entered) {
					if (player.isMovingUp || player.isMovingDown)
						return;

					a.velocity = a.velocity.lerp(new Vector2(a.velocity.x, 0), 0.04);
					if (a.velocity.y < 1.0) {
						a.velocity.y = 0;
						trace("fully entered");
						player.entered = false;
					}
				}
			},
			exit: (a, b) -> {
				trace("stopped colliding");
				a.material.gravity_scale = 1.0;
				player.color = Color.ORANGE;
				playerDisplay.update();
			}
		});

		world.listen(player.body, fishes.bodies, {
			separate: false,
			enter: (a, b, c) -> {
				var fishIndex = fishes.bodies.findIndex(x -> b == x); 
				var fish = fishes.fishes[fishIndex]; 
			
				if (player.level > fish.level) {
					player.score += fish.level * 2;
					uiDisplay.updateScore(player.score);
					fish.kill();
				}
			},
		});
		
	}

	function initEcho() {
		world = Echo.start({
			width: window.width,
			height: window.height,
			gravity_y: 200,
			iterations: 2,
		});
	}


	override function update(dt:Float) {
		world.step(dt / 1000);
		seaDisplay.update();

		// keep from top to bottom (great to least)
		if (player.score > 10) fishes.speed = 400*2;
		if (player.score > 5) fishes.speed = 400;
	}

	override function onKeyUp(keyCode:KeyCode, modifier:KeyModifier) {
		player.onKeyUp(keyCode, modifier);
	}

	override function onKeyDown(keyCode:KeyCode, modifier:KeyModifier) {
		player.onKeyDown(keyCode, modifier);
	}
}
