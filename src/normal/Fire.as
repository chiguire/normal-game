package normal
{
	import org.flixel.FlxSprite;

	public class Fire extends FlxSprite
	{
		[Embed('img/fire.png')]	private var fireImage : Class;
		
		public function Fire(X:int=0, Y:int=0)
		{
			super(X, Y);
			
			loadGraphic(fireImage, true, false, 3, 3);
			addAnimation("fire", [0, 1, 2], 20);
		}
		
		public override function update():void {
			super.update();
			
			play("fire");
		}
		
	}
}