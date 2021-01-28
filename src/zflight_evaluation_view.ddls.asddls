@AbapCatalog.sqlViewName: 'zvflight_eval'
@AbapCatalog.compiler.CompareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for Flight Evaluation'
define view zflight_evaluation_view as select from zflight_eval {
    key customid as customer_id,
    name as customer_name,
    flight_rating as flight_rating,
    service_rating as service_rating,
    meal_rating as meal_rating,
    avg(meal_rating) as meal_rating_average,
    avg(service_rating) as service_rating_average,
    avg(flight_rating) as flight_rating_average
}
group by
  customid,
  name,
  flight_rating,
  service_rating,
  meal_rating
