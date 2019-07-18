*&---------------------------------------------------------------------*
*& Report  zflight_customer_satisfaction
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zflight_customer_satisfaction.



DATA(alv) = cl_salv_gui_table_ida=>create_for_cds_view( 'ZFLIGHT_EVALUATION_VIEW' ).

data sort_order type if_salv_gui_types_ida=>yt_sort_rule.

insert value #(  field_name = 'CUSTOMER_NAME ' descending = abap_false is_grouped = abap_true ) into table sort_order.

alv->default_layout( )->set_sort_order( it_sort_order = sort_order  ).

alv->fullscreen( )->display( ).
