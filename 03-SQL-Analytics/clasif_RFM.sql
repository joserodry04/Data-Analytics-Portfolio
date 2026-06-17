-- RFM (Recency Frequecy Monetary)
/*R = Recency, ¿Qué tan reciente fue su última compra?
F = Frequency, ¿Cuántas veces compra?
M = Monetary, ¿Cuánto dinero genera?*/
/*Es una de las técnicas más usadas para clasificar clientes en:
VIP
Leales
En riesgo
Perdidos

Y combina exactamente todo lo que ya aprendiste:
Churn
CLV
Frecuencia
Ingresos*/

-- Recency: para saber primero cuántos días han pasado desde la última compra.
with ultima_compra as(
	select customer_id,
		max(str_to_date(order_date, '%d/%m/%Y')) as ultima_fecha
    from retail
    group by customer_id
)
select 
	customer_id, ultima_fecha,
    datediff(
    (
		select max(str_to_date(order_date, '%d/%m/%Y')) 
        from retail
	), ultima_fecha
    ) as recency
from ultima_compra
order by recency;

-- Frequency: saber cuantas veces compra cada cliente
select customer_id,
	count(*) as frequency
from retail
group by customer_id
order by frequency;

-- Monetary: saber que cliente genera más 
select customer_id, round(sum(sales), 2) as monetary
from retail
group by customer_id
order by monetary desc;

-- RFM completo
with rfm as (
	select customer_id,
		datediff(
			(
				select max(str_to_date(order_date, '%d/%m/%Y'))
                from retail
            ), max(str_to_date(order_date, '%d/%m/%Y')) 
        ) as recency,
        count(*) as frequency,
        round(sum(sales), 2) as monetary
    from retail
    group by customer_id
)
select *
from rfm
order by monetary desc;