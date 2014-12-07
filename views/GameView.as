package views {
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import events.DropItemEvent;
	import events.NavigationEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.ShaderPrecision;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author me
	 */
	public class GameView extends Sprite {
		
		private var _bcg:GameBcg;
		private var _road:Bitmap;
		private var _roadPerspectiveContainer:Sprite;
		private var _dashed:DashedAnimation;
		
		
		private var _car:Sprite;
		private var _dropingItemsContainer:Sprite;
		private var _isPaused:Boolean = false;
		
		private const CAR_STEP:uint = 120;
		private const LEFT_CRD_X:uint = 360;
		private const RIGHT_CRD_X:uint = 520;
		
		private var _objectsTweensDic:Dictionary = new Dictionary();
		
		private var _houseMovePointsVec:Vector.<Point> = new Vector.<Point>();
		
		private var _friendPhotosVec:Vector.<BitmapData>;// = new Vector.<BitmapData>();
		private var _friendSayingsVec:Vector.<String> = new Vector.<String>();
		private var _rectVec:Vector.<Rectangle> = new Vector.<Rectangle>();
		
		private var _houseGenerateTimer:Timer;
		private var _hatchTimer:Timer;
		private var _lampGenerateTimer:Timer;
		private var _hatchersContainer:Sprite;
		
		private var _sW:uint;
		private var _sH:uint;
		private var _catchedToysSp:ToysPicked;
		private var _toysNum:uint = 0;
		
		
		private const MAX_TOYS_CATCHED:uint = 10;
		static public const CAR_DEF_Y:uint = 440;
		static public const CAR_WIDTH:uint = 180;
		private var _carPosIndex:uint = 1 ;  // 0 1 2  
		
		
		private var _breakSnd:Break_snd;
		private var _sndChannel:SoundChannel;
		private var _sndTransf:SoundTransform = new SoundTransform();

		private var _fonSnd:FonSnd;
		private var _sndFonChanel:SoundChannel;
		//private var _sndTransf:SoundTransform
		
		private var _volBtn:VolumeBtn;
		private var _pauseBtn:pauseGame;
		
		
		
		private var _treeToy2:Sprite;
		private var _treeToy1:Sprite;
		private var _treeToy3:Sprite;
		private var _howTo:HowTo;
		
		
		
		
		public function GameView() {
			
			
			addEventListener(Event.ADDED, _onAdded);
			
			
			_houseMovePointsVec.push(new Point(1250, 750));
			_houseMovePointsVec.push(new Point(920,  400)); 
			_houseMovePointsVec.push(new Point(750,  800));
			
			
			_friendSayingsVec.push('Смотри на дорогу!');
			_friendSayingsVec.push('А из окна сейчас вылетит птичка');
			_friendSayingsVec.push('И кто тебе только права выдал..');
			_friendSayingsVec.push('Как обычно, в баню?');
			_friendSayingsVec.push('Сне-гу-ро-чка!');
			_friendSayingsVec.push('Подарки купил?');
			_friendSayingsVec.push('На летней резине что-ли?');
			_friendSayingsVec.push('Санта Клаус - мой кумир!');
			_friendSayingsVec.push('Не спи - замерзнешь!');
			_friendSayingsVec.push('Ой, уже зима что-ли?');
			_friendSayingsVec.push('Да брось, конец света же!');
			_friendSayingsVec.push('Ты уже в спячке что ли?');
			_friendSayingsVec.push('На дорогу смотри!');
			_friendSayingsVec.push('Не пей за рулем!');
			_friendSayingsVec.push('А я мандарины вешаю!');
			_friendSayingsVec.push('Ой, уже зима что ли?');
			
		}
		
		
		
		
		
		
		private function _onAdded(e:Event=null):void {
			
			removeEventListener(Event.ADDED, _onAdded)
			
			_sW = stage.stageWidth;
			_sH = stage.stageHeight;
			
			
			var _bcg:AnimatedBcg = new AnimatedBcg();
			_bcg.x = -1356;
			addChild(_bcg);
			
			
			_roadPerspectiveContainer = new Sprite();
			addChild(_roadPerspectiveContainer)
			var _roadBmd:RoadBcg = new RoadBcg();
			_road = new Bitmap(_roadBmd);
			_road.x = (_sW >> 1) - (_road.width>>1);
			_road.y = _sH - _road.height;
			_roadPerspectiveContainer.addChild(_road);
			_roadPerspectiveContainer.name = 'roadp' ;
			_roadPerspectiveContainer.addEventListener(DropItemEvent.START_DROP, startDrop);
			
			
			_dashed = new DashedAnimation();
			_dashed.paused.visible = false;
			_dashed.x = 250;
			_dashed.y = 370;
			addChild(_dashed);
			
			
			_hatchersContainer = new Sprite();
			addChild(_hatchersContainer);
			
			_catchedToysSp = new ToysPicked();
			_catchedToysSp.x = (_sW >> 1) - (_catchedToysSp.width >> 1);
			_catchedToysSp.y = 40;
			addChild(_catchedToysSp);
			
			_dropingItemsContainer = new Sprite()
			addChild(_dropingItemsContainer);
			_updateCathcedText(_toysNum)
			
			_car = new Sprite();
			_car.x = _sW >> 1;
			_car.y = CAR_DEF_Y;
			addChild(_car);
			
			
			_volBtn = new VolumeBtn();
			_volBtn.buttonMode = true;
			_volBtn.x = (_sW >> 1) - 60;
			_volBtn.y = 500;
			_volBtn.snd_on.visible = false;
			addChild(_volBtn);
			_volBtn.addEventListener(MouseEvent.CLICK, changeVol)
			
			
			_pauseBtn = new pauseGame();
			_pauseBtn.buttonMode = true;
			_pauseBtn.play_btn.visible = false;
			_pauseBtn.x = (_sW >> 1) ;
			_pauseBtn.y = 505;
			addChild(_pauseBtn);
			_pauseBtn.addEventListener(MouseEvent.CLICK, _controlTweens);
			
			
			_howTo = new HowTo();
			//_howTo.buttonMode = true;
			//_howTo.mouseChildren = true;
			_howTo.x = _sW / 2 - _howTo.width / 2 + 50;
			_howTo.y = 50;
			
			_howTo.close.addEventListener(MouseEvent.CLICK, _hideHelp)
			addChild(_howTo);
			
			_rectVec.push(new Rectangle((_sW >> 1) - CAR_WIDTH / 2 - CAR_STEP, _car.y - 120, CAR_WIDTH, 120));
			_rectVec.push(new Rectangle((_sW >> 1) - CAR_WIDTH / 2 			 , _car.y - 120, CAR_WIDTH, 120));
			_rectVec.push(new Rectangle((_sW >> 1) - CAR_WIDTH / 2 + CAR_STEP, _car.y - 120 , CAR_WIDTH, 120));
			
			
			_breakSnd = new Break_snd();
			_sndChannel = new SoundChannel();
			
			_fonSnd = new FonSnd();
			_sndFonChanel = new SoundChannel();
			
			stage.focus = stage;
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _moveCarHandler);
			
			
			_houseGenerateTimer = new Timer(2500);
			_houseGenerateTimer.addEventListener(TimerEvent.TIMER, _createHouseHandler);
			
			_lampGenerateTimer = new Timer(2500);
			_lampGenerateTimer.addEventListener(TimerEvent.TIMER, _createLampHandler);
			
			
			_hatchTimer = new Timer(3000);
			_hatchTimer.addEventListener(TimerEvent.TIMER, _createHatchHandler);
			
			
		}
		
		
		
		
		private function _hideHelp(e:MouseEvent):void {
			
			_howTo.removeEventListener(MouseEvent.CLICK, _hideHelp);
			TweenLite.to(_howTo, 1, { alpha:0, onComplete: function() { _howTo.visible = false; } })
			
			_createHouseHandler(null);
			_createLampHandler(null);
			
			_houseGenerateTimer.start();
			_hatchTimer.start();
			TweenLite.delayedCall(1, _startLamps);
			
		}
		
		
		
		
		
		public function setCarModel(type:uint):void {
			
			if (!_car) return;
			
			_car.removeChildren();
			
			var firtreeData:Firtree_car = new Firtree_car();
			var firtrB:Bitmap = new Bitmap(firtreeData)
			firtrB.x = -70;
			firtrB.y = -265;
			_car.addChild(firtrB);
			
			var carData:BitmapData;
			
			switch (type) {
				case 0:
					carData = new Astra_game() as BitmapData;
				break;
				
				case 1:
					carData = new Corsa_game() as BitmapData;
				break;
				
				case 2:
					carData = new Mokka_game() as BitmapData;
				break;				
			}
			
			
			var _carB:Bitmap = new Bitmap(carData);
			_carB.x = -(_carB.width >> 1) ;
			_carB.y = -_carB.height;
			_car.addChild(_carB);			
			
			
			_treeToy1 = new FirTreeToy1();
			_treeToy1.x = -50;
			_treeToy1.y = -180;
			_car.addChild(_treeToy1);
			_treeToy1.visible = false;
			
			
			_treeToy2 = new FirTreeToy2();
			_treeToy2.x = 0;
			_treeToy2.y = -175;
			_treeToy2.visible = false;
			_car.addChild(_treeToy2);
			
			
			_treeToy3 = new FirtreeToy3();
			_treeToy3.x = -25;
			_treeToy3.y = -220;
			_treeToy3.visible = false;
			_car.addChild(_treeToy3);	
			
			
		}
		
		
		
		
		
		
		private function changeVol(e:MouseEvent):void {
			
			if (_sndTransf.volume == 1) {
				_volBtn.snd_on.visible = true;
				_volBtn.snd_off.visible = false;
				_sndTransf.volume = 0;
				_sndChannel.soundTransform = _sndTransf
				_sndFonChanel.soundTransform  = _sndTransf;
			} else{
				_sndTransf.volume = 1;
				_sndChannel.soundTransform = _sndTransf
				_sndFonChanel.soundTransform  = _sndTransf;
				_volBtn.snd_on.visible = false;
				_volBtn.snd_off.visible = true;
			}
			
		}
		
		
		
		
		
		private function _createHatchHandler(e:TimerEvent):void {
			
			var _hatchBmd:BitmapData;
			var needToCheckCollision:Boolean = (Math.random() > 0.5);
			_hatchBmd = (needToCheckCollision) ? new Hatch_Bad()
											   : new Hatch_Good();
			var _hatch:Bitmap = new Bitmap(_hatchBmd);
			_hatch.smoothing = true;
			_hatch.y = 650;
			_hatchersContainer.addChild(_hatch);
			
			var xTo:uint;
			var posIndex:uint =  Math.floor(3 * Math.random());
			
			if (posIndex == 0) {
				_hatch.x = 260;
				xTo = 310;
			}
			
			if (posIndex == 1) {
				_hatch.x = (Math.random() > 0.5) ? (_sW >> 1) - 80 
												 : (_sW >> 1) + 80;
				xTo = _hatch.x;
			}
			
			if (posIndex == 2) {
				_hatch.x = 550;
				xTo = 500;
			}
			
			var tw:TweenLite =  (needToCheckCollision) ? TweenLite.to(_hatch, 2.5, { x:xTo, y:350, scaleX:0.8, scaleY:0.8, ease:Circ.easeOut,  onUpdate:_checkHatchCollision2, onUpdateParams:[_hatch], onComplete: _removeHatch, onCompleteParams : [_hatch] } )
													   : TweenLite.to(_hatch, 2.5, { x:xTo, y:350, scaleX:0.8, scaleY:0.8, ease:Circ.easeOut,onComplete: _removeHatch, onCompleteParams : [_hatch] } );
			_objectsTweensDic[_hatch] = tw;
			
			_hatchCollisionsDic[_hatch] = false;
			
			
		}
		
		
		
		
		private function _checkHatchCollision2(h:Bitmap):void {
			
			if (_hatchCollisionsDic[h] ) return;
			
			
			if ( h.y < _car.y && h.y > 400) {
					
					if ( h.x + h.width > (_car.x - _car.width / 2 +10  )  && h.x < (_car.x + _car.width / 2 - 10)  ) { 
						
						_hatchCollisionsDic[h] = true;
						_checkTotalCatchedToys(false);
						_car.alpha = 0.5;
						_car.y += 25;
						TweenLite.to(_car, 0.5,  { y:CAR_DEF_Y,  alpha:1 } );
					}
				}
			
		}
		
		
		
		
		private var _hatchCollisionsDic:Dictionary = new Dictionary();
		
		
		private function _checkHatchCollision(posIndex:uint):void {
			
			if (posIndex == _carPosIndex) { 
				
				_checkTotalCatchedToys(false);
				_car.alpha = 0.5;
				_car.y += 25;
				TweenLite.to(_car, 0.5,  { y:CAR_DEF_Y,  alpha:1 } );
				
			} 
			
		}
		
		
		
		
		private function _removeHatch(h:Bitmap):void {
			
			delete _objectsTweensDic[h];
			delete _hatchCollisionsDic[h];
			
			h.bitmapData = null;
			_hatchersContainer.removeChild(h);
			
		}
		
		
		
		public function fillPhotosVec(ver:Vector.<BitmapData>):void {
			
			if (!_friendPhotosVec) {
				_friendPhotosVec = ver;
			}
			
		}		
		
		
		
		
		public function start():void {
			
			if(!_friendPhotosVec) {  // если не выцеплены фотки из соцсетей
				//trace('set default photos')
				_friendPhotosVec = new Vector.<BitmapData>();
				_friendPhotosVec.push(new PicFriend1());
				_friendPhotosVec.push(new PicFriend2());
				_friendPhotosVec.push(new PicFriend3());
				_friendPhotosVec.push(new PicFriend5());
				_friendPhotosVec.push(new PicFriend6());
				_friendPhotosVec.push(new PicFriend7());
				_friendPhotosVec.push(new PicFriend8());
				_friendPhotosVec.push(new PicFriend9());
				_friendPhotosVec.push(new PicFriend10());
				_friendPhotosVec.push(new PicFriend11());
				_friendPhotosVec.push(new PicFriend12());
				_friendPhotosVec.push(new PicFriend13());
				
			}
			
			
			_sndFonChanel = _fonSnd.play(0, 9999);
			_sndFonChanel.soundTransform = _sndTransf;
			
			
			_howTo.visible = true;
			_howTo.alpha = 1;
		}
		
		
		
		private function _startLamps():void {
			_lampGenerateTimer.start();
		}
		
		
		
		
		
		private function _createHouseHandler(e:TimerEvent):void {
			
			
			var rightSideHouse:House = new House(true, _getDataProvider(_generateWindowsIndexesVec()));
			rightSideHouse.x = _houseMovePointsVec[0].x; 
			rightSideHouse.y = _houseMovePointsVec[0].y;	
			rightSideHouse.rotation = 10 * Math.random() +5;
			_roadPerspectiveContainer.addChild(rightSideHouse);
			_startMove(rightSideHouse, 'right');
			
			var leftSideHouse:House = new House(false, _getDataProvider(_generateWindowsIndexesVec()));
			leftSideHouse.x = _sW - _houseMovePointsVec[0].x; 
			leftSideHouse.y = _houseMovePointsVec[0].y;	
			leftSideHouse.rotation = -10 * Math.random() - 5;
			_roadPerspectiveContainer.addChild(leftSideHouse);
			_startMove(leftSideHouse, 'left');			
			
		}				
		
		
		//private function _removeEqual(vec1:Vector.<uint>)
		
		
		
		//  возвращает вектор , каждый элемент это 0,1 или 2
		private function _generateWindowsIndexesVec():Vector.<uint> {
			
			var uVec:Vector.<uint> = new Vector.<uint>();
			
			// 0 - закрытые шторы, 1 - говорит текст,  2 - кидает
			var u1:uint = Math.floor(3 * Math.random());
			uVec.push(u1);
			
			if (u1 == 2) {  // если кидающий, то 2 остальных либо говорят, либо шторы
				uVec.push(Math.floor(2 * Math.random())); //2nd  0 or 1
				uVec.push(Math.floor(2 * Math.random())); //3nd  0 or 1
				
			} else  {
				
				//var u2:uint = Math.floor(3 * Math.random());
				var u2:uint = 0;
				uVec.push(u2);
				if (u2 == 2) {
					uVec.push(Math.floor(2 * Math.random()))
				} else {
					//uVec.push(Math.floor(3 * Math.random())) 
					uVec.push(0) // больше штор
				}
			}
			
			return uVec;
		}
		
		
		
		
		private function _getDataProvider(uVec:Vector.<uint>):Array {
			
			var arrDP:Array = new Array();
			var dpLength:uint = uVec.length;
			
			var randSayPhotoNum:uint;
			var randDropPhotoNum:uint;
			
			for (var i:int = 0; i < dpLength; i++) {
				
				
				if (uVec[i] == 0) arrDP[i] = 0; 
				
				
				if (uVec[i] == 1) {
					
					var saysArr:Array = new Array();
					randSayPhotoNum = Math.floor(_friendPhotosVec.length * Math.random());
					
					if ( randSayPhotoNum == randDropPhotoNum ) { // если выпадает та же фотка, что уже есть в доме, заменяем ее на следующую из общего вектора с фотками
						randSayPhotoNum++
						if (randSayPhotoNum == _friendPhotosVec.length) randSayPhotoNum = 0;
					}
					
					var croppedBmd:BitmapData = new BitmapData(100, 100); // обрезаем 
					croppedBmd.copyPixels(_friendPhotosVec[randSayPhotoNum], new Rectangle(0,0,100,100), new Point());
					
					saysArr[0] = croppedBmd; 
					var randomSayingIndex:uint = Math.floor(_friendSayingsVec.length * Math.random()); 
					saysArr[1] = _friendSayingsVec[randomSayingIndex]; // закидываем случайную строку из списка фраз
					
					arrDP[i] = saysArr;
				}
				
				
				if (uVec[i] == 2) {
					
					randDropPhotoNum = Math.floor(_friendPhotosVec.length * Math.random());
					if (randDropPhotoNum == randSayPhotoNum) { // если выпадает та же фотка, что уже есть в доме, заменяем ее на следующую из общего вектора с фотками
						randDropPhotoNum++;
						if (randDropPhotoNum == _friendPhotosVec.length) randDropPhotoNum = 0;
					}
					var croppedBmd2:BitmapData = new BitmapData(100, 100); // обрезаем 
					croppedBmd2.copyPixels(_friendPhotosVec[randDropPhotoNum], new Rectangle(0,0,100,100), new Point() );
					arrDP[i] = croppedBmd2;
				}
			}
			
			
			return arrDP;
		}
		
		
		
		
		
		
		private function startDrop(e:DropItemEvent):void {
			
			if (_isPaused) return; // если игра на паузе и бросок инициирован, то прерываем его
			
			var pFrom:Point = e.pointDropFrom;
			//pFrom.x += e.currentTarget.x;
			//pFrom.y += e.currentTarget.y;
			
			var xFinal:int;
			var yFinal:uint;
			var xMiddle:uint;
			var xFrom:int = pFrom.x;
			var yFrom:uint = pFrom.y;
			pFrom = null;		
			
			var ballBmd:Toy = new Toy();
			var ball:Bitmap = new Bitmap(ballBmd);
			ball.smoothing = true;
			ball.x = xFrom;
			ball.y = yFrom;
			_dropingItemsContainer.addChild(ball);
			
			var swHalf:uint = _sW >> 1; 
			xFinal = (xFrom > swHalf) ? swHalf + 100 + Math.round(50 * Math.random())
									  : swHalf - 100 - Math.round(50 * Math.random());
			xMiddle = xFinal;
			yFinal = 400;
			
			
			var tw:TweenLite = TweenMax.to(ball, 1.5, { bezier:[ { x:xMiddle, y:yFrom }, { x:xFinal, y:yFinal } ], 
											 orientToBezier:true,
											 ease:Cubic.easeIn,
											 onUpdate:  _checkCatch,
											 onUpdateParams:[ball],
											 onComplete: _dropFinish,
											 onCompleteParams:[ball] } );		
									 
			 _objectsTweensDic[ball] = tw;
			
			
		}
		
		
		
		
		private function _checkCatch(b:Bitmap):void {
			
			var currP:Point = new Point(b.x, b.y);
			
			if (_rectVec[_carPosIndex].containsPoint(currP) && b.visible) {
				b.visible = false;
				_checkTotalCatchedToys(true);
			}
			
		}
		
		
		
		private function _dropFinish(b:Bitmap):void {
			
			if (b.visible) _addBrokenToy(new Point(b.x, b.y));
			
			b.bitmapData = null;
			_dropingItemsContainer.removeChild(b);
			b = null;
			
		}
		
		
		
		
		
		private function _checkToyCollision(b:Bitmap):Boolean {
			
			var isRightSide:Boolean = (b.x > _sW >> 1);
			// mb use rectangles
			return (isRightSide) ? (_car.x + (_car.width >> 1)) > b.x
								 : (_car.x - (_car.width >> 1)) < b.x ;
		}	
		
		
		
		
		private function _addBrokenToy(pTo:Point):void {
			_sndChannel = 	_breakSnd.play();
			_sndChannel.soundTransform = _sndTransf
			//myChannel.soundTransform = myTransform;
			
			var container:Sprite = new Sprite();
			var bmd:BrokenToy = new BrokenToy()
			var b:Bitmap = new Bitmap(bmd);
			b.x = -b.width  >> 1;
			b.y = -b.height >> 1;
			
			container.x = pTo.x;
			container.y = pTo.y;
			container.addChild(b)
			_dropingItemsContainer.addChild(container)
			
			TweenLite.delayedCall(1, _removeBroken, [container]);
			
		}
		
		
		
		
		
		private function _removeBroken(sp:Sprite):void {
			
			Bitmap(sp.getChildAt(0)).bitmapData = null;
			sp.removeChild(sp.getChildAt(0));
			_dropingItemsContainer.removeChild(sp);
			
		}
		
		
		
		
		private function _startMove(dObj:DisplayObject, sideTypeStr:String):void {
			
			dObj.cacheAsBitmap = true;
			var yTo:uint = _houseMovePointsVec[1].y;
			var xTo:int = ( sideTypeStr == 'right' ) ?   _houseMovePointsVec[1].x
											  : - _houseMovePointsVec[1].x + _sW ; // symmetrical
			
			var tw:TweenLite = TweenLite.to(dObj, 3.5, {  x:xTo,
														  y:yTo, 
														  scaleX:0.8,
														  scaleY:0.8,
														  rotation:0,
														  ease:Circ.easeOut,
														  onComplete:_hideTween, 
														  onCompleteParams : [dObj, sideTypeStr] } );
			tw.play();
			_objectsTweensDic[dObj] = tw; 
			
		}
		
		
		
		private function _hideTween(dispObj:DisplayObject, sideTypeStr:String):void {
			
			//TODO: check!!!
			_roadPerspectiveContainer.swapChildren(DisplayObject(dispObj),  DisplayObject(_road));
			
			var yTo:uint = _houseMovePointsVec[2].y;
			var xTo:uint = ( sideTypeStr == 'right' ) ? _houseMovePointsVec[2].x
											          : _sW - _houseMovePointsVec[2].x;
												
			var tw:TweenLite = TweenLite.to(dispObj, 3, { x:xTo,
													y:yTo,
													ease:Circ.easeIn,
													onComplete: clearDicItem, 
													onCompleteParams : [dispObj] } );
			tw.play();
			_objectsTweensDic[dispObj] = tw; 
			
		}
		
		
		
		
		
		private function clearDicItem(b:DisplayObject):void {
			
			//Bitmap(Sprite(b).getChildByName('bitmap')).bitmapData = null;
			
			//Sprite(b).removeChild(Sprite(b).getChildByName('bitmap'));
			delete _objectsTweensDic[b];
			_roadPerspectiveContainer.removeChild(DisplayObject(b));
			b = null;
			
		}		
		
		
		
		private function _createLampHandler(e:TimerEvent):void {
			
			var lampLeft:Sprite = _getLamp('left');
			_roadPerspectiveContainer.addChild(lampLeft);
			_startMove(lampLeft, 'left');
			
			var lampRight:Sprite = _getLamp('right');
			_roadPerspectiveContainer.addChild(lampRight);
			_startMove(lampRight, 'right');
			
		}		
		
		
		
		private function _getLamp(type:String):Sprite {
			
			var lampSp:Sprite = new Sprite();
			
			var anim:MovieClip = new fonar();
			lampSp.addChild(anim);
/*			
			var bmd:BitmapData = new Lamp();
			var lampB:Bitmap;
				lampB = new Bitmap(bmd);
				lampB.name = 'bitmap';
				lampB.smoothing = true;
			lampSp.addChild(lampB);
*/			
			
			if(Math.random() > 0.5 ) {
				var flagData:Flag_logo = new Flag_logo();
				var flagB:Bitmap = new Bitmap(flagData);
				flagB.smoothing = true;
				lampSp.addChildAt(flagB,0);
			}
			
			if (type == 'left') {  //TODO: may be use boolean instead
				
				anim.scaleX = -1;
				anim.x = anim.width + 280;
				anim.y = -anim.height;
				
				if(flagB){
					flagB.scaleX = -1;
					flagB.x = anim.x - 40 ;
					flagB.y = -140;
				}
				lampSp.x = _sW - _houseMovePointsVec[0].x;
				lampSp.y = _houseMovePointsVec[0].y;// TODO:mb use outside
				
			} else {
				
				anim.x = -anim.width - 280;
				anim.y = -anim.height;		
				
				if(flagB){
					flagB.x = anim.x + 40 ;
					flagB.y = -140;
				}
				
				lampSp.x = _houseMovePointsVec[0].x; // TODO:mb use outside
				lampSp.y = _houseMovePointsVec[0].y;
			}
			
			
			return lampSp;
			
		}
		
		
		
		
		
		private function _moveCarHandler(e:KeyboardEvent):void {
			if (_isPaused) return;
			
			var xTo:int;
			
			_car.y = CAR_DEF_Y;
			_car.alpha = 1;
			if (e.keyCode == 37 && _carPosIndex > 0) { // Check11
				
				_carPosIndex--;
				
				TweenLite.killTweensOf(_car);
				xTo = (_carPosIndex == 1) ? (_sW >> 1) 
										  : (_sW >> 1) - CAR_STEP;
				TweenLite.to(_car, 0.3, { x:xTo } );
			}
			
			if (e.keyCode == 39 && _carPosIndex < 2) {
				
				_carPosIndex++;
				
				TweenLite.killTweensOf(_car);
				xTo = (_carPosIndex == 1) ? (_sW >> 1) 
										  : (_sW >> 1) + CAR_STEP; 
				TweenLite.to(_car, 0.3, { x:xTo } );
			}
			
		}
		
		
		
		
		
		
		private function _controlTweens(e:MouseEvent):void {
			
			Sprite(e.currentTarget).removeEventListener(MouseEvent.CLICK, _controlTweens);
			TweenLite.delayedCall(1.5, function ():void { _pauseBtn.addEventListener(MouseEvent.CLICK, _controlTweens) });
			
			
			_isPaused = !_isPaused;
			
			if (_isPaused) {
				
				_pauseBtn.play_btn.visible = true;
				_pauseBtn.pause_btn.visible = false;
				_houseGenerateTimer.stop();
				_lampGenerateTimer.stop();
				
				_dashed.paused.visible = true;
				_dashed.getChildAt(2).visible = false;
				//_dashed.r
				_hatchTimer.stop();
				
				for each (var tw:Object in _objectsTweensDic) {
					TweenLite(tw).pause();
				}
				
			} else {
				
				_pauseBtn.play_btn.visible = false;
				_pauseBtn.pause_btn.visible = true;
				
				_houseGenerateTimer.start();
				_lampGenerateTimer.start();
				
				_dashed.paused.visible = false;
				_dashed.getChildAt(2).visible = true;
				
				_hatchTimer.start();
				
				for each (var tw1:Object in _objectsTweensDic) {
					TweenLite(tw1).play();
				}
				
			}
		}
		
		
		
		private function _updateCathcedText(num:uint):void {
			
			var totalStr:String = _toysNum.toString() +'/' + MAX_TOYS_CATCHED.toString()
			TextField(_catchedToysSp.getChildByName('numTxt')).text = totalStr;
			
			var tform1:TextFormat = new TextFormat();
			tform1.color = Math.random() * 0xFFFFFF;
			if(totalStr.indexOf('/') == 1 ) {
				TextField(_catchedToysSp.getChildByName('numTxt')).setTextFormat(tform1, 0, 1);
			} else {
				TextField(_catchedToysSp.getChildByName('numTxt')).setTextFormat(tform1, 0, 2);
			}
			var len:uint = TextField(_catchedToysSp.getChildByName('numTxt')).text.length;
			var tform2:TextFormat = new TextFormat();
			tform2.color = 0xFF2894;
			TextField(_catchedToysSp.getChildByName('numTxt')).setTextFormat(tform2, len-2,len );
		}
		
		
		
		
		private function _checkTotalCatchedToys(incTotal:Boolean):void {
			
			//TODO: check!!!!
			if (incTotal) {
				
				_toysNum ++;
				if (_toysNum == MAX_TOYS_CATCHED)  {
					
					_houseGenerateTimer.stop();
					_lampGenerateTimer.stop();
					//_dashed.reset();
					_hatchTimer.stop();
					_toysNum = 0;
					
					for each (var tw:Object in _objectsTweensDic) {
						//TweenLite(tw).pause();
					}
					
					dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_FINAL, true, { } ));
					//_fonSnd.close()
					_sndFonChanel.stop();
					
				}
				_updateCathcedText(_toysNum);
				
			} else {
				if (_toysNum != 0) {
					_toysNum--;
					_updateCathcedText(_toysNum)
				} 
				
			}
			
			
			_treeToy1.visible = (_toysNum > 2);
			 _treeToy1.rotation = -30 +  Math.round(60*Math.random())
			_treeToy2.visible = (_toysNum > 5);
			_treeToy2.rotation = -30 +  Math.round(60*Math.random())
			_treeToy3.visible = (_toysNum > 7);
			_treeToy3.rotation = -30 +  Math.round(60*Math.random())
			
		}
		
		
		
		/*
		Хрупкий груз – ничего не поделаешь
		Ну не мешки с картошкой везешь
		Эх, а такая красивая елка могла получиться!
		Смотри на дорогу!
		А из окна сейчас вылетит птичка
		И кто тебе только права выдал..
		Заходи ко мне на огонек
		Не зевай
		Подарки купил?
		Как обычно, в баню?
		Жду Деда Мороза
		А я еду на Бали
		Дорогу замело
		Куда ж ты едешь?
		На летней резине что ли?
		Сне-гу-ро-чка!
		Шары то стеклянные!
		Где твои олени?
		Ох, зажжем!
		Классная елка!
		А я мандарины вешаю
		Иголки за собой убери
		Санта Клаус - мой кумир!
		Не спи - замерзнешь!
		Ой, уже зима что ли?
		Да брось, конец света же!
		Не пей за рулем!
		Замерз?
		Ты уже в спячке что ли?
		Ой! Мимо.
		Не поймал-не поймал!
		На дорогу смотри
		Заходи на огонек
		*/
		
		
			/*	private function _getHouse(type:String):Sprite {
			
			var houseSp:Sprite = new Sprite();
			
			var bmd:BitmapData;
			var houseB:Bitmap;
			var colorTypeIndex:uint = 1 + Math.floor(3 * Math.random());
			
			switch (colorTypeIndex) { // выбор цвета дома
				
				case 1:
					bmd = new House_1();
				break;
				
				case 2:
					bmd = new House_2();
				break;
				
				case 3:
					bmd = new House_3();
				break;
			}
			
			
			houseB = new Bitmap(bmd);
			houseB.name = 'bitmap';
			houseB.smoothing = true;
			houseSp.addChild(houseB);
			
			

			var windowType:uint = Math.floor(3 * Math.random());
			var p:Point = _windowsVec[windowType];
			var ava:Friend = new Friend();  //TODO: delete from memory onComplete
			ava.gotoAndStop(1 + Math.floor(6 * Math.random()));
			ava.name = 'ava';
			ava.y = p.y;
			//ava.rotationY = 30;
			houseSp.addChild(ava);
			
			
			if (type == 'left') {  //TODO: may be use boolean instead
				
				ava.x = -p.x - ava.width;
				
				houseB.scaleX = -1;
				houseB.x =  houseB.width;
				houseB.y = -houseB.height;
				
				houseSp.rotation = -10 * Math.random() - 5;
				houseSp.x = _sW - _houseMovePointsVec[0].x; // move symmetrically
				houseSp.y = _houseMovePointsVec[0].y;
				
			} else {
				
				ava.x = p.x;
				
				//houseB.scaleX = 1.3;
				houseB.x = -houseB.width;
				houseB.y = -houseB.height;		
				
				houseSp.rotation = 10 * Math.random() +5;
				houseSp.x = _houseMovePointsVec[0].x; 
				houseSp.y = _houseMovePointsVec[0].y;
				
			}
			
			
			var delayThrowTime:Number = 1.5 + 0.5 * Math.floor(3 * Math.random());
			
			if (delayThrowTime > 1.5) {
				//TweenLite.delayedCall(delayThrowTime, _throwToy, [houseSp]);
			}
			
			
			return houseSp;
			
		}
		*/
		
	}

}