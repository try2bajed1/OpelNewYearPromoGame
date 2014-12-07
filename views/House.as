package views {
	import com.greensock.TweenLite;
	import events.DropItemEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author me
	 */
	
	public class House extends Sprite {
		
		private var _dataProvider:Array;
		private var _isRight:Boolean
		private var _dropIndex:int = -1;
		
		private var _bcgW:uint;
		private static var _windowsVec:Vector.<Point> =  Vector.<Point>([new Point( -265, -445),
																		 new Point( -265, -305),
																		 new Point( -265, -170)]);
		
		
		public function House(isRightSide:Boolean, windowsDP:Array) {
			
			_dataProvider = windowsDP;
			_isRight = isRightSide;
			
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
			addChild(houseB);
			_bcgW = Math.floor(houseB.width);
			
			
			var windowType:uint = Math.floor(3 * Math.random());
			var p:Point = _windowsVec[windowType];
		
			
			if (_isRight) {
				//ava.x = p.x;
				houseB.x = -_bcgW;
				houseB.y = -houseB.height;		
				
			} else {
				
				//ava.x = -p.x - ava.width;
				
				houseB.scaleX = -1;
				houseB.x = _bcgW;
				houseB.y = -houseB.height;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		
		
		
		private function onAdd(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			_addWindows(_dataProvider);
		}
		
		
		
		
		private function _addWindows(dataProvider:Array):void {
			
			var defBcgBD:BitmapData = new Window_def() as BitmapData;
			
			for (var i:int = 0; i < dataProvider.length; i++) {
					
					// для любого типа рисуем подложку в виде подоконника
					var windBcg:Bitmap = new Bitmap(defBcgBD)
					windBcg.smoothing = true;
					windBcg.x = _isRight ? _windowsVec[i].x :  - _windowsVec[i].x - windBcg.width;
					windBcg.y = _windowsVec[i].y;
					addChild(windBcg);
				
				if (dataProvider[i] is uint) { // в окне занавески
					var bmd:BitmapData;
					var randomCurtainIndex:uint = Math.floor(3 * Math.random());
					if (randomCurtainIndex == 0) bmd = new Curtain1();
					if (randomCurtainIndex == 1) bmd = new Curtain2();
					if (randomCurtainIndex == 2) bmd = new Curtain3();
					var curtB:Bitmap = new Bitmap(bmd);
					curtB.smoothing = true;
					curtB.x = _isRight ?  _windowsVec[i].x + 10
									   : -_windowsVec[i].x - 10 - curtB.width;
					curtB.y = _windowsVec[i].y + 5;
					addChild(curtB)
				}
				
				
				if (dataProvider[i] is Array) { // если в окне говорящий, то в массиве передаем битмапдата и строку
					var faceBmd:BitmapData = dataProvider[i][0];
					var faceB:Bitmap = new Bitmap(faceBmd);
					faceB.smoothing = true;
					faceB.x = (_isRight) ?  _windowsVec[i].x + 15
										 : -_windowsVec[i].x - faceB.width - 15;
					faceB.y = _windowsVec[i].y + 5;
					addChild(faceB);
					
					var txtBox:Sprite;
					
					if(_isRight) {
						txtBox = new RightTextBox() as Sprite;
						txtBox.x = faceB.x +20;
						TextField(txtBox.getChildByName('txt')).autoSize = TextFieldAutoSize.RIGHT;
					} else {
						txtBox = new LeftTextBox() as Sprite;
						txtBox.x = faceB.x + faceB.width - 20;
						TextField(txtBox.getChildByName('txt')).autoSize = TextFieldAutoSize.LEFT;
					}
					
					addChild(txtBox);
					txtBox.y = faceB.y + 50;
					txtBox.visible = false;
					setRandomTextColor(TextField(txtBox.getChildByName('txt')), dataProvider[i][1]);
					
					txtBox.getChildByName('bcg').width = TextField(txtBox.getChildByName('txt')).width + 10;
					
					var rand:Number = Math.random(); // регулируем количество говорящих.
					if(rand > 0.6) {
						var sayDelayTime:Number =  1 + 0.5 * Math.floor(5 * Math.random());
						TweenLite.delayedCall(sayDelayTime, showText, [txtBox]);
					}
					
				}
				
				
				
				
				if (_dataProvider[i] is BitmapData) { // если в окне кидающий
					
					_dropIndex = i;
					
					var handData:Hand = new Hand();
					var handB:Bitmap = new Bitmap(handData)
					handB.visible = false;
					
					if (_isRight) {
						handB.x = _windowsVec[i].x ;
						handB.y = _windowsVec[i].y + 30;
						handB.rotation = -30;
					} else {
						handB.scaleX = -1;
						handB.x = -_windowsVec[i].x - 30;
						handB.y =  _windowsVec[i].y + 30;
						handB.rotation = 30;
					}
					
					
					addChild(handB);					
					
					var faceBmd2:BitmapData = dataProvider[i];
					var faceB2:Bitmap = new Bitmap(faceBmd2);
					faceB2.smoothing = true;
					faceB2.x = (_isRight) ?  _windowsVec[i].x + 15
										  : -_windowsVec[i].x - faceB2.width - 15;
					faceB2.y = _windowsVec[i].y + 5;
					addChild(faceB2);
					
					
					//var rand2:Number = Math.random(); // регулируем число кидающих
					//if (rand2 > 0.3) {
						var dropDelayTime:Number =   2 + 0.5 * Math.floor(3 * Math.random());
						TweenLite.delayedCall(dropDelayTime, _startDropAnimation,[handB,faceB2]);
					//}
					
				}
				
			}
			
		}
		
		
		
		
		private function _startDropAnimation(hand:Bitmap, photo:Bitmap):void {
			
			hand.visible = true;
			
			if (_isRight) {
				
				TweenLite.to( hand,  0.5, { x:'-20', y: '-30',  onComplete:_rewindAndDispatch, onCompleteParams:[hand, photo] } );
				//TweenLite.to(photo, 0.5, {x:'20', rotationY: -30 } );
				TweenLite.to(photo, 0.5, { rotationY: -30 } );
				
			} else {
				
				TweenLite.to(hand,  0.5, { x:'50', y:'0' ,    onComplete:_rewindAndDispatch, onCompleteParams:[hand, photo] } );
				//TweenLite.to(photo, 0.5, { x:'20', rotationY: 30 } );
				TweenLite.to(photo, 0.5, {  rotationY: -30 } );
			}
			
		}
		
		
		
		
		private function _rewindAndDispatch(hand:Bitmap, photo:Bitmap):void {
			
			//TweenLite.to(photo, 0.5, { x:'-20', rotationY: 0 } );
			TweenLite.to(photo, 0.5, {  rotationY: 0 ,rotationX:0 } );
			TweenLite.delayedCall(1,function ():void {hand.visible = false;	})
			
			var pFrom:Point = (_isRight) ? this.localToGlobal(new Point( _windowsVec[_dropIndex].x , _windowsVec[_dropIndex].y ) )
										 : this.localToGlobal(new Point(- _windowsVec[_dropIndex].x , _windowsVec[_dropIndex].y) )
			
			dispatchEvent(new DropItemEvent(DropItemEvent.START_DROP, true, pFrom));
		}
		
		
		private var _colorsTextVec:Vector.<uint> = Vector.<uint>([0xFF0000, 0x00BF00, 0x0000FF, 0x008040, 0xEC20D8, 0x012EB1, 0xFF0080, 0xCE7831, 0x8F0E76, 0x257860, 0x097AC6, 0x00974B, 0xA455A6, 0xE45916, 0xF89603]);
		
		private function setRandomTextColor(tf:TextField, strText:String):void {
			
			tf.text = strText;
			var tFormat:TextFormat = new TextFormat();
			
			var len:uint = strText.length;
			for (var i:int = 0; i < len; i++) {
				var randIndex:uint = Math.floor(_colorsTextVec.length * Math.random());
				tFormat.color = _colorsTextVec[randIndex] 
				tf.setTextFormat(tFormat, i);
			}
		}
		
		
		
		private function showText(textBox:Sprite):void {
			
			textBox.visible = true;
			TweenLite.delayedCall(1.5, function ():void { textBox.visible = false } );
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}

}