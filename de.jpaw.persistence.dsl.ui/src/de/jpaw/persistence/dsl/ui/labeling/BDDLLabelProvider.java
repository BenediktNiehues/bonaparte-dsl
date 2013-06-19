/*
* generated by Xtext
*/
package de.jpaw.persistence.dsl.ui.labeling;

import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider;
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider;

import com.google.inject.Inject;

/**
 * Provides labels for a EObjects.
 *
 * see http://www.eclipse.org/Xtext/documentation/latest/xtext.html#labelProvider
 */
public class BDDLLabelProvider extends DefaultEObjectLabelProvider {

    @Inject
    public BDDLLabelProvider(AdapterFactoryLabelProvider delegate) {
        super(delegate);
    }

/*
    //Labels and icons can be computed like this:

    String text(MyModel ele) {
      return "my "+ele.getName();
    }

    String image(MyModel ele) {
      return "MyModel.gif";
    }
*/
}
