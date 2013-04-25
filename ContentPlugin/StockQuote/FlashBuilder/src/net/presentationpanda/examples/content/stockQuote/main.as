package net.presentationpanda.examples.content.stockQuote
{
	import flash.net.registerClassAlias;
	
	import net.presentationpanda.sdk.model.plugins.content.BaseContentPlugin;
	
	public class main extends BaseContentPlugin
	{
		public function main()
		{
			super(ContentElement, new LibPluginIcon(), new LibPluginCursor());
			
			/*******************************************************************************
			 *	INIT Block - Set all the default values for the plugin here
			 ******************************************************************************/
			// Default width of the plugin
			_iDefaultWidth=252;
			
			// Default height of the plugin
			_iDefaultHeight=252;
			
			// Lock the aspect ratio for new ContentElements?
			_bDefaultLockAspectRatio=true;

			// Sets the optional toolbar class. The toolbar class must be extended from BaseToolbarView
			// and must have the same base class path as this main class for security reasons.
			_toolbarClass=ToolbarView;
			
			/*******************************************************************************
			 * Register classes to enable save/load of params
			 * If you use any data types besides int/Number/String make sure
			 * to register them too with registerClassAlias.
			 * e.g.
			 *	registerClassAlias("flash.geom.Point", Point);
			 *  registerClassAlias("flash.geom.Matrix", Matrix);
			 ******************************************************************************/
			registerClassAlias("net.presentationpanda.plugins.content.stockQuote.ParamsHolder", ParamsHolder);
			
			/*******************************************************************************
			 * Add some documentation to your custom classes so other developers can use
			 * it more easily.
			 * asDoc(funcName, Description, Parameters [ [Name, Description (optional), Default Value (optional)], ... ] 
			 ******************************************************************************/
			addDoc("setSymbol","Sets the symbol for the stock ticker, e.g. AAPL",[["symbol","The symbol to be set, e.g. AAPL"]]);
		}
	}
}