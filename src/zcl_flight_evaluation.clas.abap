class zcl_flight_evaluation definition
  public

  create public .

  public section.

    interfaces zif_flight_evaluation.

    methods constructor
      importing
        i_carrid type z_carrid
        i_connid type z_connid
        i_fldate type d
        i_bookid type z_bookid.

    class-methods create_flight_evaluation
      importing
        i_carrid type z_carrid
        i_connid type z_connid
        i_fldate type s_date.

    class-methods get_evaluations_by_flight_data
      importing
        i_carrid             type z_carrid
        i_connid             type z_connid
        i_fldate             type d
      returning
        value(it_evaluation) type zif_flight_evaluation~ty_evaluation_tab.

  protected section.
  private section.
    data carrid type z_carrid.
    data connid type z_connid.
    data fldate type d.
    data bookid type z_bookid.
    data customer_id type z_customer.
    data customer_name type z_customer_name.
    data meal_rating type z_meal_rating.
    data flight_rating type z_flight_rating.
    data service_rating type z_service_rating.
    data evaluation_exist_indicator type boole_d.
    methods get_system_info.


endclass.



class zcl_flight_evaluation implementation.


  method constructor.
    me->carrid = i_carrid.
    me->connid = i_connid.
    me->fldate = i_fldate.
    me->bookid = i_bookid.

    data wa_zflight_eval type zflight_eval.
    select single * from zflight_eval
      where carrid = @i_carrid
        and connid = @i_connid
        and fldate = @i_fldate
        and bookid = @i_bookid
      into @wa_zflight_eval  .

    if sy-subrc = 0.
      me->flight_rating = wa_zflight_eval-flight_rating.
      me->meal_rating = wa_zflight_eval-meal_rating.
      me->service_rating = wa_zflight_eval-service_rating.
      me->evaluation_exist_indicator = 'X'.
    else.
      me->evaluation_exist_indicator = ' '.
    endif.

  endmethod.


  method get_system_info.
    data uname type uname.
    data xfeld type feld.
    uname = sy-uname.

    data language type langu.
    language = sy-langu.

  endmethod.

  method create_flight_evaluation.
    data it_eval type standard table of zflight_eval.
    data wa_eval type zflight_eval.
    "data tmp type /BEV1/BO_CON_FLAG.
    data boole type boole_d.

    types: begin of booking_list,
             carrid     type z_carrid,
             connid     type z_connid,
             fldate     type d,
             bookid     type z_bookid,
             customid   type z_customer,
             order_date type d,
             cancelled  type abap_bool,
           end of booking_list.

*    select booking~carrid booking~connid booking~fldate booking~bookid booking~customid customer~name
*      from sbook as booking join scustom as customer on customer~id = booking~customid
*
*      into corresponding fields of table it_eval
*       where booking~carrid = i_carrid
*         and booking~connid = i_connid
*         and booking~fldate = i_fldate.

    data booking_list  type standard table of booking_list.
    field-symbols: <booking_list_item> type booking_list.
    call function 'BAPI_SBOOK_GETLIST'
      exporting
        airlinecarrier   = i_carrid    " Carrier ID
        connectionnumber = i_connid  " Connection number
        dateofflight     = i_fldate    " Departure date
      tables
        bookinglist      = booking_list.

    loop at booking_list assigning <booking_list_item>.
      wa_eval-bookid = <booking_list_item>-bookid.
      wa_eval-carrid = <booking_list_item>-carrid.
      wa_eval-connid = <booking_list_item>-connid.
      wa_eval-fldate = <booking_list_item>-fldate.
      wa_eval-customid = <booking_list_item>-customid.
    endloop.

    modify zflight_eval from table @it_eval.

  endmethod.


  method get_evaluations_by_flight_data.

    refresh it_evaluation.

    select bookid, customid, name, meal_rating, flight_rating, service_rating
     from zflight_eval
      where carrid = @i_carrid
        and connid = @i_connid
        and fldate = @i_fldate
     into table @it_evaluation.

    loop at it_evaluation assigning field-symbol(<fs>).
      data(first_evaluation) = <fs>.
      exit.
    endloop.

  endmethod.


  method zif_flight_evaluation~evaluation_exist.
    r_evaluation_exist = me->evaluation_exist_indicator.
  endmethod.


  method zif_flight_evaluation~save_on_db.
    data wa_zflight_eval type zflight_eval.

    wa_zflight_eval-bookid = me->bookid.
    wa_zflight_eval-carrid = me->carrid.
    wa_zflight_eval-connid = me->connid.
    wa_zflight_eval-fldate = me->fldate.
    wa_zflight_eval-customid = me->customer_id.
    wa_zflight_eval-name = me->customer_name.
    wa_zflight_eval-flight_rating = me->flight_rating.
    wa_zflight_eval-service_rating = me->service_rating.
    wa_zflight_eval-meal_rating = me->meal_rating.


    "data eval_exit type ref to ZFLIGHT_EVAL_BADI.
    "get badi eval_exit.

    "call badi eval_exit->change_evaluation_before_save
    "  changing
    "    evaluation = wa_zflight_eval.

    modify zflight_eval from @wa_zflight_eval.

  endmethod.


  method zif_flight_evaluation~set_customer_id.
    me->customer_id = i_customer_id.
  endmethod.


  method zif_flight_evaluation~set_customer_name.
    me->customer_name = i_customer_name.
  endmethod.


  method zif_flight_evaluation~set_flight_rating.
    me->flight_rating = i_flight_rating.
  endmethod.


  method zif_flight_evaluation~set_meal_rating.
    "me->meal_rating = i_meal_rating.
    move i_meal_rating to me->meal_rating.
  endmethod.


  method zif_flight_evaluation~set_service_rating.
    me->service_rating = i_service_rating.
  endmethod.
endclass.
