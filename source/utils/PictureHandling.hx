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
import sys.FileSystem;

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
	}

	/**
		MAJOR THANKS TO https://twitter.com/Geokureli WITH THIS OMG 
		@param picture the picture also not explaining everything else
	**/
	public static function fillGaps(picture:FlxSprite, x1:Int, x2:Int, y1:Int, y2:Int, pixelColor:Int)
	{
		if (!_checkForGaps([[x1, y1], [x2, y2]]))
			return;
		if (x2 < x1)
		{
			// swap start and end so were always going left to right
			var temp = x2;
			x2 = x1;
			x1 = temp;
			temp = y2;
			y2 = y1;
			y1 = temp;
		}
		if (x1 == x2) // straight up and down
		{
			if (y2 < y1)
			{
				// swap start and end so we always go from up to down
				var y = y2;
				y2 = y1;
				y1 = y;
			}
			// from top to bottom
			for (y in y1...y2 + 1)
			{
				picture.graphic.bitmap.setPixel32(x1, y, pixelColor);
			}
		}
		else
		{
			var dx = x2 - x1;
			var dy = y2 - y1;
			// from left to right
			for (x in x1...x2 + 1)
			{
				// use slope formula to calculate y from x
				var y = Std.int(y1 + dy * (x - x1) / dx);
				picture.graphic.bitmap.setPixel32(x, y, pixelColor);
			}
		}
	}

	/**
		checks for gaps for the line thing like to close it
		@param theWholeArray pass localUndoHistory
	**/
	static function _checkForGaps(theWholeArray:Array<Dynamic>)
	{
		if (theWholeArray.length < 2)
			return false;

		return (Math.abs(theWholeArray[theWholeArray.length - 1][0] - theWholeArray[theWholeArray.length - 2][0]) > 1)
			|| (Math.abs(theWholeArray[theWholeArray.length - 1][1] - theWholeArray[theWholeArray.length - 2][1]) > 1);
	}

	/**
		checks both png and jpeg
		@param filePath can be relative or full
	**/
	public static function pictureExists(filePath:String)
	{
		return FileSystem.exists(filePath + ".png") || FileSystem.exists(filePath + ".jpeg");
	}

	/**
		tries to get png or jpeg
		@param filePath can be relative or full
	**/
	public static function getBitmapData(filePath:String)
	{
		var bitmap = BitmapData.fromFile(filePath + ".png");
		if (bitmap == null)
			bitmap = BitmapData.fromFile(filePath + ".jpeg");
		return bitmap;
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
		simplifies getPixel32()
		@param picture the picture the pixel is in
	**/
	public static function getPixelColor(picture:FlxSprite)
	{
		return picture.graphic.bitmap.getPixel32(Std.int(FlxG.mouse.x + (0 - picture.x)), Std.int(FlxG.mouse.y + (0 - picture.y)));
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
		@param quality between 1 and 100
	**/
	public static function writeJPEG(bmd:BitmapData, filePath:String, quality:Int = 100):Void
	{
		var tsba = new ByteArray();
		bmd.encode(new Rectangle(0, 0, bmd.width, bmd.height), new JPEGEncoderOptions(quality), tsba);
		sys.io.File.saveBytes(Sys.getCwd() + filePath + ".jpeg", Bytes.ofData(tsba));
	}
}
