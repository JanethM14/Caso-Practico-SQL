-- a) Consultas sobre el menú  
SELECT * FROM menu_items;  

-- b) Encontrar el número de artículos en el menú.  
SELECT COUNT(DISTINCT item_name) AS numero_de_articulos FROM menu_items;  

-- Alternativa: Contar el número total de artículos en el menú (sin DISTINCT).  
SELECT COUNT(item_name) AS numero_de_articulos FROM menu_items;  

-- ¿Cuál es el artículo menos caro y el más caro en el menú?  
SELECT item_name, price  
FROM menu_items  
WHERE price = (SELECT MIN(price) FROM menu_items);  

-- Alternativa: Obtener el artículo más caro y el menos caro en una sola consulta.  
SELECT item_name, price   
FROM menu_items   
WHERE price = (SELECT MAX(price) FROM menu_items)  
   OR price = (SELECT MIN(price) FROM menu_items);  

-- ¿Cuántos platos americanos hay en el menú?  
SELECT COUNT(DISTINCT item_name) AS numero_de_articulos   
FROM menu_items  
WHERE category = 'American';  

-- Alternativa: Contar los platos americanos mostrando también su precio promedio.  
SELECT COUNT(*) AS numero_de_platos_americanos, AVG(price) AS precio_promedio_americanos   
FROM menu_items   
WHERE category = 'American';  

-- ¿Cuál es el precio promedio de los platos?  
SELECT AVG(price) AS precio_promedio  
FROM menu_items;  

-- c) Consultas sobre detalles del pedido  
SELECT * FROM order_details;  

-- ¿Cuántos pedidos únicos se realizaron en total?  
SELECT COUNT(DISTINCT order_id) AS pedidos_unicos FROM order_details;  

-- Alternativa: Contar el total de elementos por pedido sin DISTINCT.  
SELECT COUNT(order_id) AS pedidos_totales FROM order_details;  

-- ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?  
SELECT order_id, COUNT(DISTINCT item_id) AS total_items  
FROM order_details  
GROUP BY order_id  
ORDER BY total_items DESC  
LIMIT 5;  

-- Alternativa: Obtener los 5 pedidos con la mayor cantidad de artículos mostrando también el número total.  
SELECT order_id, COUNT(item_id) AS total_items   
FROM order_details   
GROUP BY order_id   
ORDER BY total_items DESC   
LIMIT 5;  

-- ¿Cuándo se realizó el primer pedido y el último pedido?  
SELECT   
    MIN(CONCAT(order_date, ' ', order_time)) AS primer_pedido,  
    MAX(CONCAT(order_date, ' ', order_time)) AS ultimo_pedido  
FROM order_details;  

-- Alternativa: Obtener solo la fecha de los pedidos más temprano y más reciente (sin incluir hora).  
SELECT   
    MIN(order_date) AS primer_pedido,   
    MAX(order_date) AS ultimo_pedido   
FROM order_details;  

-- ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?  
SELECT COUNT(DISTINCT order_id) AS total_pedidos  
FROM order_details  
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';  

-- Alternativa: Contar pedidos en un rango diferente.  
SELECT COUNT(DISTINCT order_id) AS total_pedidos   
FROM order_details   
WHERE order_date BETWEEN '2023-02-01' AND '2023-02-05';  

-- d) Usar ambas tablas para conocer la reacción de los clientes respecto al menú.  
SELECT   
    order_details.order_id,   
    order_details.item_id,   
    menu_items.item_name,   
    menu_items.price  
FROM order_details  
LEFT JOIN menu_items ON order_details.item_id = menu_items.menu_item_id;  

-- Alternativa: Ver los artículos pedidos junto con la cantidad total de pedidos por cada uno.  
SELECT   
    menu_items.item_name,   
    COUNT(order_details.order_id) AS total_pedidos   
FROM menu_items   
LEFT JOIN order_details ON menu_items.menu_item_id = order_details.item_id   
GROUP BY menu_items.item_name;  

-- e) Artículos más vendidos y menos vendidos.  
-- ARTÍCULOS MÁS VENDIDOS SON LAS HAMBURGUESAS, EDAMAME, KOREAN BEEF BOWL, CHEESEBURGER Y FRENCH FRIES  
SELECT menu_items.item_name, COUNT(order_details.item_id) AS cantidad_vendida  
FROM order_details  
JOIN menu_items ON order_details.item_id = menu_items.menu_item_id  
GROUP BY menu_items.item_name  
ORDER BY cantidad_vendida DESC  
LIMIT 5;  

-- Alternativa: Obtener los artículos más vendidos con su precio  
SELECT menu_items.item_name, COUNT(order_details.item_id) AS cantidad_vendida, menu_items.price  
FROM order_details   
JOIN menu_items ON order_details.item_id = menu_items.menu_item_id   
GROUP BY menu_items.item_name, menu_items.price   
ORDER BY cantidad_vendida DESC   
LIMIT 5;  

-- LOS 5 ARTÍCULOS QUE GENERA MÁS INGRESOS SON EL KOREAN BEEF BOWL, SPAGHETTI & MEATBALLS, TOFU PAD THAI, CHEESEBURGER Y HAMBURGER  
SELECT menu_items.item_name, SUM(menu_items.price) AS ingresos_generados  
FROM order_details  
JOIN menu_items ON order_details.item_id = menu_items.menu_item_id  
GROUP BY menu_items.item_name  
ORDER BY ingresos_generados DESC  
LIMIT 5;  

-- PROMEDIO DE 2.2 ARTÍCULOS POR PEDIDO.  
SELECT AVG(item_count) AS promedio_articulos_por_pedido  
FROM (  
    SELECT order_details.order_id, COUNT(order_details.item_id) AS item_count  
    FROM order_details  
    GROUP BY order_details.order_id  
) AS subquery;  

-- ENTRE EL MEDIO DÍA Y LAS 2 DE LA TARDE ES CUANDO SE LEVANTAN MÁS PEDIDOS  
SELECT EXTRACT(HOUR FROM order_details.order_time) AS hora, COUNT(order_details.order_id) AS total_pedidos  
FROM order_details  
GROUP BY hora  
ORDER BY hora;  

-- LOS 5 PRODUCTOS MENOS VENDIDOS SON LOS CHICKEN TACOS, POSTSTICKERS, CHEESE LASAGNA, STEAK TACOS Y CHEESE QUESADILLAS.  
SELECT menu_items.item_name, COUNT(order_details.item_id) AS cantidad_vendida  
FROM menu_items  
LEFT JOIN order_details ON menu_items.menu_item_id = order_details.item_id  
GROUP BY menu_items.item_name  
HAVING COUNT(order_details.item_id) = 0  
ORDER BY cantidad_vendida ASC  
LIMIT 5;  