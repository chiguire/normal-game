package normal
{
	import org.flixel.FlxSprite;
	
	public class Riot extends FlxSprite
	{
		[Embed('img/person-1.png')]	private var person1Image : Class;
		[Embed('img/person-2.png')]	private var person2Image : Class;
		[Embed('img/person-3.png')]	private var person3Image : Class;
		[Embed('img/person-4.png')]	private var person4Image : Class;
		
		public static const MAX_PERSONS : int = 4;
		public static const STARTING_LIFE : int = 800;
		
		public var aggresiveness : int;
		
		public var state : GameState;
		
		public var life : int;
		
		public function Riot(x:Number, y:Number, personColor:int, aggresiveness : int)
		{
			super(x, y);
			
			this.aggresiveness = aggresiveness;
			
			if (aggresiveness == -1) {
				this.kill();
				this.visible = false;
				trace("This person killed himself.");
				life = -1;
			} else {
				
				if (aggresiveness == 0) {
					life = STARTING_LIFE;
				} else {
					life = -1;
				}
				
				trace("Person aggresiveness: "+aggresiveness);
				var n : int = Math.ceil(Math.random()*4);
				loadGraphic(this["person"+n+"Image"], true, false, 3, 3);
				addAnimation("normal", [0, 1], 10);
			}
		}
		
		public override function update() : void {
			super.update();
			
			play("normal");
			
			if (life > 0) {
				life--;
				if (life == 0) {
					this.kill();
					life = -1;
				}
			}
		}
		
		public function makeRiot() : Boolean {
			var b : Boolean = false;
			switch (aggresiveness) {
				case 1: b= (Math.random() < 0.1); break;
				case 2: b=(Math.random() < 0.3); break;
				case 3: b=(Math.random() < 0.5); break;
				case 4: b=(Math.random() < 0.9); break;
			}
			if (b) {
				life = STARTING_LIFE;
			}
			return b;
		}
	}
}