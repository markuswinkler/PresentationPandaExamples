package net.presentationpanda.examples.content.stockQuote
{
	import net.presentationpanda.lib.model.plugins.content.BaseContentPlugin;
	
	public class main extends BaseContentPlugin
	{
		// You need at least one reference to the ContentElement/ToolbarView/ToolbarEditModeView/OptionDialogueView/Params class
		// to embed it into your plugin. Otherwise it gets "optimized" away by the compiler
		private var embedHelperToolbar:ToolbarView;
		private var embedHelperContentElement:ContentElement;

		public function main()
		{
			super(new LibPluginIcon(), new LibPluginCursor());
			
			// Default width of the plugin
			_iDefaultWidth=252;
			
			// Default height of the plugin
			_iDefaultHeight=252;
			
			// Lock the aspect ratio for new ContentElements?
			_bDefaultLockAspectRatio=true;

			/*******************************************************************************
			 * Register classes to enable save/load of params
			 * If you use any data types besides int/Number/String make sure
			 * to register them too with registerClassAlias.
			 * e.g.
			 *	registerClassAlias("flash.geom.Point", Point);
			 *  registerClassAlias("flash.geom.Matrix", Matrix);
			 ******************************************************************************/
//			registerClassAlias("net.presentationpanda.plugins.content.stockQuote.ParamsHolder", Params);
			
			/*******************************************************************************
			 * Add some documentation to your custom classes so other developers can use
			 * it more easily.
			 * addDoc(funcName, Description, Parameters [ [Name, Description (optional), Default Value (optional)], ... ] 
			 ******************************************************************************/
			addDoc("setSymbol","Sets the symbol for the stock ticker, e.g. AAPL",[["symbol","The symbol to be set, e.g. AAPL"]]);
		}
	}
}