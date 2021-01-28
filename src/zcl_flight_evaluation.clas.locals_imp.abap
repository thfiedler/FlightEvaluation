*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

class lcl_collection definition

  final
  create public .

  public section.
  protected section.
  private section.
    data collection type standard table of string.
    methods clear_collection.
    methods get_number_of_items.
endclass.



class lcl_collection implementation.
  method clear_collection.
    data collection_cleared type ABAP_BOOLEAN .
    CLEAR COLLECTION.
    free collection.
  endmethod.

  method get_number_of_items.
    data: no_of_lines type int4.
    NO_OF_LINES = LINES( COLLECTION ).
  endmethod.

endclass.



class lcl_calculator definition

  final
  create public .

  public section.
  protected section.
  private section.
    methods add
      importing
        op1        type int4 optional
        op2        type int4 optional
          preferred parameter op1
      returning
        value(sum) type int4.

    methods subtract
      importing
        op1         type int4 optional
        op2         type int4 optional
          preferred parameter op1
      returning
        value(diff) type int4.

    methods multiply
      importing
        op1         type int4 optional
        op2         type int4 optional
          preferred parameter op1
      returning
        value(prod) type int4.

    methods divide
      importing
        op1         type int4 optional
        op2         type int4 optional
          preferred parameter op1
      returning
        value(quot) type f.


endclass.



class lcl_calculator implementation.
  method add.
    SUM = OP1.
    SUM += OP2.
  endmethod.

  method subtract.
    DIFF = OP1.
    DIFF -= OP2.
  endmethod.

  method multiply.
    PROD = OP2.
    PROD *= OP1.
  endmethod.

  method divide.
    QUOT = OP1.
    QUOT /= OP2.
  endmethod.


endclass.
