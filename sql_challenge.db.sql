-- Task 1
-- Finde den umsatzstärksten Tag der Filiale "Essen Kettwiger Str"
SELECT Tag, COUNT(*) AS transaction_count -- Zählt die Gesamtanzahl der Transaktionen pro Tag
FROM sales
WHERE Filiale = 'Essen Kettwiger Str' -- Konzentration nur auf die Essen filiale
GROUP BY Tag
ORDER BY transaction_count DESC -- Sortierung 
LIMIT 1; -- 	Nur einen Tag anzeigen

-- Task 2
-- Berechnet die Gesamtanzahl der Transaktionen je Filiale für den Zeitraum nach dem 07.02.2023
SELECT 
    Filiale,  -- Der Name der Filiale aus der Verkaufstabelle
    COUNT(*) AS transaction_count  -- Zählt alle Transaktionen pro Filiale
FROM sales  -- Verwendet die Verkaufstabelle für die Abfrage
WHERE Tag > '2023-02-07'  -- Berücksichtigt nur Verkaufstage nach dem 7. Februar 2023
GROUP BY Filiale  -- Gruppiert die Ergebnisse nach Filiale
ORDER BY transaction_count DESC;  -- Sortiert die Filialen nach der Anzahl der Transaktionen absteigend

-- Task 3
-- Finde das gewinnbringendste Produkt. Vergiss nicht für jeden Kreditkartenverkauf 1,50€ abzuziehen
SELECT 
    p.product_nr,  -- Produkt-Nummer aus der Product table
    p.name,  -- Produktname aus der Product table
    SUM(
        CASE -- Fall unterscheidung zwischen zahlung mit und ohne Kreditkarte
            WHEN s.Zahlungsmittel = 'Kreditkarte' THEN (p.verkaufspreis - p.einkaufspreis - 1.50)  
            ELSE (p.verkaufspreis - p.einkaufspreis) 
        END
    ) AS net_profit  -- Sum von Netto-Gewinn für jedes Produkt
FROM sales s
JOIN products p ON s.product_nr = p.product_nr  -- Join von Verkaufs- und Produkttabellen anhand der Produkt-Nummer
GROUP BY p.product_nr, p.name  -- Gruppiert die Ergebnisse nach Nummer und Name von Product 
ORDER BY net_profit DESC  -- Sortiert die Ergebnisse nach dem Netto-Gewinn absteigend
LIMIT 1;  -- Limit zu nur das erste product

-- Bonus Task 4
-- Erstellt einen Rang für Produkte basierend auf ihrem Umsatz, wobei das umsatzstärkste Produkt Rang 1 erhält
SELECT 
    p.product_nr,  -- Produkt-Nummer
    p.name,  -- Produktname
    SUM(p.verkaufspreis * (CASE WHEN s.Zahlungsmittel = 'Kreditkarte' THEN 1.50 ELSE 0 END)) AS total_revenue,  -- Berechnet den Gesamtumsatz unter Berücksichtigung von Kreditkartengebühren
    RANK() OVER (ORDER BY SUM(p.verkaufspreis * (CASE WHEN s.Zahlungsmittel = 'Kreditkarte' THEN 1.50 ELSE 0 END)) DESC) AS revenue_rank  -- Ordnet jedem Produkt einen Rang basierend auf dem Umsatz zu
FROM sales s
JOIN products p ON s.product_nr = p.product_nr  -- Verknüpft die Verkaufs- und Produkttabellen
GROUP BY p.product_nr, p.name  -- Gruppiert die Daten nach Produkt-Nummer und -Name
ORDER BY revenue_rank;  -- Sortiert die Produkte nach ihrem Umsatzrang









