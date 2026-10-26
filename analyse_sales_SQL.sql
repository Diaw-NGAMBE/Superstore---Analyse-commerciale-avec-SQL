USE projet_da;
# Affichage des 10 premières lignes de la table
SELECT * 
FROM superstore_clean
LIMIT 10;

# Renommage des colonnes pour éviter les erreurs de syntaxes sur mes requêtes
ALTER TABLE superstore_clean 
    RENAME COLUMN `Row ID` TO row_id,
    RENAME COLUMN `Order ID` TO order_id,
    RENAME COLUMN `Order Date` TO order_date,
    RENAME COLUMN `Ship Date` TO ship_date,
    RENAME COLUMN `Ship Mode` TO ship_mode,
    RENAME COLUMN `Customer ID` TO customer_id,
    RENAME COLUMN `Customer Name` TO customer_name,
    RENAME COLUMN `Postal Code` TO postal_code,
    RENAME COLUMN `Product ID` TO product_id,
    RENAME COLUMN `Product Name` TO product_name,
    RENAME COLUMN `Sub-Category` TO sub_category;
    
# Affichage unique de : order_id, order_date, customer_name et sales
SELECT order_id, order_date, customer_name, Sales
FROM superstore_clean
LIMIT 50;

# La liste des pays présents
SELECT DISTINCT Country
FROM superstore_clean;

# Les différentes catégories de produits
SELECT DISTINCT Category
FROM superstore_clean;

# Les  différents modes de livraison
SELECT DISTINCT ship_mode
FROM superstore_clean;

# Le nombre total de lignes dans la table
SELECT COUNT(*) AS nb_lignes
FROM superstore_clean;

# Le nombre de clients
SELECT COUNT(DISTINCT customer_id) AS nb_clients
FROM superstore_clean;

# Le chiffre d'affaires total
SELECT ROUND(SUM(Sales), 3) AS CA_total
FROM superstore_clean;

# Le montant moyen d'une vente
SELECT ROUND(AVG(Sales),3) AS Moyen_vente
FROM superstore_clean;

# Le chiffre d'affaires total pour chaque catégorie
SELECT Category, ROUND(SUM(Sales), 3) AS CA_total_cat
FROM superstore_clean
GROUP BY Category;

# Le chiffre d'affaires total pour chaque sous-catégorie
SELECT sub_category, ROUND(SUM(Sales), 3) AS CA_total_sub_cat
FROM superstore_clean
GROUP BY sub_category;

# Le chiffre d'affaires total pour chaque région
SELECT Region, ROUND(SUM(Sales), 3) AS CA_total_region
FROM superstore_clean
GROUP BY Region;

# Le chiffre d'affaires total pour chaque État
SELECT State, ROUND(SUM(Sales), 3) AS CA_total_state
FROM superstore_clean
GROUP BY State;

# Le nombre de commandes pour chaque mode de livraison
SELECT ship_mode, COUNT(DISTINCT order_id) AS nb_commande
FROM superstore_clean
GROUP BY ship_mode;

# Le chiffre d'affaires total pour chaque segment client
SELECT Segment, ROUND(SUM(Sales), 3) AS CA_total_segment
FROM superstore_clean
GROUP BY Segment;

# Classer les catégories de produits de la plus forte à la plus faible en chiffre d'affaires
SELECT Category, ROUND(SUM(Sales), 3) AS CA_total_cat
FROM superstore_clean
GROUP BY Category
ORDER BY CA_total_cat DESC;

# Les 10 États qui génèrent le plus de chiffre d'affaires
SELECT State, ROUND(SUM(Sales), 3) AS CA_total_state
FROM superstore_clean
GROUP BY State
ORDER BY CA_total_state DESC
LIMIT 10;

# Le chiffre d'affaires total pour chaque année
SELECT DATE_FORMAT(order_date, '%Y') AS annee, ROUND(SUM(Sales), 3) AS CA_total_annee
FROM superstore_clean
GROUP BY annee;
# 2 méthode pour extraire l'année dans une date
SELECT YEAR(order_date) AS annee, ROUND(SUM(Sales), 3) AS CA_total_annee
FROM superstore_clean
GROUP BY annee;

# Le nombre de commandes pour chaque année
SELECT YEAR(order_date) AS annee, COUNT(DISTINCT order_id) AS nb_commande_annee
FROM superstore_clean
GROUP BY annee;

# Le chiffre d'affaires par année et par mois
SELECT DATE_FORMAT(order_date, '%Y-%m') AS anne_mois, ROUND(SUM(Sales), 3) AS CA_total
FROM superstore_clean
GROUP BY anne_mois;

# L'année ayant généré le plus gros chiffre d'affaires
SELECT YEAR(order_date) AS annee, ROUND(SUM(Sales), 3) AS CA_total_annee
FROM superstore_clean
GROUP BY annee
ORDER BY CA_total_annee DESC
LIMIT 1;

# Le mois ayant généré le plus gros chiffre d'affaires
SELECT MONTH(order_date) AS mois, ROUND(SUM(Sales), 3) AS CA_total_mois
FROM superstore_clean
GROUP BY mois
ORDER BY CA_total_mois DESC
LIMIT 1;

# 2 méthode pour extraire le nom du mois et l'année
SELECT DATE_FORMAT(order_date, '%Y-%m') AS mois, ROUND(SUM(Sales), 3) AS CA_total_mois
FROM superstore_clean
GROUP BY mois
ORDER BY CA_total_mois DESC
LIMIT 1;

# Le chiffre d'affaires moyen pour chaque année
SELECT YEAR(order_date) AS annee, ROUND(AVG(Sales), 3) AS CA_Moyen_anne
FROM superstore_clean
GROUP BY annee;

# Comparer le chiffre d'affaires de 2016 et 2017
SELECT YEAR(order_date) AS annee, ROUND(SUM(Sales), 3) AS CA_total_annee
FROM superstore_clean
GROUP BY annee 
HAVING annee = '2017' OR annee = '2016';

--- Analyse clients
# Les 10 meilleurs clients selon leur chiffre d'affaires
SELECT customer_name, ROUND(SUM(Sales), 3) AS CA_total_client
FROM superstore_clean
GROUP BY customer_name
ORDER BY CA_total_client DESC
LIMIT 10;

# Le chiffre d'affaires total réalisé par chaque client
SELECT customer_name, ROUND(SUM(Sales), 3) AS CA_total_client
FROM superstore_clean
GROUP BY customer_name; 

# Le nombre de commandes réalisées par chaque client
SELECT customer_name, COUNT(DISTINCT order_id) AS nb_commande
FROM superstore_clean
GROUP BY customer_name; 

# Les clients ayant réalisé plus d'une commande
SELECT customer_name, COUNT(DISTINCT order_id) AS nb_commande
FROM superstore_clean
GROUP BY customer_name
HAVING COUNT(DISTINCT order_id) >= 2
ORDER BY nb_commande DESC;


# Les clients ayant généré plus de 1 000 $ de chiffre d'affaires
SELECT customer_name, ROUND(SUM(Sales), 3) AS CA_total_client
FROM superstore_clean
GROUP BY customer_name
HAVING CA_total_client > 1000; 

# Le chiffre d'affaires moyen par client
WITH CA_par_client AS (
SELECT customer_id, customer_name, SUM(Sales) AS CA_total_client
FROM superstore_clean
GROUP BY customer_id, customer_name
)
SELECT customer_name, CA_total_client, ROUND(AVG(CA_total_client) OVER (), 2) AS CA_moyen_par_client
FROM CA_par_client; 

--- Analyse produits
# Les 10 produits ayant généré le plus de chiffre d'affaires.
SELECT product_name, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY product_name
ORDER BY CA_total DESC
LIMIT 10;

# Les 10 produits ayant généré le moins de chiffre d'affaires
SELECT product_name, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY product_name
ORDER BY CA_total ASC
LIMIT 10;

# Le chiffre d'affaires par catégorie et sous-catégorie
SELECT Category, sub_category, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY Category, sub_category;

# Les produits ayant généré plus de 10 000 $ de chiffre d'affaires
SELECT product_name, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY product_name
HAVING CA_total > 10000;

# La sous-catégorie générant le plus de chiffre d'affaires
SELECT sub_category, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY sub_category
ORDER BY CA_total DESC
LIMIT 1;

# Sous-catégorie ayant le plus gros CA dans chaque catégorie
WITH cte_sous_cat AS 
(SELECT Category, sub_category, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY Category, sub_category),
partit_sous_cat AS
(SELECT Category, sub_category, CA_total, ROW_NUMBER() OVER (PARTITION BY Category ORDER BY CA_total DESC) AS num_unique
FROM cte_sous_cat)
SELECT Category, sub_category, CA_total, num_unique
FROM partit_sous_cat
WHERE num_unique = 1;

--- Classement des clients
# Classer les clients par chiffres d'affaires
WITH cte_CA_client AS
(SELECT customer_id, customer_name, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY customer_id, customer_name)
SELECT customer_id, customer_name, CA_total, DENSE_RANK() OVER (ORDER BY CA_total DESC) AS rang_client
FROM cte_CA_client;

--- Fréquence de commande par client
SELECT customer_id, customer_name, COUNT(DISTINCT order_id) AS nb_commandes, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY customer_id, customer_name
ORDER BY nb_commandes DESC; 

---- Délai moyen entre deux commandes
# Calcul du délai moyen, en jours, entre deux commandes successives pour chaque client
WITH commandes AS (
SELECT DISTINCT order_id, order_date, customer_id, customer_name
FROM superstore_clean),
delai_commande AS (SELECT 
customer_id, 
customer_name, 
order_id,
order_date,
LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS date_commande_precedente
FROM commandes),
delai_moyen AS
(SELECT customer_id, customer_name, DATEDIFF(order_date,date_commande_precedente) AS delai_jours
FROM delai_commande)
SELECT customer_id, customer_name, AVG(delai_jours) AS moyen_delai
FROM delai_moyen
GROUP BY customer_id, customer_name
ORDER BY moyen_delai DESC;

--- Évolution du chiffre d’affaires par client
# Identifier les clients dont le chiffre d’affaires diminue entre deux années consécutives
WITH CA_annee AS (
SELECT customer_id, customer_name, YEAR(order_date) AS annee, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY customer_id, customer_name, annee),
Evolut_CA AS (
SELECT customer_id, customer_name, annee, CA_total, LAG(CA_total) OVER(PARTITION BY customer_id ORDER BY annee) AS CA_annee_precedente, 
	   LAG(annee) OVER(PARTITION BY customer_id ORDER BY annee) AS annee_precedente
FROM CA_annee),
diminution_CA AS (
SELECT customer_id, customer_name, annee, annee_precedente, CA_total, CA_annee_precedente, (CA_total - CA_annee_precedente) AS evolution_CA
FROM Evolut_CA)
SELECT customer_id, customer_name, annee, annee_precedente, CA_total, CA_annee_precedente, evolution_CA
FROM diminution_CA
WHERE evolution_CA < 0;

--- Évolution mensuelle du chiffre d’affaires
# calculer le CA mensuel et le comparer au mois précédent

WITH CA_mensuel AS (
SELECT YEAR(order_date) AS annee, MONTH(order_date) AS mois, SUM(Sales) AS CA_mensuel
FROM superstore_clean
GROUP BY YEAR(order_date), MONTH(order_date)),
CA_mensu_precede AS (
SELECT annee, mois, CA_mensuel, LAG(CA_mensuel) OVER (ORDER BY annee, mois) CA_precedent
FROM CA_mensuel)
SELECT annee, mois, CA_mensuel, CA_precedent, (CA_mensuel - CA_precedent) AS variation_CA
FROM CA_mensu_precede
ORDER BY annee, mois;

--- Top 3 des produits par catégorie
# Trouver les trois produits générant le plus de CA dans chaque catégorie
WITH CA_produit AS (
SELECT product_id, product_name, Category, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY product_id, product_name, Category),
rang_produit AS(
SELECT product_id, product_name, Category, CA_total, ROW_NUMBER () OVER (PARTITION BY Category ORDER BY CA_total DESC) AS rang
FROM CA_produit)
SELECT product_id, product_name, Category, CA_total, rang
FROM rang_produit
WHERE rang <= 3
ORDER BY Category, rang;

--- Clients au-dessus de la moyenne
# Identifier les clients dont le CA total est supérieur au CA moyen par client

WITH CA_total AS (
SELECT customer_id, customer_name, SUM(Sales) AS CA_total
FROM superstore_clean
GROUP BY customer_id, customer_name),
CA_moyen AS (
SELECT customer_id, customer_name, CA_total, AVG(CA_total) OVER () AS CA_moyen_clients
FROM CA_total)
SELECT customer_id, customer_name, CA_total, CA_moyen_clients
FROM CA_moyen
WHERE CA_total > CA_moyen_clients;

---- Contribution de chaque catégorie au CA
# Calculer la part de chaque catégorie dans le chiffre d’affaires total
WITH CA_total AS (
SELECT Category, SUM(Sales) AS CA_total_cat 
FROM superstore_clean
GROUP BY Category),
CA_global AS (
SELECT Category, CA_total_cat, SUM(CA_total_cat) OVER () CA_global
FROM CA_total)
SELECT Category, CA_total_cat, CA_global, ROUND((CA_total_cat / CA_global) * 100, 2) AS part_CA_pct
FROM CA_global;

--- Produits vendus dans plusieurs régions
# Identifier les produits ayant généré du CA dans au moins deux régions distinctes
WITH CA_produit AS (
SELECT product_id, product_name, Region, SUM(Sales) AS CA_region
FROM superstore_clean
GROUP BY product_id, product_name, Region),
nb_region_prod AS (
SELECT product_id, product_name, SUM(CA_region) AS CA_total, COUNT(DISTINCT Region) AS nb_regions
FROM CA_produit
GROUP BY product_id, product_name)
SELECT product_id, product_name, CA_total, nb_regions
FROM nb_region_prod
WHERE nb_regions >= 2;

--- Délai moyen d’expédition
# Calculer le délai moyen entre la commande et l’expédition pour chaque mode de livraison
WITH delai AS (
SELECT DISTINCT order_id, ship_mode, DATEDIFF(ship_date, order_date) AS delai_livr
FROM superstore_clean)
SELECT ship_mode, COUNT(*) AS nb_commandes, ROUND(AVG(delai_livr), 2) AS delai_moyen_jours, MAX(delai_livr) AS delai_max, MIN(delai_livr) AS delai_min
FROM delai
GROUP BY ship_mode;

 ---- Meilleur État par région
 # Trouver l’État générant le plus de CA dans chaque région
 WITH CA_state AS (
 SELECT Region, State, SUM(Sales) AS CA_total
 FROM superstore_clean
 GROUP BY Region, State),
 CA_region_state AS(
 SELECT Region, State, CA_total, RANK() OVER (PARTITION BY Region ORDER BY CA_total DESC) AS rang
 FROM CA_state)
 SELECT Region, State, CA_total, rang
 FROM CA_region_state
 WHERE rang = 1;

--- Détecter les commandes en doublon
# Vérifier si certaines commandes présentent plusieurs dates de commande ou plusieurs modes d’expédition
SELECT order_id, COUNT(DISTINCT order_date) AS nb_dates, COUNT(DISTINCT ship_mode) AS nb_modes
FROM superstore_clean
GROUP BY order_id
HAVING nb_dates > 1 OR nb_modes > 1;
# Aucune commande ne présente ces incohérences dans les colonnes examinées.

--- CA cumulé au fil du temps
# Calculer le chiffre d’affaires cumulé mois après mois
WITH CA_mensuel AS (
SELECT YEAR(order_date) AS annee, MONTH(order_date) AS mois, SUM(Sales) AS CA_mensuel
FROM superstore_clean
GROUP BY annee, mois)
SELECT annee, mois, CA_mensuel, SUM(CA_mensuel) OVER (ORDER BY annee, mois) AS CA_cumule
FROM CA_mensuel
ORDER BY annee, mois;

--- Synthèse commerciale
# Produire une synthèse par région et catégorie pour comparer les performances commerciales
WITH performance AS (
SELECT Region, Category, SUM(Sales) AS CA_total, COUNT(DISTINCT order_id) AS nb_commandes, COUNT(DISTINCT customer_id) AS nb_clients
FROM superstore_clean
GROUP BY Region, Category)
SELECT Region, Category, CA_total, nb_commandes, nb_clients, ROUND ((CA_total / nb_commandes), 2) AS CA_moyen_par_commande
FROM performance;



