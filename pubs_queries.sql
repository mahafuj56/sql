-- PUBS Database Queries SQL Script

USE PUBS;
GO

-- a. Show book title, author name (first initial + last name), publisher name
SELECT 
    t.title AS Book_Title,
    LEFT(a.fname,1) + '. ' + a.lname AS Author_Name,
    p.pub_name AS Publisher_Name
FROM titles t
JOIN titleauthor ta ON t.title_id = ta.title_id
JOIN authors a ON ta.author_id = a.author_id
JOIN publishers p ON t.pub_id = p.pub_id;

GO

-- b. Titles with total quantity sold > 40, sorted ascending
SELECT 
    t.title AS Book_Title,
    SUM(s.qty) AS Total_Qty_Sold
FROM titles t
JOIN sales s ON t.title_id = s.title_id
GROUP BY t.title
HAVING SUM(s.qty) > 40
ORDER BY Total_Qty_Sold ASC;

GO

-- c. Stored Procedure to increase price until desired average
CREATE PROCEDURE IncreasePriceUntilAvg
    @CategoryName VARCHAR(50),
    @DesiredAvgPrice FLOAT
AS
BEGIN
    DECLARE @CurrentAvg FLOAT;

    -- Compute current average price
    SELECT @CurrentAvg = AVG(price)
    FROM titles
    WHERE type = @CategoryName;

    -- Loop until current average >= desired
    WHILE @CurrentAvg < @DesiredAvgPrice
    BEGIN
        -- Increase each price by 10%
        UPDATE titles
        SET price = price * 1.10
        WHERE type = @CategoryName;

        -- Recalculate current average
        SELECT @CurrentAvg = AVG(price)
        FROM titles
        WHERE type = @CategoryName;
    END
END;
GO

-- Example execution of the procedure
-- EXEC IncreasePriceUntilAvg 'Fiction', 50.0;