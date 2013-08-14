package net.presentationpanda.examples.content.talking
{
	import net.presentationpanda.lib.model.plugins.ActivationType;
	import net.presentationpanda.lib.model.plugins.content.BaseContentPlugin;
	
	public class main extends BaseContentPlugin
	{
		// You need at least one reference to the ContentElement/ToolbarView/ToolbarEditModeView/OptionDialogueView/Params class
		// to embed it into your plugin. Otherwise it gets "optimized" away by the compiler
		private var embedHelperContentElement:ContentElement;

		public function main() {
			super(new LibPluginIcon(), new LibPluginCursor());

			_bDefaultHasPlay=true;
			_iDefaultPreferredActivation=ActivationType.AFTER_PREVIOUS;

			_iDefaultWidth=115;
			_iDefaultHeight=115;
			_bDefaultLockAspectRatio=true;
		}
	}
}