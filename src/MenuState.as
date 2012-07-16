package
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{		[Embed(source="img/title.png")] 		private var TitleImage:Class;
		public function MenuState()
		{			var titleSprite : FlxSprite = new FlxSprite(0, 0, TitleImage);			add(titleSprite);
		}

		override public function update():void
		{
			super.update();
			if(FlxG.mouse.justPressed())
				FlxG.switchState(PlayState);
		}
	}
}
