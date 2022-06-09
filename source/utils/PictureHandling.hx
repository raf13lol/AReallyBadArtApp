package utils;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import haxe.io.Bytes;
import openfl.display.BitmapData;
import openfl.display.JPEGEncoderOptions;
import openfl.display.PNGEncoderOptions;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

class PictureHandling
{
	/**
		Shouldn't be seen.
	**/
	static function _mouseInPicture(picture:FlxRect, mouseX:Int, mouseY:Int)
	{
		return picture.x <= mouseX // check if in box for x axis
			&& picture.x + picture.width >= mouseX // not outside on the right
			&& picture.y <= mouseY // repeat for y axis
			&& picture.y + picture.height >= mouseY;
		// sorry about this, didnt want to use vars as it would fill memory in -5 seconds
	}

	/**
		Simplifies setPixel32();
		@param pixelColor needs to be an ARGB value
		@param picture the picture to edit
	**/
	public static function setPixelColor(pixelColor:Int, picture:FlxSprite)
	{
		picture.graphic.bitmap.setPixel32(Std.int(FlxG.mouse.x + (0 - picture.x)), Std.int(FlxG.mouse.y + (0 - picture.y)), pixelColor);
	}

	/**
		turns a flxsprite to a flxrect
		@param picture the thing to convert
	**/
	public static function makePictureRect(picture:FlxSprite)
	{
		return new FlxRect(picture.x + (0 - picture.x), picture.y + (0 - picture.y), picture.frameWidth, picture.frameHeight);
	}

	/**
		simplifies the massive _mouseInPicture()
		@param picture the picture to check
	**/
	public static function mouseInPicture(picture:FlxSprite)
	{
		return _mouseInPicture(makePictureRect(picture), Std.int(FlxG.mouse.x + (0 - picture.x)), Std.int(FlxG.mouse.y + (0 - picture.y)));
	}

	/**
		credits to 47rooks from the haxe discord server
		@param bmd the bitmap data from sprite.graphic.bitmap
		@param filePath the file name (dont add .png)
	**/
	public static function writePNG(bmd:BitmapData, filePath:String):Void
	{
		var tsba = new ByteArray();
		bmd.encode(new Rectangle(0, 0, bmd.width, bmd.height), new PNGEncoderOptions(), tsba);
		sys.io.File.saveBytes(Sys.getCwd() + filePath + ".png", Bytes.ofData(tsba));
	}

	/**
		again,	credits to 47rooks from the haxe discord server, i did change 1 thing for jpeg
		@param bmd the bitmap data from sprite.graphic.bitmap
		@param filePath the file name (dont add .jpeg)
	**/
	public static function writeJPEG(bmd:BitmapData, filePath:String):Void
	{
		var tsba = new ByteArray();
		bmd.encode(new Rectangle(0, 0, bmd.width, bmd.height), new JPEGEncoderOptions(), tsba);
		sys.io.File.saveBytes(Sys.getCwd() + filePath + ".jpeg", Bytes.ofData(tsba));
	}
}
