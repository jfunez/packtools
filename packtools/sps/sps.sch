<!--
*******************************************************************************
 THINGS TO BE SURE BEFORE EDITING THIS FILE!

 The implementation of the schematron patterns comes with the idea of SPS as a
 set of constraints on top of JATS' Publishing Tag Set (JPTS). To keep
 consistency, please make sure:

   - DTD/XSD constraints are not duplicated here
   - There is an issue at http://git.io/5EcR4Q with status `Aprovada`

 Always double-check the JPTS before editing.
 http://jats.nlm.nih.gov/publishing/tag-library/1.1d1/
*******************************************************************************
-->

<schema xmlns="http://purl.oclc.org/dsdl/schematron">

  <!--
   Phases - sets of patterns.
   These are being used to help on tests isolation.
  -->
  <phase id="phase.journal-id">
    <active pattern="journal-id_type_nlm-ta_or_publisher-id"/>
  </phase>

  <phase id="phase.journal-title-group">
    <active pattern="has_journal-title_and_abbrev-journal-title"/>
  </phase>

  <phase id="phase.issn">
    <active pattern="issn_type_epub"/>
  </phase>

  <phase id="phase.publisher">
    <active pattern="publisher"/>
  </phase>


  <!--
   Patterns - sets of rules.
  -->
  <pattern id="journal-id_type_nlm-ta_or_publisher-id">
    <rule context="article/front/journal-meta">
      <assert test="journal-id[@journal-id-type='nlm-ta'] or journal-id[@journal-id-type='publisher-id']">
        Element 'journal-meta': Missing element journal-id of type "nlm-ta" or "publisher-id".
      </assert>
    </rule>
  </pattern>

  <pattern id="has_journal-title_and_abbrev-journal-title">
    <rule context="article/front/journal-meta">
      <assert test="journal-title-group">
        Element 'journal-meta': Missing element journal-title-group.
      </assert>
    </rule>

    <rule context="article/front/journal-meta/journal-title-group">
      <assert test="journal-title">
        Element 'journal-title-group': Missing element journal-title.
      </assert>
      <assert test="abbrev-journal-title[@abbrev-type='publisher']">
        Element 'journal-title-group': Missing element abbrev-journal-title of type "publisher".
      </assert>
    </rule>
  </pattern>

  <pattern id="issn_type_epub">
    <rule context="article/front/journal-meta">
      <assert test="issn[@pub-type='epub']">
        Element 'journal-meta': Missing element issn of type "epub".
      </assert>
    </rule>
  </pattern>

  <pattern id="publisher">
    <rule context="article/front/journal-meta">
      <assert test="publisher">
        Element 'journal-meta': Missing element publisher.
      </assert>
    </rule>
  </pattern>
</schema>
