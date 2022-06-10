package;

import flixel.FlxGame;
import flixel.util.FlxColor;
import lime.app.Application;
import openfl.display.FPS;
import openfl.display.Sprite;
import states.SplashScreenState;
#if n
import utils.Discord;
#end

class Main extends Sprite
{
	var fpsCounter:FPS;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, SplashScreenState, 1, 500, 500, true));
		fpsCounter = new FPS(10, 3);
		addChild(fpsCounter);
	}

	public function tFPS(v:Bool):Void
	{
		fpsCounter.visible = v;
	}

	public function cFPSC(c:FlxColor)
	{
		fpsCounter.textColor = c;
	}
}
