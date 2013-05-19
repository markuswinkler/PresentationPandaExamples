package net.presentationpanda.examples.content.stockQuote
{
	import flash.events.Event;
	
	import net.presentationpanda.sdk.controller.tools.ITools;
	import net.presentationpanda.sdk.support.events.StringEvent;
	import net.presentationpanda.sdk.view.BaseToolbarView;
	import net.presentationpanda.sdk.view.ui.IUIInputField;
	
	/**
	 * This toolbar holds all input fields for this plugin.
	 */
	public class ToolbarView extends BaseToolbarView
	{
		private var _symbol:IUIInputField; // helper variable to access the symbol input field in updateToolbar

		public function ToolbarView(tools:ITools)
		{
			super(tools);
		}
		
		
		/**
		 * This function is called only once when the toolbar is added to the stage.
		 * Place all your init code here.
		 */
		override public function onFirstAddedToStage():void {
			// create params instance to get defaults
			var params:ParamsHolder=new ParamsHolder();
			
			// create input field
			_symbol=tools.create.UI.InputField("Symbol:",params.sSymbol);
			addMetaEventListener(_symbol,Event.CHANGE,onChangeSymbol);
			// add input field to the toolbar
			addElement(_symbol,"Change Stock Symbol");
			
			// arrange the buttons on the toolbar, always call last
			arrange();
		}
		

		/**
		 * This function is called when a content element is selected to update itself
		 * with the current values of the content element.
		 * e.g. switching between two stockquotes will change the content on the input field
		 *      accordingly.
		 */
		override public function updateToolbar():void {
			// gets the first selected element and exit in the rare case it's not the correct contentelement
			var ce:ContentElement=tools.system.selectedItems.next();
			if(!ce) return;
			
			// get the parameters from the selected content element and assign them to the toolbar elements
			var params:ParamsHolder=ce.params;
			_symbol.value=params.sSymbol;
		}

		
		/**
		 * This function is called when the value of the input field changes.
		 * The listener for it is added in onFirstAddedToStage.
		 */
		private function onChangeSymbol(e:StringEvent):void {
			// this 3 lines are needed by the framework, don't remove!
			// just copy & paste those to your own plugin
			if(_bUpdateToolbar) return;
			var ce:ContentElement=tools.system.selectedItems.next();
			if(!ce) return;

			// always use this syntax to set parameters in the content element!
			// This is required to integrate into the undo/redo stack.
			tools.commands.contentElement.setParam(ce,ce.setSymbol,e.string,"Change Symbol",e.string);
		}
		
		
	}
}