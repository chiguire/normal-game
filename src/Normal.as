package
{
	import org.flixel.*;
	[SWF(width="540", height="200", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Normal extends FlxGame
	{
		public function Normal()
		{
			super(54,20,MenuState,10);
			showLogo = false;
		}
	}
}
