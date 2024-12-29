package;

import haxe.io.Bytes;
import haxe.io.Path;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

#if disable_preloader_assets
@:dox(hide) class ManifestResources {
	public static var preloadLibraries:Array<Dynamic>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;

	public static function init (config:Dynamic):Void {
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
	}
}
#else
@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

			if(!StringTools.endsWith (rootPath, "/")) {

				rootPath += "/";

			}

		}

		if (rootPath == null) {

			#if (ios || tvos || webassembly)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif (console || sys)
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		
		#end

		var data, manifest, library, bundle;

		data = '{"name":null,"assets":"aoy4:pathy29:assets%2FbackgroundDesert.pngy4:sizei16511y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y24:assets%2Fspritesheet.pngR2i119073R3R4R5R7R6tgoR0y27:assets%2Fcolored_forest.pngR2i17700R3R4R5R8R6tgoR0y21:assets%2Fplatform.pngR2i142187R3R4R5R9R6tgoR0y34:assets%2FbackgroundColorDesert.pngR2i18073R3R4R5R10R6tgoR0y25:assets%2Ffonts%2Fkaph.pngR2i910686R3R4R5R11R6tgoR0y25:assets%2Ffonts%2Fkaph.datR2i60984R3y6:BINARYR5R12R6tgoR0y28:assets%2Ffonts%2Fconfig.jsonR2i381R3y4:TEXTR5R14R6tgoR0y30:assets%2FbackgroundCastles.pngR2i14738R3R4R5R16R6tgoR0y35:assets%2Fbar_round_small_square.pngR2i596R3R4R5R17R6tgoR0y30:assets%2Fbar_round_small_r.pngR2i444R3R4R5R18R6tgoR0y33:assets%2FbackgroundColorGrass.pngR2i22809R3R4R5R19R6tgoR0y34:assets%2FbackgroundColorForest.pngR2i21963R3R4R5R20R6tgoR0y29:assets%2FbackgroundForest.pngR2i20205R3R4R5R21R6tgoR0y28:assets%2FbackgroundEmpty.pngR2i9444R3R4R5R22R6tgoR0y28:assets%2Fbar_round_small.pngR2i650R3R4R5R23R6tgoR0y32:assets%2FbackgroundColorFall.pngR2i20649R3R4R5R24R6tgoR0y30:assets%2Fbar_round_small_m.pngR2i120R3R4R5R25R6tgoR0y27:assets%2Fcolored_castle.pngR2i23487R3R4R5R26R6tgoR0y18:assets%2Fdata.jsonR2i3018R3R15R5R27R6tgoR0y30:assets%2Fbar_round_small_l.pngR2i445R3R4R5R28R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

	}


}

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_backgrounddesert_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_spritesheet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_colored_forest_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_platform_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_backgroundcolordesert_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_kaph_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_kaph_dat extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_config_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_backgroundcastles_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_square_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_r_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_backgroundcolorgrass_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_backgroundcolorforest_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_backgroundforest_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_backgroundempty_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_backgroundcolorfall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_colored_castle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_l_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:image("assets/backgroundDesert.png") @:noCompletion #if display private #end class __ASSET__assets_backgrounddesert_png extends lime.graphics.Image {}
@:keep @:image("assets/spritesheet.png") @:noCompletion #if display private #end class __ASSET__assets_spritesheet_png extends lime.graphics.Image {}
@:keep @:image("assets/colored_forest.png") @:noCompletion #if display private #end class __ASSET__assets_colored_forest_png extends lime.graphics.Image {}
@:keep @:image("assets/platform.png") @:noCompletion #if display private #end class __ASSET__assets_platform_png extends lime.graphics.Image {}
@:keep @:image("assets/backgroundColorDesert.png") @:noCompletion #if display private #end class __ASSET__assets_backgroundcolordesert_png extends lime.graphics.Image {}
@:keep @:image("assets/fonts/kaph.png") @:noCompletion #if display private #end class __ASSET__assets_fonts_kaph_png extends lime.graphics.Image {}
@:keep @:file("assets/fonts/kaph.dat") @:noCompletion #if display private #end class __ASSET__assets_fonts_kaph_dat extends haxe.io.Bytes {}
@:keep @:file("assets/fonts/config.json") @:noCompletion #if display private #end class __ASSET__assets_fonts_config_json extends haxe.io.Bytes {}
@:keep @:image("assets/backgroundCastles.png") @:noCompletion #if display private #end class __ASSET__assets_backgroundcastles_png extends lime.graphics.Image {}
@:keep @:image("assets/bar_round_small_square.png") @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_square_png extends lime.graphics.Image {}
@:keep @:image("assets/bar_round_small_r.png") @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_r_png extends lime.graphics.Image {}
@:keep @:image("assets/backgroundColorGrass.png") @:noCompletion #if display private #end class __ASSET__assets_backgroundcolorgrass_png extends lime.graphics.Image {}
@:keep @:image("assets/backgroundColorForest.png") @:noCompletion #if display private #end class __ASSET__assets_backgroundcolorforest_png extends lime.graphics.Image {}
@:keep @:image("assets/backgroundForest.png") @:noCompletion #if display private #end class __ASSET__assets_backgroundforest_png extends lime.graphics.Image {}
@:keep @:image("assets/backgroundEmpty.png") @:noCompletion #if display private #end class __ASSET__assets_backgroundempty_png extends lime.graphics.Image {}
@:keep @:image("assets/bar_round_small.png") @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_png extends lime.graphics.Image {}
@:keep @:image("assets/backgroundColorFall.png") @:noCompletion #if display private #end class __ASSET__assets_backgroundcolorfall_png extends lime.graphics.Image {}
@:keep @:image("assets/bar_round_small_m.png") @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_m_png extends lime.graphics.Image {}
@:keep @:image("assets/colored_castle.png") @:noCompletion #if display private #end class __ASSET__assets_colored_castle_png extends lime.graphics.Image {}
@:keep @:file("assets/data.json") @:noCompletion #if display private #end class __ASSET__assets_data_json extends haxe.io.Bytes {}
@:keep @:image("assets/bar_round_small_l.png") @:noCompletion #if display private #end class __ASSET__assets_bar_round_small_l_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else



#end

#if (openfl && !flash)

#if html5

#else

#end

#end
#end

#end