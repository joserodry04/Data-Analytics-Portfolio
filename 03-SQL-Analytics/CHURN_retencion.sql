/*OBJETIVO
Encontrar: clientes “perdidos”.*/

-- Clientes perdidos
with ultima_compra as (
	select customer_id,
		max(str_to_date(order_date, '%d/%m/%Y')) as ultima_fecha
    from retail
    group by customer_id
)
select *, 
	datediff( 
		(select max(str_to_date(order_date, '%d/%m/%Y')) 
        from retail), ultima_fecha
    ) as dias_inactivo
    /*¿Qué estamos comparando? última fecha global - última compra cliente*/
from ultima_compra
order by dias_inactivo desc;

-- ¿Qué clientes realmente valen más? Customer Lifetime Value (CLV)
select 
	customer_id,
    count(*) as total_compras,
    round(sum(sales), 2) as dinero_total,
    round(avg(sales), 2) as ticket_promedio
from retail
group by customer_id
order by ticket_promedio desc;

