package events {
	
	
	import flash.events.Event;
	
	public class NavigationEvent extends Event	{
		
		public static const SHOW_GAME_VIEW:String = "show_game_view";
		public static const SHOW_FINAL:String = "show_final";
		public static const SELECT_SOCIAL:String = "SELECT_SOCIAL";
		
		
		public var params:Object;
		
		public function NavigationEvent(type:String, bubbles:Boolean=false, _params:Object = null)
		{
			super(type, bubbles);
			this.params = _params;
		}
	}
}