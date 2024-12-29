package;

import displays.PlayerDisplay;
import displays.SeaDisplay;
import displays.UI;
import echo.Body;
import echo.Echo;
import echo.World;
import echo.math.Vector2;
import echo.util.BodyOrBodies;
import fishes.*;
import haxe.CallStack;
import haxe.Json;
import js.Browser;
import lime.app.Application;
import lime.ui.Joystick;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;
import lime.utils.AssetType;
import lime.utils.Assets;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Display;
import peote.view.PeoteView;
import peote.view.Program;
import sprites.Player;
import sprites.Sea;
import sprites.Waves;

using Lambda;

typedef Datas = {
	data:Array<Data>,
}

typedef Data = {
	score:Int,
	speed:Int,
	fishThreshold:Int,
	bg:String,
	newFish:{
		tile:Int, level:Int, gain:Int, distribution:Map<Int, Int>, color:String, damage:Int,
	},
	tile:Int,
	playerTex:String,
	playerLevel:Int
}


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
	var sea:Sea;
	var waves:Waves;
	var zoom = 1.0;
	var fishes:Fishes;
	var data:Array<Data>;
	var data2:Array<Data>;
	var loaded:Bool;
	var shoreLine:Float = 275;
	var peoteView:PeoteView;


	var unlockedFishes:Fishes;

	public function new() {
		super();
	}

	override function onWindowCreate():Void {
		switch (window.context.type) {
			case WEBGL, OPENGL, OPENGLES:
				try {
					preloader.onComplete.add(() -> {
						data = Json.parse(Assets.getText("assets/data.json")).data;
						data2 = Json.parse(Assets.getText("assets/data.json")).data;
						start(window);
						loaded = true;
					});
				} catch (_)
					trace(CallStack.toString(CallStack.exceptionStack()), _);
			default:
				throw("Sorry, only works with OpenGL");
		}
	}
	
	public function start(window:Window) {
		initEcho();

		peoteView = new PeoteView(window);
		peoteView.start();


		playerDisplay = new PlayerDisplay(0, 0, window.width, window.height, world);

		seaDisplay = new SeaDisplay(0, 0, window.width * 2, window.height, world, Color.WHITE);

		uiDisplay = new UI(window, 0, 0, window.width, window.height);

		playerDisplay.zoom = zoom;
		seaDisplay.zoom = zoom;

		var maxbound = new Sprite(seaDisplay.buffer, world, Color.BLACK, {
			x: 0,
			y: 180,
			kinematic: true,
			mass: 0,
			shape: {
				type: RECT,
				width: seaDisplay.width,
				height: 1,
			}
		});

		var uppermaxbound = new Sprite(seaDisplay.buffer, world, Color.BLACK, {
			x: 0,
			y: 100,
			kinematic: true,
			mass: 0,
			shape: {
				type: RECT,
				width: seaDisplay.width,
				height: 1,
			}
		});

		var left = new Sprite(seaDisplay.buffer, world, Color.BLACK, {
			x: 0,
			y: 0,
			kinematic: true,
			mass: 0,
			shape: {
				type: RECT,
				width: 1,
				height: window.height,
			}
		});

		var right = new Sprite(seaDisplay.buffer, world, Color.BLACK, {
			x: window.width,
			y: 0,
			kinematic: true,
			mass: 0,
			shape: {
				type: RECT,
				width: 1,
				height: window.height,
			}
		});

		var down = new Sprite(seaDisplay.buffer, world, Color.BLACK, {
			x: 0,
			y: window.height,
			kinematic: true,
			mass: 0,
			shape: {
				type: RECT,
				width: window.width,
				height: 1,
			}
		});

		peoteView.addDisplay(seaDisplay);
		peoteView.addDisplay(playerDisplay);
		peoteView.addDisplay(uiDisplay);


		player = playerDisplay.members.player;
		sea = seaDisplay.members.sea;
		fishes = seaDisplay.members.fishes;
		waves = seaDisplay.members.waves;
		var coins = seaDisplay.members.coins;

		var platforms = seaDisplay.members.platforms;


		world.listen(player.body, sea.body, {
			separate: false,
			enter: (a, b, c) -> {
				player.inAir = false;
				player.body.acceleration.y = 0;
				player.vy = player.vyi;
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
				a.material.gravity_scale = 1.0;
				player.color = Color.ORANGE;
				player.inAir = true;
				playerDisplay.update();
			}
		});

		world.listen(player.body, fishes.bodies, {
			separate: false,
			condition: (a, b, c) -> {
				var fishIndex = fishes.bodies.findIndex(x -> b == x);
				var fish = fishes.fishes[fishIndex];

				return !fish.isSecret;
			},
			enter: (a, b, c) -> {
				// trace(player.health);
				var fishIndex = fishes.bodies.findIndex(x -> b == x); 
				var fish = fishes.fishes[fishIndex]; 

				if (player.level >= fish.level) {
					player.score += 1;
					uiDisplay.updateScore(player.score, fish);
					fishes.fishes.remove(fish);
					fishes.bodies.remove(fish.body);
					fish.kill();
				} else {
					player.health -= fish.damage;
					uiDisplay.updateHealth(player.health);
				}
			},
		});
		
		world.listen(player.body, platforms.bodies, {
			separate: true,
			enter: (a, b, c) -> {
				player.onPlatform = true;
				player.reachedMax = false;
			},
			exit: (a, b) -> {
				player.onPlatform = false;
			}
		});

		world.listen(player.body, coins.bodies, {
			separate: false,
			enter: (a, b, c) -> {
				var coinIndex = coins.bodies.findIndex(x -> b == x);
				var coin = coins.sprts[coinIndex];

				coin.kill();
				player.score += 50;
				uiDisplay.updateScoreOnly(player.score);
			},
		});

		world.listen(player.body, maxbound.body, {
			separate: false,
			condition: (a, b, c) -> {
				return player.last_y >= shoreLine;
			},
			enter: (a, b, c) -> {
				trace("REACHED MAX");
				player.body.acceleration.y = 900;
				player.reachedMax = true;
			},
		});

		world.listen(player.body, uppermaxbound.body, {
			separate: false,
			condition: (a, b, c) -> {
				return player.last_y <= shoreLine;
			},
			enter: (a, b, c) -> {
				trace("REACHED MAX");
				player.body.acceleration.y = 900;
				player.reachedMax = true;
			},
		});

		world.listen(player.body, right.body, {
			separate: true,
		});

		world.listen(player.body, left.body, {
			separate: true,
		});

		world.listen(player.body, down.body, {
			separate: true,
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
		if (loaded) {
			world.step(dt / 1000);
			seaDisplay.update(player, world);
			playerDisplay.update();
			uiDisplay.updateIcon();
			uiDisplay.updateTitle(peoteView.time);

			if (player.inAir) {
				if (player.health < 100)
					player.health += 0.1;
				uiDisplay.updateHealth(player.health);
			} else {
				player.health -= 0.1;
				player.reachedMax = false;
				uiDisplay.updateHealth(player.health);
			}

			if (player.health < 0) {
				// dont look
				Browser.window.location.reload();
				loaded = false;
			}

			var i = 0;
			for (d in data) {
				if (player.score >= d.score) {
					seaDisplay.bg = d.bg;
					uiDisplay.newLevel("LEVEL 1");
					uiDisplay.startTime = peoteView.time;
					uiDisplay.endTime = uiDisplay.startTime + 5;
					fishes.speed = d.speed;
					seaDisplay.fishThreshold = d.fishThreshold;
					seaDisplay.tileNum = d.tile;
					player.level = d.playerLevel;
					fishes.unlockFish({
						tile: d.newFish.tile,
						level: d.newFish.level,
						gain: d.newFish.gain,
						damage: d.newFish.damage,
					});
					seaDisplay.curData = data2.slice(0, i + 1 + (data2.length - data.length));
					seaDisplay.redistribute();
					data.shift();
				}
				i++;
			}
		}
	}

	override function onKeyUp(keyCode:KeyCode, modifier:KeyModifier) {
		player.onKeyUp(keyCode, modifier);
	}

	override function onKeyDown(keyCode:KeyCode, modifier:KeyModifier) {
		player.onKeyDown(keyCode, modifier, shoreLine);
	}
}
