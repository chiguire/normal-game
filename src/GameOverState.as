package
{
	import org.flixel.*;

	public class GameOverState extends FlxState
	{
		public function GameOverState()
		{
		}
		override public function update():void
		{
			super.update();
			if(FlxG.keys.justPressed("x") || FlxG.keys.justPressed("X"))
				FlxG.switchState(MenuState);
		}
	}
}