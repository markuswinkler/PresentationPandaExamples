package net.presentationpanda.examples.content.talking
{
	import net.presentationpanda.sdk.model.plugins.ActivationType;
	import net.presentationpanda.sdk.model.plugins.content.BaseContentPlugin;
	
	public class main extends BaseContentPlugin
	{
		public function main() {
			super(ContentElement, new LibPluginIcon(), new LibPluginCursor());

			/*******************************************************************************
			 *	INIT Block - Set all the default values for the plugin here
			 ******************************************************************************/
			_bDefaultHasPlay=true;
			_iDefaultPreferredActivation=ActivationType.AFTER_PREVIOUS;

			_iDefaultWidth=115;
			_iDefaultHeight=115;
			_bDefaultLockAspectRatio=true;
		}
	}
}