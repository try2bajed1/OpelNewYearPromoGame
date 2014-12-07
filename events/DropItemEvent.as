package events {
	
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class DropItemEvent extends Event	{
		
		public static const START_DROP:String = "start_drop";
		
		
		public var pointDropFrom:Point;
		
		public function DropItemEvent(type:String, bubbles:Boolean = false, p:Point = null )
		{
			super(type, bubbles);
			this.pointDropFrom = p;
		}
	}
}