package views {
	import com.adobe.images.JPGEncoder;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import events.NavigationEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import utils.Console;
	import utils.CustomURLLoader;
	
	import flash.text.TextField;
	
	
	/**
	 * ...
	 * @author me
	 */
	
	public class IntroScreen extends Sprite {
		
		
		private var _bcg:Bitmap; 
		private var _firTree:Bitmap;
		private var _loginWindow:LoginWindow;
		private var _dressUp:Bitmap;
		private var _goGameBtn:SimpleButton;
		
		private var _corsaSelect:SimpleButton;
		private var _astraSelect:SimpleButton;
		private var _mokkaSelect:SimpleButton;
		
		
		private var tempTxt:TextField;
		private var tempTw:TweenLite;
		
		private var _lamp:Sprite;
		private var _carIndex:uint;
		private var _box:SimpleButton;
		private var _finalCar:Sprite;
		private var _driveTextSp:Sprite;
		
		private var _playAgain:PlayAgain;
		private var _postContainer:PostContainer;
		private var _explode:MovieClip;
		private var _messageWindow:Bitmap;
		private var _photosContainer:Sprite;
		private var _fireworksContainer:Sprite;
		private var _sW:uint;
		
		private var _toysOnTree:Sprite;
		
		public var tempPhotosVec:Vector.<BitmapData>;
		private var _treePointVec:Vector.<Point> = Vector.<Point>([new Point(250,156),
																	new Point(382,126),
																	new Point(238, 265),
																	new Point(366, 212),
																	new Point(435, 207),
																	new Point(236, 354), 
																	new Point(329, 340),
																	new Point(411, 352)]);		
		
		
																	
		public function IntroScreen() {
			
			addEventListener(Event.ADDED_TO_STAGE, _drawInterface);
			
		}
		
		
		
		
		private function _drawInterface(e:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, _drawInterface);
			_sW = stage.stageWidth;
			var _bcgBmd:Intro_bcg = new Intro_bcg();
			_bcg = new Bitmap(_bcgBmd);
			addChild(_bcg)
			
			_fireworksContainer = new Sprite();
			addChild(_fireworksContainer);
			
			var _firtreeBmd:Firtree = new Firtree();
			_firTree = new Bitmap(_firtreeBmd);
			_firTree.y = 300;
			_firTree.scaleX = 0.5;
			_firTree.scaleY = 0.5;
			_firTree.x = (_sW >> 1) - (_firTree.width>>1);
			addChild(_firTree);
			
			var _dressUpBmd:DressUp = new DressUp();
			_dressUp = new Bitmap(_dressUpBmd);
			_dressUp.y = -250;
			_dressUp.x = (_sW >> 1) - (_dressUp.width>>1);
			addChild(_dressUp);
			
			_goGameBtn = new GoGame()
			_goGameBtn.x = (_sW >> 1 ) - (_goGameBtn.width >> 1);
			_goGameBtn.y = 1000;
			addChild(_goGameBtn)
			_goGameBtn.addEventListener(MouseEvent.CLICK, showLoginWindow)			
			
			
			_loginWindow = new LoginWindow();
			_loginWindow.x = (_sW >> 1) - (_loginWindow.width>>1);
			_loginWindow.y = 360;
			_loginWindow.alpha = 0;
			_loginWindow.visible = false;
			_loginWindow.vkBtn.addEventListener(MouseEvent.CLICK, startReg);
			_loginWindow.fbBtn.addEventListener(MouseEvent.CLICK, startReg);
			_loginWindow.goBtn.addEventListener(MouseEvent.CLICK, _showSelectView);
			addChild(_loginWindow);
			
			
			_astraSelect = new Astra_select();
			_astraSelect.visible = false;
			_astraSelect.x = 30;
			_astraSelect.y = 280;
			addChild(_astraSelect)
			_astraSelect.addEventListener(MouseEvent.CLICK, _chooseHandler);
			
			
			_corsaSelect = new Corsa_select()
			_corsaSelect.visible = false;
			_corsaSelect.x = 300;
			_corsaSelect.y = 290;
			addChild(_corsaSelect)
			_corsaSelect.addEventListener(MouseEvent.CLICK, _chooseHandler);
			
			
			_mokkaSelect = new Mokka_select()
			_mokkaSelect.visible = false;
			_mokkaSelect.x = 540;
			_mokkaSelect.y = 280;
			addChild(_mokkaSelect)
			_mokkaSelect.addEventListener(MouseEvent.CLICK, _chooseHandler);
			
			
			
			_lamp = new Sprite();
			var lb:Bitmap = new Bitmap(new Lamp());
			_lamp.addChild(lb);
			
			
			var logo:Bitmap = new Bitmap(new Flag_logo());
			logo.x = 40;
			logo.y = 200
			_lamp.addChild(logo);
			_lamp.x = 750;
			_lamp.y = 200;
			addChild(_lamp)
			
			_lightLine = new Bitmap(new LightLine())
			_lightLine.x = 110 ;
			_lightLine.y = 120;
			addChild(_lightLine);
			_lightLine.visible = false;
			
			
			_toysOnTree = new ToysOnTree();
			addChild(_toysOnTree);
			_toysOnTree.x = 110;
			_toysOnTree.y = 20;
			_toysOnTree.visible = false;
			
			
			_finalCar = new Sprite;
			_finalCar.x = 1000;
			_finalCar.y = 360;
			_finalCar.buttonMode = true;
			_finalCar.addEventListener(MouseEvent.CLICK, _openPage)
			addChild(_finalCar);
			
			
			_driveTextSp = new Sprite();
			var b:Bitmap =  new Bitmap(new Drive())
			_driveTextSp.x = 500;
			_driveTextSp.y = -350;
			_driveTextSp.addChild(b)
			_driveTextSp.buttonMode = true;
			_driveTextSp.addEventListener(MouseEvent.CLICK, _openPage)
			addChild(_driveTextSp);		
			
			
			
			_box = new OpenMe();
			_box.x = 400;
			_box.y = -300;
			addChild(_box);
			_box.addEventListener(MouseEvent.CLICK, _onBoxClick)
			
			
			_playAgain = new PlayAgain();
			_playAgain.x = 10;
			_playAgain.y = 520;
			addChild(_playAgain)
			_playAgain.addEventListener(MouseEvent.CLICK, _restartGame)
			_playAgain.visible = false; // TODO: make play again 
			
			
			_postContainer = new PostContainer();
			_postContainer.x = 210;
			_postContainer.y = 510;
			addChild(_postContainer);
			_postContainer.vk.addEventListener(MouseEvent.CLICK, _sendPictureToServer);
			_postContainer.fb.addEventListener(MouseEvent.CLICK, _sendPictureToServer);
			//_postContainer.mail.addEventListener(MouseEvent.CLICK, _sendPictureToServer);
			_postContainer.visible = false;			
			
			start();
			
		}
		
		
		
		private function _openPage(e:MouseEvent):void {
			var req:URLRequest = new URLRequest('http://www.opel.ru');
			navigateToURL(req,'_blank')
		}
		
		
		
		private function _chooseHandler(e:MouseEvent):void {
			
			if (e.currentTarget == _astraSelect) _carIndex = 0;
			if (e.currentTarget == _corsaSelect) _carIndex = 1;
			if (e.currentTarget == _mokkaSelect) _carIndex = 2;
			
			dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_GAME_VIEW, true, { 'carType': _carIndex }));
		}
		
		
		
		
		private function _showSelectView(e:MouseEvent):void {
			
			_loginWindow.visible = false;
			_astraSelect.visible = true;
			_corsaSelect.visible = true;
			_mokkaSelect.visible = true;
		}
		
		
		
		
		private function showLoginWindow(e:MouseEvent):void {
			
			SimpleButton(e.currentTarget).visible = false;
			_loginWindow.visible = true;
			TweenLite.to(_loginWindow, 0.3, { alpha:1, y:"-120" } );
			
		}
		
		
		
		public function start():void {
			
			TweenLite.to(_firTree, 0.5, {x:200 , y:0, scaleX:1, scaleY:1 } );
			TweenLite.to(_dressUp, 0.5, { delay:0.5, y:240, ease:Back.easeOut, onComplete:goStep2 } );
			//showBox();
			
		}
		
		
		
		
		private function startReg(e:MouseEvent):void {
			
			_showSelectView(null);
			
			_selectedNetStr = (e.currentTarget == _loginWindow.vkBtn) ? 'vk' : 'fb' ;
			dispatchEvent(new NavigationEvent(NavigationEvent.SELECT_SOCIAL, true, {'social': _selectedNetStr} ));
			
			if (ExternalInterface.available) {
				ExternalInterface.call('selectSocial', _selectedNetStr);
			}
			
		}		
		
		
		
		
		
		private function goStep2():void {
			
			TweenLite.to(_goGameBtn, 0.5, { delay:2, y:300, ease:Back.easeOut } );
			TweenLite.to(_dressUp, 0.5, { delay:1.5, y:120 } );
			
		}
		
		
		
		public function showBox():void {
			
			_astraSelect.visible = false;
			_corsaSelect.visible = false;
			_mokkaSelect.visible = false;
			_lamp.visible = false;
			_dressUp.visible = false;
			

			
			_firTree.visible = true;
			_firTree.x = 110;
			_firTree.y = 20;
			_firTree.scaleX = 1;
			_firTree.scaleY = 1;
			
			
			//_postContainer.visible = true;
			//_playAgain.visible = true;
			_lightLine.visible = true;
			//trace(_lightLine.x, _lightLine.y)
			
			_explode = new ExplodeAnimation();
			_explode.stop();
			_explode.x = 500;
			_explode.y = 400;
			_explode.scaleX = 0.5;
			_explode.scaleY = 0.5;
			addChild(_explode);
			_explode.visible = false;
			
			_photosContainer = new Sprite();
			addChild(_photosContainer);
			_photosContainer.visible = false;
			
			_messageWindow = new Bitmap(new Message);
			_messageWindow.x = stage.stageWidth / 2 - _messageWindow.width / 2;
			_messageWindow.y = 200;
			addChild(_messageWindow);
			_messageWindow.visible = false;
			_messageWindow.alpha = 0;
			
			_toysOnTree.visible = true;
			
			
			
			var bd:BitmapData;
			switch (_carIndex) {
				
				case 0:
					bd = new Astra_final();
				break;
				
				case 1:
					bd = new Corsa_final();
				break;
				
				case 2:
					bd = new Mokka_final();
				break;
				
			}
			_finalCar.addChild(new Bitmap(bd));
			
			
			TweenLite.to(_box, 1, { y:280, ease:Bounce.easeOut } );
			
		}
		
		
		
		private function _restartGame(e:MouseEvent):void {
			
			e.currentTarget.visible = false;
			
			_postContainer.visible = false;
			
			//_finalCar.visible = false;
			_finalCar.x = 1000;
			_finalCar.removeChildren();
			
			_astraSelect.visible = true;
			_corsaSelect.visible = true;
			_mokkaSelect.visible = true;
			
			_toysOnTree.visible = false;
			_lightLine.visible = false;
			
			_driveTextSp.y = -350;
			_firTree.x = (_sW >> 1) - (_firTree.width >> 1);
			
			_dressUp.visible = true;
			_dressUp.y = 120;
			_lamp.visible = true;
			
			
			_postContainer.visible = false;
			_playAgain.visible = false;			
			
			_photosContainer.removeChildren();
			
			
			_firTimer.reset();
			//_fireworksContainer.removeChildren();
			_box.y = -300;
			_box.alpha = 1;
			_box.scaleX = 1;
			_box.scaleY = 1;
			_box.visible = true;
		}
		
		
		
		
		private function _onBoxClick(e:MouseEvent):void {
			
			TweenLite.to(_box, 0.2, { x:"100", y:"100", scaleX:0.5, scaleY:0.5, alpha:0, onComplete: scEmpty } );
		}		
		
		
		
		
		private function scEmpty():void {
			
			_box.visible = false;
			//removeChild(_box);
			_explode.visible = true;
			TweenLite.to(_explode, 0.2, { x:"-100", y:"-100", scaleX:1, scaleY:1,  onComplete: _startExplode } );
		}
		
		
		
		
		
		private function _startExplode():void {
			
			_explode.play();
			
			_generatePhotosOnTree();
			
			_startPhotosAnimation();
			
			TweenLite.delayedCall(2, _showFinalCar);
			
		}
		
		
		
		private function _startPhotosAnimation():void {
			
			_photosContainer.visible = true;
			var len:uint = _photosContainer.numChildren;
			for (var i:int = 0; i < len; i++) {
				
				TweenLite.to(_photosContainer.getChildAt(i), 1, { x:_treePointVec[i].x - 40,
																  y:_treePointVec[i].y,
																  rotationY:0, 
																  rotationX:0, 
																  rotationZ:-10 + Math.round(20 * Math.random()) } );
			}
		}
		
		
		
		
		private function _showFinalCar():void {
			
			_playAgain.visible = true;
			_postContainer.visible = true;
			
			//_explode.visible = false;
			removeChild(_explode);
			
			TweenLite.to(_finalCar, 0.5, { x:440 } );
			TweenLite.to(_driveTextSp, 0.5, { y:80 } );
			
			_firTimer = new Timer(2000, 15);
			_firTimer.addEventListener(TimerEvent.TIMER, generateFirework);
			_firTimer.start();
		}
		
		
		
		private function generateFirework(e:TimerEvent):void {
			
			var fire:Sprite = new Fireworks();
			fire.blendMode = BlendMode.OVERLAY;
			fire.x = 200 +  400*Math.random();
			fire.y = Math.random() * 100;
			fire.scaleX = 0.6;
			fire.scaleY = 0.6;
			fire.alpha = 0;
			_fireworksContainer.addChild(fire);
			
			TweenLite.to(fire, 3, { y:"10", scaleX:1.3, scaleY:1.3, alpha:1,  onComplete:hideFire,  ease:Quint.easeOut, onCompleteParams:[fire] } );
			
		}
		
		
		
		
		private function hideFire(sp:Sprite):void {
			
			if (sp) TweenLite.to(sp, 2, { y:"5", alpha:0, onComplete:_removeFireworkSp, onCompleteParams:[sp] } );
		}
		
		
		
		private function _removeFireworkSp(sp:Sprite):void {
			if(sp) _fireworksContainer.removeChild(sp);
		}
		
		
		private var _lightLine:Bitmap;
		private var _firTimer:Timer;
		private var _selectedNetStr:String;
		
		
		
		
		private function _generatePhotosOnTree():void {
			
			checkVec();
			
			for (var i:int = 0; i < 8; i++) {
				
				var rect:Sprite = new Sprite();
				rect.graphics.beginFill(0xFFFFFF);
				rect.graphics.drawRoundRect(0, 0, 60, 60, 10, 10);
				rect.x = _explode.x + 50;  //crdVec[i].x -30;
				rect.y = _explode.x + 50;  //crdVec[i].y -10;
				rect.rotationX = -100;
				rect.rotationY = -100;
				rect.rotationZ = -100;
				_photosContainer.addChild(rect);
				//rect.rotation = -10 + Math.round(20 * Math.random());
				rect.name = 'rect' + i;
				var croppedBmd:BitmapData = new BitmapData(100, 100);
				croppedBmd.copyPixels(tempPhotosVec[i], new Rectangle(0,0,100,100), new Point());
				var b:Bitmap = new Bitmap(croppedBmd);
				b.smoothing = true;
				b.width = 50;
				b.height = 50;
				b.x = 5;
				b.y = 5;
				rect.addChild(b);
			}
			
		}
		
		
		
		
		private function checkVec():void { // !!!!!!!!!удалить
			
			if(!tempPhotosVec) {  // если не выцеплены фотки из соцсетей
				//trace('set default photos')
				tempPhotosVec = new Vector.<BitmapData>();
				tempPhotosVec.push(new PicFriend1());
				tempPhotosVec.push(new PicFriend2());
				tempPhotosVec.push(new PicFriend3());
				tempPhotosVec.push(new PicFriend5());
				tempPhotosVec.push(new PicFriend6());
				tempPhotosVec.push(new PicFriend7());
				tempPhotosVec.push(new PicFriend8());
				tempPhotosVec.push(new PicFriend9());
				tempPhotosVec.push(new PicFriend10());
				tempPhotosVec.push(new PicFriend11());
				tempPhotosVec.push(new PicFriend12());
				tempPhotosVec.push(new PicFriend13());
				
			}
			
		}		
		
		
		
		
		private function _sendPictureToServer(e:MouseEvent):void {
			
			
			
			_messageWindow.visible = true;
			
			TweenLite.to(_messageWindow, 2, {y:'-30',alpha:1, onComplete:_hideWindow})
			
			var postUrl:String;
			e.currentTarget.visible = false;
			if (e.currentTarget == _postContainer.vk) {
				postUrl = 'vk/';
				if (!_selectedNetStr) ExternalInterface.call('selectSocial', 'vk');
			}
			
			if (e.currentTarget == _postContainer.fb) {
				postUrl = 'fb/';
				if (!_selectedNetStr) ExternalInterface.call('selectSocial', 'fb');
			}
			
			//if (e.currentTarget == _postContainer.mail) return; 
			
			
			
			var bmd : BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight);
			bmd.draw(this, new Matrix(), null, null, null, true );
			var byteArray : ByteArray = new JPGEncoder(80).encode( bmd );
			
			var urlRequest : URLRequest = new URLRequest();
			urlRequest.url = postUrl;
			urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = UploadPostHelper.getPostData('firtree.png', byteArray);
			urlRequest.requestHeaders.push( new URLRequestHeader('Cache-Control', 'no-cache' ));
			
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			urlLoader.addEventListener( Event.COMPLETE, onImageCreated );
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, onImageCreationError );
			urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onImageCreationError );
			urlLoader.load( urlRequest );
			
		}
		
		
		
		private function _hideWindow():void {
			
			TweenLite.to(_messageWindow, 1, { delay:1, alpha:0 } );
		}
		
		
		
		
		
		private function onImageCreationError(e:Event):void {
			Console.log('error in post')
		}
		
		
		private function onImageCreated(e:Event):void {
			
			//var customURLLoader:CustomURLLoader = e.target as CustomURLLoader;
            //trace(customURLLoader.urlRequest.data); 
			//Console.log(String(customURLLoader.urlRequest.data));
			
			var dataStr:String = e.currentTarget.data.toString();
			var resultVars:URLVariables = new URLVariables();
			resultVars.decode(dataStr);
			var photoName = resultVars['photo'];
			
			if (ExternalInterface.available) {
				ExternalInterface.call('shareInVK', photoName)
			}
			
			Console.log(photoName)
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
}