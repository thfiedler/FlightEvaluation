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
    data collection_cleared type flag.
    refresh collection.
    free collection.
  endmethod.

  method get_number_of_items.
    data: no_of_lines type int4.
    describe table collection lines no_of_lines.
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
    move op1 to sum.
    add op2 to sum.
  endmethod.

  method subtract.
    move op1 to diff.
    subtract op2 from diff.
  endmethod.

  method multiply.
    move op2 to prod.
    multiply prod by op1.
  endmethod.

  method divide.
    move op1 to quot.
    divide quot by op2 .
  endmethod.


endclass.
