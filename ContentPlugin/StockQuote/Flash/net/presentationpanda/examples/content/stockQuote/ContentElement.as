package net.presentationpanda.examples.content.stockQuote
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import net.presentationpanda.lib.controller.loaders.IXMLLoader;
	import net.presentationpanda.lib.model.plugins.content.BaseContentElement;
	import net.presentationpanda.lib.model.plugins.content.IDisplayObjectController;
	import net.presentationpanda.lib.model.plugins.content.IEditorContentPlugin;
	
	final public class ContentElement extends BaseContentElement
	{
		private var _params:Params;
		private var _gui:LibStockQuote; // from the assets.swc
		private var _dataLoader:IXMLLoader;
		private var _nTimeout:Number;
		
		public function ContentElement(ID:String, plugin:IEditorContentPlugin, displayObjectController:IDisplayObjectController=null)
		{
			super(this, ID, plugin, displayObjectController);
			init();
		}
		
		/**
		 * Make it a habit to move as much code as possible away from the constructor into a helper function.
		 * Your code will execute faster (the AS3 compiler can't optimize constructor code).
		 */
		private function init():void {
			_params=new Params();

			// Point the MonsterDebugger to this plugin.
			// Use this line in your plugin ONLY during debugging and remove it before you upload it to the server
			MonsterDebugger.inspect(this);
			
			// this is the movieclip symbol for display
			_gui=new LibStockQuote();
			displayObjectController.setDisplayObject(_gui, _gui.contentMask.width, _gui.contentMask.height);
		}
		
		/*******************************************************************************
		 *	LOAD Functions
		 ******************************************************************************/
		
		/**
		 * This function is called when the plugin is loaded
		 */
		override public function onLoad():void {
			// set the stock ticker symbol on the canvas
			_gui.stockSymbol.text=_params.sSymbol;
			
			// unload an existing dataloader
			if(_dataLoader) _dataLoader.destroy();
			
			// note how the _dataLoader will call onLoadComplete/onLoadProgress/onLoadError!
			// see also the documentation for com.greensock.loading.XMLLoader
			_dataLoader=loadManager.add_XML("http://www.webservicex.net/stockquote.asmx/GetQuote?symbol="+_params.sSymbol,{onComplete:onLoadComplete, onProgress: onLoadProgress, onFail:onLoadError, format:"text"});
		}
		
		private function onLoadComplete(e:Event=null):void {
			if(!_dataLoader.content) {
				// try loading again in 10 seconds if the presentation is playing
				if(isSlidePlaying) _nTimeout=setTimeout(triggerLoad,10000);
				return;
			}
			var xml_source:XML=_dataLoader.content;
			var xml:XML = new XML(xml_source.toString());
			
			var xmldata:XML;
			for each (xmldata in xml.*) {
				_gui.stockSymbol.text=xmldata.Symbol;
				_gui.stockName.text=xmldata.Name;
				_gui.tradeTime.text="( "+xmldata.Date+" , "+xmldata.Time+" )";
				
				var nChange:Number=parseFloat(xmldata.Change);
				var sChange:String="";
				if(nChange>0) sChange="<font size='-13'><font color='#00BB00'> (+"+nChange.toFixed(2)+")</font></font>";
				if(nChange==0) sChange="<font size='-13'> ("+nChange.toFixed(2)+"</font>)</font>";
				if(nChange<0) sChange="<font size='-13'><font color='#AA0000'> ("+nChange.toFixed(2)+")</font></font>";
				
				_gui.lastTrade.htmlText=""+digits(xmldata.Last)+" "+sChange;
				
				_gui.prevClose.text=""+digits(xmldata.PreviousClose);
				_gui.high.text=""+digits(xmldata.High);
				_gui.low.text=""+digits(xmldata.Low);
			}
			
			// load a new value every 10 seconds
			if(isSlidePlaying) _nTimeout=setTimeout(triggerLoad,10000);
		}
		
		
		/*******************************************************************************
		 *	Plugin Functions
		 ******************************************************************************/
		
		/**
		 * Helper function to be able to set the ticker symbol from outside, e.g. the plugin toolbar.
		 * @param value The ticker symbol
		 */
		public function setSymbol(value:String):void {
			_params.sSymbol=value.toUpperCase();
			triggerLoad();
		}
		
		/**
		 * Internal helper function to truncate a Number.
		 */
		private function digits(oNumber:String):String {
			var n:Number=Math.floor(parseFloat(oNumber)*100)/100;
			return Number(parseFloat(oNumber)).toFixed(2);
		}
		
		/*******************************************************************************
		 *	SDK functions
		 ******************************************************************************/
		
		/**
		 * The plugin Parameters
		 */
		override public function get params():* {
			return _params;
		}
		
		/**
		 * Loads/sets all plugin parameters at once.
		 */
		override public function set params(value:*):void {
			if( value is Params)
				_params=value;
			else
				_params=new Params();
			
			// now set the symbol
			setSymbol(_params.sSymbol);
		}
		
		
		/**
		 * Called before the slide plays.
		 */
		override protected function onSlideStart():void {
			// update the stock ticker
			triggerLoad();
		}
		
		/**
		 * Called after the slide stops.
		 */
		override protected function onSlideStop():void {
			clearTimeout(_nTimeout);
		}
		
		/**
		 * This function is meant to return a meaningful string to identify this
		 * plugin and its content from outside the presentation.
		 * e.g. the text of a textfield or the kind of shape in case it is a shape
		 * @return the description
		 */
//		override public function getSearchText():String {
//			return "Stock Quote: "+_params.sSymbol;
//		}
		
		
		/**
		 * This one is VERY important. This function is called when the item is deleted from the
		 * presentation. Use it to stop data transfers and free up memory.
		 * Please make sure to ALWAYS call the super.destroy(e) function!!
		 * @param e
		 */
		override public function destroy(e:Event=null):void {
			// we don't have to destroy it, the loadManager will take care of that.
			// Just set variables and such to null to ease the work for the garbage collector.
			_dataLoader=null; 
			
			// just to be on the safe side
			clearTimeout(_nTimeout);
			
			super.destroy(e);
		}
	}
}
