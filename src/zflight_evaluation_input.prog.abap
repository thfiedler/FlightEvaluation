*&---------------------------------------------------------------------*
*& Report  zflight_evaluation_input
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zflight_evaluation_input.


class lcl_flight_evaluation definition create public.

  public section.
    constants co_carrid_lh type s_carrid value 'LH'.
    methods constructor
      importing
        i_connid type s_conn_id
        i_fldate type s_date.
    methods run.
  protected section.
  private section.

    data connid type s_conn_id.
    data fldate type s_date.
    data it_evaluation type zif_flight_evaluation=>ty_evaluation_tab.
    data s_alv_table   type ref to cl_salv_table.

    methods on_double_click for event double_click
                  of cl_salv_events_table
      importing row column.

endclass.

class lcl_flight_evaluation implementation.

  method constructor.
    me->connid = i_connid.
    me->fldate = i_fldate.
  endmethod.


  method run.

    zcl_flight_evaluation=>get_evaluations_by_flight_data(
      exporting
        i_carrid      = co_carrid_lh
        i_connid      = me->connid
        i_fldate      = me->fldate
      receiving
        it_evaluation = it_evaluation
    ).

    if it_evaluation is initial.
      zcl_flight_evaluation=>create_flight_evaluation(
        exporting
          i_carrid = co_carrid_lh
          i_connid = me->connid
          i_fldate = me->fldate
      ).
      zcl_flight_evaluation=>get_evaluations_by_flight_data(
       exporting
         i_carrid      = co_carrid_lh
         i_connid      = me->connid
         i_fldate      = me->fldate
       receiving
         it_evaluation = it_evaluation ).
    endif.

    data: alv_events type ref to cl_salv_events_table.
    cl_salv_table=>factory(
      importing
        r_salv_table   = s_alv_table
      changing
        t_table        = it_evaluation
    ).

    s_alv_table->get_columns( )->set_optimize(
*        value = IF_SALV_C_BOOL_SAP~TRUE
    ).

    alv_events = s_alv_table->get_event( ).
    set handler on_double_click for alv_events.

    s_alv_table->display( ).
  endmethod.

  method on_double_click.
    data: lt_fields     type standard table of sval,
          ls_fields     type sval,
          lv_returncode type c.

    data evaluation type zif_flight_evaluation=>ty_evaluation.

    read table it_evaluation into evaluation index row.



    ls_fields-tabname   = 'ZFLIGHT_EVAL'.
    ls_fields-fieldname = 'MEAL_RATING'.
    ls_fields-field_obl = ' '.
    ls_fields-value = evaluation-meal_rating.
    append ls_fields to lt_fields.
    clear ls_fields.

    ls_fields-tabname   = 'ZFLIGHT_EVAL'.
    ls_fields-fieldname = 'FLIGHT_RATING'.
    ls_fields-field_obl = ' '.
    ls_fields-value = evaluation-flight_rating.
    append ls_fields to lt_fields.
    clear ls_fields.

    ls_fields-tabname   = 'ZFLIGHT_EVAL'.
    ls_fields-fieldname = 'SERVICE_RATING'.
    ls_fields-field_obl = ' '.
    ls_fields-value = evaluation-service_rating.
    append ls_fields to lt_fields.
    clear ls_fields.

    call function 'POPUP_GET_VALUES'
      exporting
*       NO_VALUE_CHECK  = ' '
        popup_title     = 'Enter Evaluation of Passenger'
        start_column    = '5'
        start_row       = '5'
      importing
        returncode      = lv_returncode
      tables
        fields          = lt_fields
      exceptions
        error_in_fields = 1
        others          = 2.

    if sy-subrc <> 0.
      message i531(0u) with 'Problem with Fuba POPUP_GET_VALUES'.
    endif.

    if lv_returncode = 'A'.
      exit.
    endif.

    " Meal Rating
    read table lt_fields into ls_fields index 1.
    evaluation-meal_rating = ls_fields-value.
    " Flight Rating
    read table lt_fields into ls_fields index 2.
    evaluation-flight_rating = ls_fields-value.
    "Service Rating
    read table lt_fields into ls_fields index 3.
    evaluation-service_rating = ls_fields-value.

    data eval_obj type ref to zif_flight_evaluation.
    eval_obj = new zcl_flight_evaluation(
        i_carrid = co_carrid_lh
        i_connid = connid
        i_fldate = fldate
        i_bookid = evaluation-bookid
    ).

    eval_obj->set_customer_id( evaluation-customid ).
    eval_obj->set_customer_name( evaluation-name ).
    eval_obj->set_flight_rating( evaluation-flight_rating ).
    eval_obj->set_meal_rating( evaluation-meal_rating ).
    eval_obj->set_service_rating( evaluation-service_rating ).

    eval_obj->save_on_db( ).

    field-symbols: <evaluation> like line of it_evaluation.
    read table it_evaluation assigning <evaluation> index row.
    <evaluation>-meal_rating = evaluation-meal_rating.
    <evaluation>-flight_rating = evaluation-flight_rating.
    <evaluation>-service_rating = evaluation-service_rating.

    s_alv_table->refresh( ).

  endmethod.

endclass.

start-of-selection.

  parameters connid type s_conn_id.
  parameters fldate type s_date.

  data runner type ref to lcl_flight_evaluation.

  runner = new lcl_flight_evaluation(
      i_connid = connid
      i_fldate = fldate
  ).

  runner->run( ).
