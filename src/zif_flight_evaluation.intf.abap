interface zif_flight_evaluation
  public .
  types: begin of ty_evaluation,
           bookid         type z_bookid,
           customid       type z_customer,
           name           type z_customer_name,
           meal_rating    type z_meal_rating,
           flight_rating  type z_flight_rating,
           service_rating type z_service_rating,
         end of ty_evaluation,
         ty_evaluation_tab type standard table of ty_evaluation with key bookid.
  methods set_meal_rating
    importing
      i_meal_rating type z_meal_rating optional.
  methods set_flight_rating
    importing
      i_flight_rating type z_flight_rating optional.
  methods set_customer_id
    importing
      i_customer_id type z_customer optional.
  methods set_service_rating
    importing
      i_service_rating type z_service_rating optional.
  methods save_on_db.
  methods evaluation_exist
    returning
      value(r_evaluation_exist) type boole_d.
  methods set_customer_name
    importing
      i_customer_name type z_customer_name optional.

endinterface.
