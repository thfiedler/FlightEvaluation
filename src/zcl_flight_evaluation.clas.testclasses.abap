*"* use this source file for your ABAP unit test classes
class ltcl_ definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      first_test for testing raising cx_static_check.
endclass.


class ltcl_ implementation.

  method first_test.
    "cl_aunit_assert=>fail( 'Implement your first test here' ).
  endmethod.

endclass.
