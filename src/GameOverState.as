package
{
	import org.flixel.*;

	public class GameOverState extends FlxState
	{		[Embed(source="img/gameover.png")] 		private var TitleImage:Class;
		public function GameOverState()
		{			var titleSprite : FlxSprite = new FlxSprite(0, 0, TitleImage);			add(titleSprite);
		}
		override public function update():void
		{
			super.update();
			if(FlxG.keys.justPressed("x") || FlxG.keys.justPressed("X"))
				FlxG.switchState(MenuState);
		}
	}
}
