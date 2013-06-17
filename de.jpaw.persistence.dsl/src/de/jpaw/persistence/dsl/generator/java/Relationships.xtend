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

package de.jpaw.persistence.dsl.generator.java

import de.jpaw.persistence.dsl.bDDL.EntityDefinition
import de.jpaw.persistence.dsl.bDDL.ManyToOneRelationship

import static extension de.jpaw.persistence.dsl.generator.YUtil.*

class MakeRelationships {
    def static private makeJoin(ManyToOneRelationship m, int i) '''
        @JoinColumn(name="«m.referencedFields.columnName.get(i).columnName»", referencedColumnName="«m.childObject.pk.columnName.get(i).columnName»", insertable=false, updatable=false)
    '''

    def public static writeRelationships(EntityDefinition e, String fieldVisibility) '''
        «FOR m : e.manyToOnes»
            @ManyToOne«IF m.fetchType != null»(fetch=FetchType.«m.fetchType»)«ENDIF»
            «IF m.referencedFields.columnName.size == 1»
                «m.makeJoin(0)»
            «ELSE»
                @JoinColumns({
                   «(0 .. m.referencedFields.columnName.size-1).map[m.makeJoin(it)].join(', ')»
                })
            «ENDIF»
            «fieldVisibility»«m.childObject.name» «m.name»;
            
            public «m.childObject.name» get«m.name.toFirstUpper»() {
                return «m.name»;
            }
        «ENDFOR»
    '''
}