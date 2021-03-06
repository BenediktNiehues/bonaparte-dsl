 /*
  * Copyright 2012 Michael Bischoff
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  *
  *   http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

package de.jpaw.bonaparte.dsl.generator.java

import de.jpaw.bonaparte.dsl.bonScript.ClassDefinition
import de.jpaw.bonaparte.dsl.bonScript.EnumDefinition
import de.jpaw.bonaparte.dsl.bonScript.PackageDefinition

import static de.jpaw.bonaparte.dsl.generator.XUtil.*

class JavaPackages {
    // TODO: should we make this configurable per generator run?
    public static final String bonaparteClassDefaultPackagePrefix = "de.jpaw.bonaparte.pojos"

    def public static getPackageName(PackageDefinition p) {
        (if (p.prefix == null) bonaparteClassDefaultPackagePrefix else p.prefix) + "." + p.name
    }

    // create the package name for a class definition object
    def public static getPackageName(ClassDefinition d) {
        getPackageName(getPackage(d))
    }
    // create the package name for an enum object
    def public static getPackageName(EnumDefinition d) {
        getPackageName(getPackage(d))
    }

    // Utility methods
    def public static getPartiallyQualifiedClassName(ClassDefinition d) {
        getPackage(d).name + "." + d.name
    }
    def public static getPartiallyQualifiedClassName(EnumDefinition d) {
        getPackage(d).name + "." + d.name
    }
    // create a serialVersionUID which depends on class name and revision, plus the same for any parent classes only
    def public static long getSerialUID(ClassDefinition d) {
        var long myUID = getPartiallyQualifiedClassName(d).hashCode()
        if (d.revision != null)
            myUID = 97L * myUID + d.revision.hashCode()
        if (d.extendsClass != null && d.extendsClass.classRef != null)
            myUID = 131L * myUID + getSerialUID(d.extendsClass.classRef)   // recurse parent classes
        return myUID
    }

    // generate a fully qualified or (optically nicer) simple class name, depending on whether target is in same package as the current class
    // TODO: do this in dependence of the import list
    def public static xxxxxpossiblyFQClassName(ClassDefinition current, ClassDefinition target) {
        if (getPackageName(current) == getPackageName(target))
            target.name
        else
            getPackageName(target) + "." +target.name
    }

}
