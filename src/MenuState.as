package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		public function MenuState()
		{
		}

		override public function update():void
		{
			super.update();
			if(FlxG.mouse.justPressed())
				FlxG.switchState(PlayState);
		}
	}
}