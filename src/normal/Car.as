package normal
{
	import flash.geom.Point;
	
	import org.flixel.FlxSprite;
	
	public class Car extends FlxSprite
	{
		public function Car(posX:int, posY:int, graphic:Class, velX:int, velY:int)
		{
			super(posX, posY, graphic);
			velocity.x = velX;
			velocity.y = velY;
		}
		
		public override function update() : void {
			super.update();
			
			if (velocity.x >0 && x <= 21) y = 17;
			else if (velocity.x >0 && x > 21) y = 18;
			else if (velocity.x < 0 && x <= 21) y = 16;
			else if (velocity.x < 0 && x > 21) y = 17;
			
			if (velocity.x > 0 && x > 50) kill();
			if (velocity.x < 0 && x < -3) kill();
		}
		
		public function get dx() : Number {
			return velocity.x;
		}
		
		public function get dy() : Number {
			return velocity.y;
		}
	}
}