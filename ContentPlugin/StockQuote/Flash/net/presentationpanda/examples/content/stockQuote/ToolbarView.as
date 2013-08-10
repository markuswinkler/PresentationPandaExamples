package net.presentationpanda.examples.content.stockQuote
{
	import flash.events.Event;
	
	import net.presentationpanda.lib.events.StringEvent;
	import net.presentationpanda.lib.view.plugins.content.BaseContentPluginToolbarView;
	import net.presentationpanda.lib.view.ui.IUIInputField;
	
	/**
	 * This toolbar holds all input fields for this plugin.
	 */
	public class ToolbarView extends BaseContentPluginToolbarView
	{
		// helper variable to access the symbol input field in updateToolbar
		private var _symbol:IUIInputField; 
		
		public function ToolbarView(contentElementClass:Class)
		{
			super(contentElementClass);
		}
		
		override protected function onInit():void {
			// create input field
			_symbol=tools.create.UI.InputField("Symbol:","","Change Stock Symbol, e.g. AAPL");
			
			// listen to a change of the value
			addMetaEventListener(_symbol,Event.CHANGE,onChangeSymbol);
			
			// add input field to the toolbar
			addElement(_symbol);
		}
		
		
		/**
		 * This function is called when a content element is selected to update itself
		 * with the current values of the content element.
		 * e.g. switching between two stockquotes will change the content on the input field
		 *      accordingly.
		 */
		override protected function onUpdate():void {
			// Always retrieve and check like this.
			var ce:ContentElement=getSelected();
			
			var params:Params=ce.params;
			_symbol.value=params.sSymbol;
		}
		
		
		/**
		 * This function is called when the value of the input field changes.
		 */
		private function onChangeSymbol(e:StringEvent):void {
			var aItem:Array=getSelectedElements();
			if(aItem.length==0) return;
			
			setParam("setSymbol", e.string,"Change Symbol",e.string);
		}
	}
}
