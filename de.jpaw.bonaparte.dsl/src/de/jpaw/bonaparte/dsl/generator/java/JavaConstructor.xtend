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
import de.jpaw.bonaparte.dsl.bonScript.FieldDefinition
import de.jpaw.bonaparte.dsl.generator.Delimiter
import de.jpaw.bonaparte.dsl.generator.Generics

import static de.jpaw.bonaparte.dsl.generator.XUtil.*

/* DISCLAIMER: Validation is work in progress. Neither direct validation nor JSR 303 annotations are complete */

class JavaConstructor {
    def private static typeWithGenericsReplacement(Generics g, ClassDefinition d, FieldDefinition i) {
        // check if the type is a generics argument, in which case it is replaced
        if (g == null)
            return JavaDataTypeNoName(i, false)
        else
            return g.replace(JavaDataTypeNoName(i, false))
    }

    def private static CharSequence allFields(Delimiter s, Generics g, ClassDefinition d, boolean withTypes) '''
        «IF d.extendsClass != null && d.extendsClass.classRef != null»
            «allFields(s, new Generics(g, d), d.extendsClass.classRef, withTypes)»
        «ENDIF»
        «FOR i : d.fields»
            «s.get»«IF withTypes»«typeWithGenericsReplacement(g, d, i)» «ENDIF»«i.name»
        «ENDFOR»
    '''

    def private static int countAllFields(ClassDefinition d) {
        var int sum = d.fields.size
        if (d.extendsClass != null && d.extendsClass.classRef != null)
            sum = sum + countAllFields(d.extendsClass.classRef)
        return sum
    }

    def public static writeConstructorCode(ClassDefinition d) '''
        // default no-argument constructor
        public «d.name»() {
            «IF d.extendsClass != null && d.extendsClass.classRef != null»
                super();
            «ENDIF»
        }

        «IF countAllFields(d) > 0»
            // default all-arguments constructor
            public «d.name»(«allFields(new Delimiter("", ", "), new Generics(), d, true)») {
                «IF d.extendsClass != null && d.extendsClass.classRef != null»
                    super(«allFields(new Delimiter("", ", "), null, d.extendsClass.classRef, false)»);
                «ENDIF»
                «FOR i : d.fields»
                    this.«i.name» = «i.name»;
                «ENDFOR»
            }
        «ENDIF»
     '''
}
