CLASS zcl_tf_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS do_it.
ENDCLASS.



CLASS zcl_tf_test IMPLEMENTATION.
  METHOD do_it.
    DATA txt TYPE char20.

    "! Call {@link cl_abap_browser.METH:show_html} here
    data link type string.
  ENDMETHOD.
ENDCLASS.
