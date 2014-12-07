package utils
{
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class CustomURLLoader extends URLLoader
    {
        private var _urlRequest:URLRequest;

        public function get urlRequest():URLRequest
        {
            return _urlRequest;

        }// end function

        public function CustomURLLoader(urlRequest:URLRequest)
        {
            super(urlRequest);
            _urlRequest = urlRequest;

        }// end function

    }// end class

}// end package