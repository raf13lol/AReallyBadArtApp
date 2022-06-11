package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import sys.FileSystem;
import utils.PictureHandling as PH;

class PlayState extends FlxState
{
	var picture:FlxSprite;
	var fileName = FlxG.random.getObject(["picture", "nice", "art", "ok", "okay", "AAAAAAA"]);
	var undoHistory:Array<Dynamic> = []; // for undoing
	var localUndoHistory:Array<Dynamic> = []; // to push to undoHistory
	var maxUndoHistorySize = 50;

	override public function create()
	{
		FileSystem.createDirectory(Sys.getCwd() + "assets/artpieces/");
		FlxG.mouse.visible = true;
		bgColor = 0xffffaaaa;
		picture = new FlxSprite(100, 100).makeGraphic(200, 100);
		picture.screenCenter();
		add(picture);
		FlxG.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, keyPress);
		super.create();
	}

	public function keyPress(e:openfl.events.KeyboardEvent)
	{
		if (FlxG.keys.pressed.CONTROL)
		{
			if (FlxG.keys.justPressed.S)
				PH.writePNG(picture.graphic.bitmap, "assets/artpieces/" + fileName);
			else if (FlxG.keys.justPressed.Z && undoHistory.length > 0)
			{
				var toUndo = undoHistory.pop();
				for (i in 0...toUndo.length)
				{
					picture.graphic.bitmap.setPixel32(toUndo[i][0], toUndo[i][1], toUndo[i][2]);
				}
			}
		}
		if (FlxG.keys.justPressed.R && PH.pictureExists("assets/artpieces/" + fileName))
		{
			picture.graphic.bitmap = PH.getBitmapData("assets/artpieces/" + fileName);
		}
	}

	var lastMousePos:FlxPoint = new FlxPoint(0, 0);

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed)
			localUndoHistory = [];
		if (FlxG.mouse.pressed && PH.mouseInPicture(picture) && (localUndoHistory.length == 0 || FlxG.mouse.justMoved))
		{
			if ((FlxG.keys.pressed.E && PH.getPixelColor(picture) == -1)
				|| (!FlxG.keys.pressed.E && PH.getPixelColor(picture) == 0xff000000))
				return;
			localUndoHistory.push([
				Std.int(FlxG.mouse.x + (0 - picture.x)),
				Std.int(FlxG.mouse.y + (0 - picture.y)),
				PH.getPixelColor(picture)
			]);
			if (localUndoHistory.length > 1)
				PH.fillGaps(picture, localUndoHistory[localUndoHistory.length - 2][0], localUndoHistory[localUndoHistory.length - 1][0],
					localUndoHistory[localUndoHistory.length - 2][1], localUndoHistory[localUndoHistory.length - 1][1], 0xff000000);
			if (FlxG.keys.pressed.E)
				PH.setPixelColor(0xffffffff, picture);
			else
				PH.setPixelColor(0xff000000, picture);
		}

		if (FlxG.mouse.justReleased && localUndoHistory.length > 0)
		{
			if (undoHistory.length > maxUndoHistorySize)
				undoHistory.shift();
			undoHistory.push(localUndoHistory);
		}
		if (FlxG.mouse.justPressedMiddle)
			lastMousePos.set(FlxG.mouse.x, FlxG.mouse.y);
		if (FlxG.mouse.pressedMiddle)
		{
			picture.x += FlxG.mouse.x - lastMousePos.x;
			picture.y += FlxG.mouse.y - lastMousePos.y;
			lastMousePos.set(FlxG.mouse.x, FlxG.mouse.y);
		}
		if (FlxG.mouse.wheel != 0)
			FlxG.camera.zoom += (FlxG.mouse.wheel / (FlxG.keys.pressed.SHIFT ? 5 : 12.5)) * FlxG.camera.zoom;
	}
}
