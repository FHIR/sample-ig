RuleSet: CodeDef(code,display,definition)
* ^concept[+].code = #{code}
* ^concept[=].display = "{display}"
* ^concept[=].definition = "{definition}"

RuleSet: Designation(language, text)
* ^concept[=].designation[+].language = #{language}
* ^concept[=].designation[=].value = "{text}"

RuleSet: VSCodeDef(code,display)
* ^expansion.contains[+].code = #{code}
* ^expansion.contains[=].display = "{display}"

RuleSet: VSDesignation(language, text)
* ^expansion.contains[=].designation[+].language = #{language}
* ^expansion.contains[=].designation[=].value = "{text}"

RuleSet: ItemControl(code)
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl"
* extension[=].valueCodeableConcept = http://hl7.org/fhir/questionnaire-item-control#{code}




CodeSystem: CSProductSize
Id: product-size
Title: "Product-size"
Description: "Product size"

* insert CodeDef(s,Small,Small)
* insert Designation(fr,Petit)
* insert Designation(es,Pequeño)

* insert CodeDef(m,Medium,Medium)
* insert Designation(fr,Moyen)
* insert Designation(es,Medio)

* insert CodeDef(l,Large,Large)
* insert Designation(fr,Large)
* insert Designation(es,Grande)

* insert CodeDef(xl,Xtra Large,Extra Large)
* insert Designation(fr,Très Large)
* insert Designation(es,Muy grande)


ValueSet: VSProductSize
Id: vs-product-size
Title: "Product-size"
Description: "Product size"
* insert VSCodeDef(s,Small)
* insert VSDesignation(fr,Petit)
* insert VSDesignation(es,Pequeño)

* insert VSCodeDef(m,Medium)
* insert VSDesignation(fr,Moyen)
* insert VSDesignation(es,Medio)

* insert VSCodeDef(l,Large)
* insert VSDesignation(fr,Large)
* insert VSDesignation(es,Grande)

* insert VSCodeDef(xl,Xtra Large)
* insert VSDesignation(fr,Très Large)
* insert VSDesignation(es,Muy grande)




RuleSet: Question(context, linkId, text, type, required, repeats)
* {context}item[+].linkId = "{linkId}"
* {context}item[=].text = "{text}"
* {context}item[=].type = #{type}
* {context}item[=].required = {required}
* {context}item[=].repeats = {repeats}

RuleSet: Translation(language, text)
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/translation"
* extension[=].extension[+].url = "lang"
* extension[=].extension[=].valueCode = #{language}
* extension[=].extension[+].url = "content"
* extension[=].extension[=].valueString = "{text}"

RuleSet: ColorOptions
* answerOption[0].valueCoding = #r "Red"
* answerOption[=].valueCoding.display
  * insert Translation(fr,Rouge)
  * insert Translation(es,Rojo)
* answerOption[+].valueCoding = #b "Blue"
* answerOption[=].valueCoding.display
  * insert Translation(fr,Bleu)
  * insert Translation(es,Azul)
* answerOption[+].valueCoding = #g "Green"
* answerOption[=].valueCoding.display
  * insert Translation(es,Verde)
  * insert Translation(fr,Vert)



Instance: product-questionnaire
InstanceOf: Questionnaire
Description: "Product data entry form"
Title:    "Product data entry form"
* name = "ProductQuestionnaire"

* title = "Product attributes"
* title
  * insert Translation(fr,Données du produit)
  * insert Translation(es,Datos del producto)
* status = #active

* contained[+] = vs-product-size


* insert Question(,MedicinalProduct,Product,group,false,true)
* item[=]
  * text
    * insert Translation(es,Producto)
    * insert Translation(fr,Produit)
  * insert Question(,identifier,Identifier,group,false,true)
  * item[=]
    * text
      * insert Translation(fr,identifiant produit)
      * insert Translation(es,identifcador de producto)
    * insert Question(,identifier_system,System,string,true,false)
    * item[=]
      * text
        * insert Translation(fr,système d'identification)
        * insert Translation(es,systema de identificación)
    * insert Question(,identifier_value,Value,string,true,false)
    * item[=]
      * text
        * insert Translation(fr,identifiant)
        * insert Translation(es,identificador)

  * insert Question(,color1,Color 1,choice,true,false)
    * item[=]
      * text
        * insert Translation(es,color)
        * insert Translation(fr,couleur)
      * insert ColorOptions


  * insert Question(,color2,Color 2,choice,true,false)
    * item[=]
      * insert ItemControl(radio-button)
      * text
        * insert Translation(es,color)
        * insert Translation(fr,couleur)
      * insert ColorOptions

  * insert Question(,color2b,Colors 2b,choice,true,false)
    * item[=]
      * insert ItemControl(check-box)
      * text
        * insert Translation(es,color)
        * insert Translation(fr,couleur)
      * insert ColorOptions

  * insert Question(,additional_colors,Additional Colors,group,false,true)
    * item[=]
      * insert ItemControl(table)
      * insert Question(,color3,Color 3,choice,true,false)
        * item[=]
          * text
            * insert Translation(es,color)
            * insert Translation(fr,couleur)
          * insert ColorOptions

      * insert Question(,color4,Color 4,choice,true,false)
        * item[=]
          * text
            * insert Translation(es,color)
            * insert Translation(fr,couleur)
          * insert ColorOptions


  * insert Question(,size,Size,choice,true,false)
    * item[=]
      * text
        * insert Translation(es,Tamaño)
        * insert Translation(fr,Taille)
      * answerValueSet = Canonical(vs-product-size)