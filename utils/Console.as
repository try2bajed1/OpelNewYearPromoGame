package utils {
	
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.external.ExternalInterface;

    public class Console extends Sprite  {
		
        public function Console():void {
            super();
            _init();
        }
		
		
        public static function log(... arguments):void  {
            Console._show(arguments);
        }
		
		
        public static function warn(... arguments):void {
            Console._show(arguments, "warn");
        }
		
		
        public static function error(... arguments):void {
            Console._show(arguments, "error");
        }
		
		
        private static function _show(args:Object,type:String = "log"):void {
            if (!ExternalInterface.available) {
				trace('EXT DISABLED, SEE RESULT IN BROWSER');
				return;
			} else {
				for(var i:String in args)  {
					if ( !args[i] is String ) {
						args[i] = args[i].toString();
					}
					ExternalInterface.call("console." + type, args[i]);
					if( type == "log") _show(args[i]);  //write each argument in browser's console
				}
			}
        }
		
		
		
        private function _init():void   {
            if(loaderInfo.hasOwnProperty("uncaughtErrorEvents"))
                loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, _uncaughtErrorHandler, false, 0, true);
        }
		
		
        private function _uncaughtErrorHandler(e:UncaughtErrorEvent):void {
            if( e.error is Error)   {
                var stack:String = Error(e.error).getStackTrace();
                Console.error(Error(e.error).message + ((stack!=null)? "\n"+stack : ""));
            }
            else if( e.error is ErrorEvent)
                Console.error(ErrorEvent(e.error).text);
            else
                Console.error(e.error.toString());
        }
		
		
    }

	
}	
	
	
	
	