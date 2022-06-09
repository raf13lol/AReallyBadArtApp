package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import sys.FileSystem;
import utils.PictureHandling as PH;

class PlayState extends FlxState
{
	var picture:FlxSprite;

	override public function create()
	{
		FileSystem.createDirectory(Sys.getCwd() + "masterpieces/");
		FlxG.mouse.visible = true;
		picture = new FlxSprite(100, 100).makeGraphic(200, 100);
		add(picture);
		FlxG.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, keyPress);
		super.create();
	}

	public function keyPress(e:openfl.events.KeyboardEvent)
	{
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S)
		{
			PH.writePNG(picture.graphic.bitmap, "masterpieces/" + FlxG.random.getObject(["picture", "nice", "art", "ok", "okay", "AAAAAAA"]));
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.pressed && FlxG.mouse.justMoved && PH.mouseInPicture(picture))
		{
			if (FlxG.keys.pressed.E)
				PH.setPixelColor(0xffffffff, picture);
			else
				PH.setPixelColor(0xff000000, picture);
		}

		super.update(elapsed);
	}
}
