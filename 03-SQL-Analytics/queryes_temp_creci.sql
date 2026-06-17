/*Porcentaje que reprecenta cada region*/
select region, sum(sales) as ventas_region,
	round(sum(sales) * 100.0 / sum(sum(sales)) over(), 2) as porcentaje_total
from retail
group by region
order by ventas_region desc;

/*Porcentaje de Crecimiento*/
with ventas_mes as (
	select 
		year(str_to_date(order_date, '%d/%m/%Y')) as anio,
		month(str_to_date(order_date, '%d/%m/%Y')) as mes,
        sum(sales) as ventas
    from retail
    group by anio, mes
)
select *,
	lag(ventas) over(order by anio, mes) as ventas_anterior,
    round((ventas - lag(ventas) over(order by anio, mes)) / 
		lag(ventas) over(order by anio, mes) * 100, 2) as crecimineto_pct
from ventas_mes;

/*Acumulado de ventas en el tiempo*/
with ventas_mes as (
	select year(str_to_date(order_date, '%d/%m/%y')) as anio,
    month(str_to_date(order_date, '%d/%m/%y')) as mes,
    sum(sales) as ventas
    from retail
    group by anio, mes
)
select *,
	sum(ventas) over(order by anio, mes) as acumulado
from ventas_mes;

/*MOVING AVERAGE*/
-- OBJETIVO: Suavizar fluctuaciones.
with ventas_mes as (
	select year(str_to_date(order_date, '%d/%m/%y')) as anio,
    month(str_to_date(order_date, '%d/%m/%y')) as mes,
    sum(sales) as ventas
    from retail
    group by anio, mes
)
select *,
	avg(ventas) over(
			order by anio, mes
            rows between 2 preceding and current row
        ) as promedio_movil
from ventas_mes;

/*Union de los 3*/
WITH ventas_mes AS (
    SELECT
        year(str_to_date(order_date, '%d/%m/%Y')) as anio,
		month(str_to_date(order_date, '%d/%m/%Y')) as mes,
        sum(sales) as ventas
    from retail
    group by anio, mes
)

SELECT *,
    
    -- Ventas mes anterior
    LAG(ventas) OVER(
        ORDER BY anio, mes
    ) AS ventas_anterior,

    -- Acumulado
    SUM(ventas) OVER(
        ORDER BY anio, mes
    ) AS acumulado,

    -- Promedio móvil
    AVG(ventas) OVER(
        ORDER BY anio, mes
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS promedio_movil

FROM ventas_mes;
