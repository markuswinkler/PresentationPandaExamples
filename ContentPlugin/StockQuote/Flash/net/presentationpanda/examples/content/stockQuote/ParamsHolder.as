package net.presentationpanda.examples.content.stockQuote
{
	/**
	 * Helper class to save/load the parameter for this plugin.
	 * Only public variables can be saved/loaded and they must have a default value.
	 * If you use any data types besides int/Number/String make sure
	 * to register them too with registerClassAlias in main.as.
	 * e.g.
	 *	registerClassAlias("flash.geom.Point", Point);
	 *  registerClassAlias("flash.geom.Matrix", Matrix);
	 */
	public class ParamsHolder
	{
		public var sSymbol:String="AAPL"; // Added "AAPL" as default ticker symbol.
	}
}