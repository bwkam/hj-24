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

		data = '{"name":null,"assets":"aoy4:sizei16511y4:typey5:IMAGEy9:classNamey36:__ASSET__assets_backgrounddesert_pngy2:idy29:assets%2FbackgroundDesert.pnggoR0i119073R1R2R3y31:__ASSET__assets_spritesheet_pngR5y24:assets%2Fspritesheet.pnggoR0i17700R1R2R3y34:__ASSET__assets_colored_forest_pngR5y27:assets%2Fcolored_forest.pnggoR0i142187R1R2R3y28:__ASSET__assets_platform_pngR5y21:assets%2Fplatform.pnggoR0i18073R1R2R3y41:__ASSET__assets_backgroundcolordesert_pngR5y34:assets%2FbackgroundColorDesert.pnggoR0i910686R1R2R3y30:__ASSET__assets_fonts_kaph_pngR5y25:assets%2Ffonts%2Fkaph.pnggoR0i60984R1y6:BINARYR3y30:__ASSET__assets_fonts_kaph_datR5y25:assets%2Ffonts%2Fkaph.datgoR0i381R1y4:TEXTR3y33:__ASSET__assets_fonts_config_jsonR5y28:assets%2Ffonts%2Fconfig.jsongoR0i14738R1R2R3y37:__ASSET__assets_backgroundcastles_pngR5y30:assets%2FbackgroundCastles.pnggoR0i596R1R2R3y42:__ASSET__assets_bar_round_small_square_pngR5y35:assets%2Fbar_round_small_square.pnggoR0i444R1R2R3y37:__ASSET__assets_bar_round_small_r_pngR5y30:assets%2Fbar_round_small_r.pnggoR0i22809R1R2R3y40:__ASSET__assets_backgroundcolorgrass_pngR5y33:assets%2FbackgroundColorGrass.pnggoR0i21963R1R2R3y41:__ASSET__assets_backgroundcolorforest_pngR5y34:assets%2FbackgroundColorForest.pnggoR0i20205R1R2R3y36:__ASSET__assets_backgroundforest_pngR5y29:assets%2FbackgroundForest.pnggoR0i9444R1R2R3y35:__ASSET__assets_backgroundempty_pngR5y28:assets%2FbackgroundEmpty.pnggoR0i650R1R2R3y35:__ASSET__assets_bar_round_small_pngR5y28:assets%2Fbar_round_small.pnggoR0i20649R1R2R3y39:__ASSET__assets_backgroundcolorfall_pngR5y32:assets%2FbackgroundColorFall.pnggoR0i120R1R2R3y37:__ASSET__assets_bar_round_small_m_pngR5y30:assets%2Fbar_round_small_m.pnggoR0i23487R1R2R3y34:__ASSET__assets_colored_castle_pngR5y27:assets%2Fcolored_castle.pnggoR0i2848R1R20R3y25:__ASSET__assets_data_jsonR5y18:assets%2Fdata.jsongoR0i445R1R2R3y37:__ASSET__assets_bar_round_small_l_pngR5y30:assets%2Fbar_round_small_l.pnggh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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
@:keep @:file("bin/neko/obj/tmp/manifest/default.json") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else



#end

#if (openfl && !flash)

#if html5

#else

#end

#end
#end

#end