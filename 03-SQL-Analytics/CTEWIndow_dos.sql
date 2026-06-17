/*Total por Region sin perder detall con windowfuncition*/
select region, customer_name, sales,
sum(sales) over(partition by region) as total_region
from retail;

/*Ranking clientes*/
select customer_name, sum(sales) as total_sales,
rank() over(order by sum(sales) desc) as ranking
from retail
group by customer_name;

/*TOP cliente por region con CTE*/
-- CTE inicio
with clientes_region as (
	select region, customer_name, sum(sales) as total_sales
    from retail
    group by region, customer_name
)
select *,
	row_number() over(
		partition by region 
        order by total_sales desc
    ) as rn
from clientes_region;

/*Análisis Mensual*/
/*LAG: sirve para traer filas anteriores, ejemplo: se puede utitlizar para comparar 
comparar meses*/
with ventas_mes as (
	select 
		year(str_to_date(order_date, '%d/%m/%y')) as anio,
        month(str_to_date(order_date, '%d/%m/%y')) as mes,
        sum(sales) as total_ventas
    from retail
    group by anio, mes
)
select *,
	lag(total_ventas) over(
    order by anio, mes) as ventas_mes_anterior
from ventas_mes;