package net.presentationpanda.examples.content.stockQuote
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import net.presentationpanda.sdk.controller.loaders.IXMLLoader;
	import net.presentationpanda.sdk.controller.tools.ITools;
	import net.presentationpanda.sdk.model.plugins.content.BaseContentElement;
	import net.presentationpanda.sdk.model.plugins.content.IDisplayObjectController;
	import net.presentationpanda.sdk.model.plugins.content.IEditorContentPlugin;
	
	final public class ContentElement extends BaseContentElement
	{
		private var _params:ParamsHolder;
		private var _gui:LibStockQuote; // from the assets.swc
		private var _dataLoader:IXMLLoader;
		private var _nTimeout:Number;
		private var _bPlaying:Boolean=false;
		
		public function ContentElement(ID:String, plugin:IEditorContentPlugin, tools:ITools, displayObjectController:IDisplayObjectController=null)
		{
			super(this, ID, plugin, tools, displayObjectController);
			init();
		}
		
		/**
		 * Make it a habit to move as much code as possible away from the constructor into a helper function.
		 * Your code will execute faster (the AS3 compiler can't optimize constructor code).
		 */
		private function init():void {
			_params=new ParamsHolder();
			
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
			if(_dataLoader) _dataLoader.dispose(true);
			
			// note how the _dataLoader will call onLoadComplete/onLoadProgress/onLoadError!
			// see also the documentation for com.greensock.loading.XMLLoader
			_dataLoader=tools.create.xmlLoader("http://www.webservicex.net/stockquote.asmx/GetQuote?symbol="+_params.sSymbol,{onComplete:onLoadComplete, onProgress: onLoadProgress, onFail:onLoadError, format:"text"});
			_dataLoader.load();
		}
		
		override public function onLoadComplete(e:Event=null):void {
			if(!_dataLoader.content) {
				// try loading again in 10 seconds if the presentation is playing
				if(_bPlaying) _nTimeout=setTimeout(triggerLoad,10000);
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
			if(_bPlaying) _nTimeout=setTimeout(triggerLoad,10000);
			
			// VERY VERY important to call the super function!
			super.onLoadComplete();
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
		 * @return The plugin Parameters
		 */
		override public function get params():* {
			return _params;
		}
		
		/**
		 * Loads/sets all plugin parameters at once.
		 * @param value an instance of the params class for this plugin
		 */
		override public function set params(value:*):void {
			if( value is ParamsHolder)
				_params=value;
			else
				_params=new ParamsHolder();
			
			// now set the symbol
			setSymbol(_params.sSymbol);
		}
		
		
		/**
		 * Called before the slide plays.
		 */
		override public function onSlideStart(e:Event=null):void {
			_bPlaying=true;
			triggerLoad();
		}
		
		/**
		 * Called after the slide stops.
		 */
		override public function onSlideStop(e:Event=null):void {
			_bPlaying=false;
			clearTimeout(_nTimeout);
		}
		
		/**
		 * This function is meant to return a meaningful string to identify this
		 * plugin and its content from outside the presentation.
		 * e.g. the text of a textfield or the kind of shape in case it is a shape
		 * @return the description
		 */
		override public function getSearchText():String {
			return "Stock Quote: "+_params.sSymbol;
		}
		
		
		/**
		 * This one is VERY important. This function is called when the item is deleted from the
		 * presentation. Use it to stop data transfers and free up memory.
		 * Please make sure to ALWAYS call the super.destroy(e) function!!
		 * @param e
		 */
		override public function destroy(e:Event=null):void {
			if(_dataLoader) _dataLoader.dispose(true);
			super.destroy(e);
		}
	}
}