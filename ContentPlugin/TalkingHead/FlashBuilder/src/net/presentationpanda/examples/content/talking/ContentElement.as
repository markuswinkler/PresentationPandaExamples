package net.presentationpanda.examples.content.talking
{
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	
	import net.presentationpanda.sdk.controller.tools.ITools;
	import net.presentationpanda.sdk.model.plugins.content.BaseContentElement;
	import net.presentationpanda.sdk.model.plugins.content.IDisplayObjectController;
	import net.presentationpanda.sdk.model.plugins.content.IEditorContentPlugin;
	
	final public class ContentElement extends BaseContentElement
	{
		private var _mic:Microphone;
		private var _head:LibHead;

		public function ContentElement(ID:String, plugin:IEditorContentPlugin, tools:ITools, displayObjectController:IDisplayObjectController=null)
		{
			super(this, ID, plugin, tools, displayObjectController);
			init();
		}
		
		private function init():void {
			//	Get the head from the library, stop all animations and set it as displayObject
			_head=new LibHead();
			_head.leftEye.stop();
			_head.rightEye.stop();

			displayObjectController.setDisplayObject(_head);

			// Init the microphone
			_mic = Microphone.getMicrophone(); 
			_mic.gain = 70; 
			_mic.rate = 11; 
			_mic.setUseEchoSuppression(true);
			_mic.setSilenceLevel(5, 1000);
			
			addMetaEventListener(_mic, StatusEvent.STATUS, onMicStatus); 

			// Uncomment this line to listen to debug info about your mic
//			addMetaEventListener(_mic, ActivityEvent.ACTIVITY, onMicActivity); 

			// Uncomment these lines to get info about your microphone
//			var micDetails:String = "Sound input device name: " + _mic.name + '\n'; 
//			micDetails += "Gain: " + _mic.gain + '\n'; 
//			micDetails += "Rate: " + _mic.rate + " kHz" + '\n'; 
//			micDetails += "Muted: " + _mic.muted + '\n'; 
//			micDetails += "Silence level: " + _mic.silenceLevel + '\n'; 
//			micDetails += "Silence timeout: " + _mic.silenceTimeout + '\n'; 
//			micDetails += "Echo suppression: " + _mic.useEchoSuppression + '\n'; 
//			trace(micDetails);
		}
		
		private function onMicActivity(event:ActivityEvent):void 
		{ 
			// This function is only used for debugging in this example.
			trace("activating=" + event.activating + ", activityLevel=" +  _mic.activityLevel);
		} 
		
		private function onMicStatus(event:StatusEvent):void 
		{ 
			switch(event.code) {
				case "Microphone.Unmuted":
					// Microphone access was allowed
					hideErrorDisplay();
					break;
				case "Microphone.Muted":
					// Microphone access was denied
					showErrorDisplay();
					break;
				default:
					//trace("status: level=" + event.level + ", code=" + event.code); 
			}
		}
		
		override protected function onPlay():void {
			// required to get the level
			_mic.setLoopBack(true);
			
			// set the output volume to 0 so you don't hear yourself
			var transform1:SoundTransform = _mic.soundTransform;
			transform1.volume = 0;
			_mic.soundTransform = transform1;
			
			// check the volume on ENTER_FRAME and adjust the animation accordingly
			addMetaEventListener(displayObjectController.displayObject, Event.ENTER_FRAME, checkVolume);
			
			// init the animation so that the left and right eye are different.
			// gives it a slightly wacky look
			var iEye:int=Math.random()*_head.leftEye.totalFrames;
			_head.leftEye.gotoAndPlay(iEye);
			_head.rightEye.gotoAndPlay(iEye+2);
		}
		
		private function checkVolume(e:Event):void {
			// number of frames in the mouth animation
			var framesInMouth:Number = _head.totalFrames; 

			// set this to make the mouth open further if 
			// the volume of your audio is a little low
			var mouthMultiplier:Number = 3;
			
			// find a frame in the animation that corresponds to the volume
			var mouthFrame:int = Math.ceil(_mic.activityLevel * _head.totalFrames * 0.01);
			mouthFrame = Math.ceil(mouthFrame * mouthMultiplier);
			
			// set a maximum
			if (mouthFrame > _head.totalFrames) mouthFrame = _head.totalFrames;
			_head.gotoAndStop(mouthFrame);
		}
		

		
		override protected function onStop():void {
			// stop checking for the volume
			removeMetaEventListener(displayObjectController.displayObject, Event.ENTER_FRAME, checkVolume);
			
			// reset animation
			_head.gotoAndStop(1);
			_head.leftEye.gotoAndStop(1);
			_head.rightEye.gotoAndStop(1);
		}
		
		override public function getSearchText():String {
			return "Talking Head";
		}
	}
}