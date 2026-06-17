-- COHORT Analisis

-- Primera Compra
with primera_compra as (
	select customer_id, min(str_to_date(order_date, '%d/%m/%Y')) as primera_fecha
    from retail
    group by customer_id
) 
select *
from primera_compra;

-- MEs de primera compra
with primera_venta as (
	select customer_id, min(str_to_date(order_date, '%d/%m/%Y')) as primera_fecha 
    from retail
    group by customer_id
)
select 
	customer_id, 
    year(primera_fecha) as anio, 
    month(primera_fecha) as mes
from primera_venta;

-- Ver cuantos clientes regresaron
with primera_compra as (
	select customer_id,
		min(str_to_date(order_date, '%d/%m/%Y')) as primera_fecha
    from retail
    group by customer_id
)
select 
	r.customer_id,
    count(*) as total_compras
from retail r
join primera_compra pc 
on r.customer_id = pc.customer_id 
group by r.customer_id
order by total_compras;

/*¿Qué cohortes retienen mejor clientes?*/
-- coherte de cliente
with cohortes as (
	select customer_id, min(str_to_date(order_date, '%d/%m/%Y')) as primera_fecha 
    from retail
    group by customer_id
)
select 
	customer_id, 
    year(primera_fecha) as anio_coherte, 
    month(primera_fecha) as mes_coherte
from cohortes;
-- compras futuras
with coherte as (
	select customer_id,
		min(str_to_date(order_date, '%d/%m/%Y')) as primera_compra
    from retail
    group by customer_id
)
select r.customer_id,
	year(c.primera_compra) as anio_cohert,
	month(c.primera_compra) as mes_cohert,
	count(*) as compras_totales
from retail r
join coherte c 
	on r.customer_id = c.customer_id
group by r.customer_id, anio_cohert, mes_cohert
order by compras_totales desc;
