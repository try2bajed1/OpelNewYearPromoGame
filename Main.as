package {
	
	import com.flashandmath.dg.display.SnowDisplay;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenLite;
	import events.NavigationEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import utils.Console;
	import views.GameView;
	import views.IntroScreen;
	
	
	/**
	 * ...
	 * @author me
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite {
		
		
		private var _introScreen:IntroScreen;
		private var _gameView:GameView;
		private var _socialSelected:String;
		
		private var _photosVec:Vector.<BitmapData> = new Vector.<BitmapData>();
		private var _girland:MovieClip;
		private var _loadingText:Sprite;
		private var _carType:uint;
		
		
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		private function init(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			Security.allowDomain('*');
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_introScreen = new IntroScreen();
			addChild(_introScreen);
			
			_introScreen.addEventListener(NavigationEvent.SHOW_GAME_VIEW, _showGameView);
			_introScreen.addEventListener(NavigationEvent.SELECT_SOCIAL, _onSocialSelect);
			_introScreen.visible = true;
			
			
			_gameView = new GameView();
			_gameView.addEventListener(NavigationEvent.SHOW_FINAL, _showFinalState);
			addChild(_gameView);
			_gameView.visible = false;
			
			
			_girland = new girland();
			_girland.mouseEnabled = false;
			_girland.mouseChildren = false;
			addChild(_girland)
			
			
			_loadingText = new Loading();
			_loadingText.x = stage.stageWidth / 2 - _loadingText.width / 2;
			_loadingText.y = 250;
			addChild(_loadingText);
			_loadingText.visible = false;
			
			
			// for debugging
			if (!_introScreen.visible) {
				_gameView.visible = true;
				_gameView.setCarModel(0);
				_gameView.start();
			}
			
			if (ExternalInterface.available) {
				ExternalInterface.addCallback('setText',  getPicLinksFromJS);
			}
			
			var snow:SnowDisplay = new SnowDisplay(900, 600);
			snow.maxNumParticles = 550;
			addChild(snow);
			
		}
		
		
		
		private function _onSocialSelect(e:NavigationEvent):void {
			_socialSelected = e.params['social'] ;
		}
		
		
		
		
		private function _showFinalState(e:NavigationEvent):void {
			
			_gameView.visible = false;
			_introScreen.visible = true;
			_introScreen.showBox();
		}
		
		
		
		//private var _tempXml:XML = <response> <uid>1535608</uid> <display_name>РЎРµРЅС‡СѓСЂРёРЅ РќРёРєРѕР»Р°Р№</display_name> <friends> <friend> <uid>50176920</uid> <display_name>РЎС‹С‡РµРІР° Р•РІРіРµРЅРёСЏ</display_name> <photo>http://cs308230.userapi.com/v308230920/31e3/vdEPUd0eHpA.jpg</photo> </friend> <friend> <uid>6025468</uid> <display_name>РўРёРЅСЊРєРѕРІ РђРЅРґСЂРµР№</display_name> <photo>http://cs323224.userapi.com/u6025468/d_c6747699.jpg</photo> </friend> <friend> <uid>4209321</uid> <display_name>РђРІРµСЂС‡СѓРє Р“Р»РµР±</display_name> <photo>http://cs306610.userapi.com/u4209321/d_993d09d2.jpg</photo> </friend> <friend> <uid>1500969</uid> <display_name>Р“СѓР»СЏР№РєРёРЅ Р”РµРЅРёСЃ</display_name> <photo>http://cs323625.userapi.com/v323625969/2443/XynPrf3b_-w.jpg</photo> </friend> <friend> <uid>17399681</uid> <display_name>Р“РѕРЅС‡Р°СЂРѕРІ Р’РёС‚Р°Р»РёР№</display_name> <photo>http://cs303411.userapi.com/v303411681/409f/7MdzLLx_fro.jpg</photo> </friend> <friend> <uid>78778</uid> <display_name>Р”РѕСЂРѕРЅРёРЅР° РћР»СЊРіР°</display_name> <photo>http://cs308926.userapi.com/v308926778/3794/sTVSSSbtk0o.jpg</photo> </friend> <friend> <uid>1822633</uid> <display_name>РЎРѕРєРѕР»РѕРІР° РСЂРёРЅР°</display_name> <photo>http://cs316216.userapi.com/v316216633/6b9a/TL--2i9zBEo.jpg</photo> </friend> <friend> <uid>71653</uid> <display_name>РўРёРЅСЊРєРѕРІР° РўР°РЅСЏ</display_name> <photo>http://cs406924.userapi.com/v406924653/280d/4113a0vmSN4.jpg</photo> </friend> <friend> <uid>75887484</uid> <display_name>РЎРµРЅС‡СѓСЂРёРЅ Р”РјРёС‚СЂРёР№</display_name> <photo>http://cs317731.userapi.com/u75887484/d_b1f27704.jpg</photo> </friend> <friend> <uid>779393</uid> <display_name>Р—Р°РµРІР° Р›СЋРґРјРёР»Р°</display_name> <photo>http://cs323930.userapi.com/v323930393/23bd/VKw97oYrMis.jpg</photo> </friend> <friend> <uid>394170</uid> <display_name>Р©СѓСЂРѕРІ РђР»РµРєСЃР°РЅРґСЂ</display_name> <photo>http://cs4125.userapi.com/u394170/d_6576fc9a.jpg</photo> </friend> <friend> <uid>376859</uid> <display_name>РљРЅСЏР·РµРІ РРіРѕСЂСЊ</display_name> <photo>http://cs303810.userapi.com/u376859/d_2883aba3.jpg</photo> </friend> <friend> <uid>144103701</uid> <display_name>Narmetov Nurik</display_name> <photo>http://cs319631.userapi.com/v319631701/4e1f/jhuB8YSqF3c.jpg</photo> </friend> <friend> <uid>179467653</uid> <display_name>РћРґРёРЅС†РѕРІ РђР»РµРєСЃРµР№</display_name> <photo>https://vk.com/images/camera_b.gif</photo> </friend> <friend> <uid>864478</uid> <display_name>РњР°РєРѕРІСЃРєР°СЏ Р®Р»РёСЏ</display_name> <photo>http://cs419030.userapi.com/v419030478/46a/WhexiQboniA.jpg</photo> </friend> <friend> <uid>634759</uid> <display_name>РљРѕРїС‚РµРІР° РўР°С‚СЊСЏРЅР°</display_name> <photo>http://cs421430.userapi.com/v421430759/1072/izTIvR_Cz1Y.jpg</photo> </friend> <friend> <uid>3108410</uid> <display_name>РљСЂР°СЃРѕС‚С‹ Р“СЂРµС‡РµСЃРєР°СЏ</display_name> <photo>http://cs316729.userapi.com/u3108410/d_7888eff3.jpg</photo> </friend> <friend> <uid>214624</uid> <display_name>Р“РѕР»СѓР±С‡РёРєРѕРІ РР»СЊСЏ</display_name> <photo>http://cs5696.userapi.com/u214624/d_f3e4c90a.jpg</photo> </friend> <friend> <uid>79424038</uid> <display_name>Р–РёС‚РµР»РµРІ Р”РµРЅРёСЃ</display_name> <photo>http://cs11365.userapi.com/u79424038/d_f188a2f4.jpg</photo> </friend> <friend> <uid>1169267</uid> <display_name>РќРѕСЂРєРёРЅ РђРЅРґСЂРµР№</display_name> <photo>http://cs416528.userapi.com/v416528267/1878/CLr083T7KaI.jpg</photo> </friend> </friends> </response>
		
		
		private function getPicLinksFromJS(str:String):void {
			
			var xml:XML = XML(str)
			//var xml:XML = _tempXml;
			var linksList:XMLList = xml.friends.friend.photo;
			var queue:LoaderMax = new LoaderMax({name:"mainQueue", onComplete:_allPhotosLoadedHandler });
			
			for (var i:int = 0; i < 20; i++) {
				queue.append( new ImageLoader(linksList[i], {name:"photo"+i, estimatedBytes:2400, scaleMode:"proportionalInside",onComplete:_singleImageLoad}) );
			}
			
			queue.load();
			
		}
		
		
		
		
		
		private function _allPhotosLoadedHandler(event:LoaderEvent):void {
			
			_gameView.fillPhotosVec(_photosVec);
			
			_introScreen.tempPhotosVec = _photosVec;
			
			_loadingText.visible = false;
			
			_gameView.visible = true;
			
			_gameView.setCarModel(_carType);
			_gameView.start();			
			
		}
		
		
		
		
		
		private function _singleImageLoad(e:LoaderEvent):void {
			
			if (e.currentTarget.rawContent is Bitmap) {
				_photosVec.push(e.currentTarget.rawContent.bitmapData);
			} 
			
			if (e.currentTarget.rawContent is Loader) {
				var bd:BitmapData = new BitmapData(100,100);
				bd.draw(e.currentTarget.rawContent);
				_photosVec.push(bd);
				var b:Bitmap = new Bitmap(bd);
				addChild(b);
			}
			
		}
		
		
		
		
		
		private function _showGameView(e:NavigationEvent):void {
			
			_introScreen.visible = false;
			_carType = e.params['carType']
			
			if (_socialSelected){
				
				_loadingText.visible = true;
				
			} else {
				
				_loadingText.visible = false;
				
				_gameView.visible = true;
				_gameView.setCarModel(_carType);
				_gameView.start();
				
			}
		}
		
		
		
		
		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}

}