CREATE TABLE carDescrition ( 
carID int, 
carName VARCHAR (100)
); 

INSERT INTO carDescrition VALUES (101,'Mercedes-Benz');
INSERT INTO carDescrition VALUES (201,'BMW');
INSERT INTO carDescrition VALUES (301,'Ferrari');
INSERT INTO carDescrition VALUES (401,'Lamborghini');
INSERT INTO carDescrition VALUES (501,'Porsche');

SELECT * FROM carDescrition; 

CREATE OR REPLACE FUNCTION CAR()
RETURN TABLE( 
CarID int, CarName VARCHAR (800), 
CarDescription VARCHAR (800)
)
AS $$ 
BEGIN 
RETURN QUERY 
SELECT C.CarID, C.CarName, 
CDCarDescription,
FROM car C
INNER JOIN CarDescription CD on c.CarlID = CD.CarlID; 

AND 
$$LANGUADE plpgsql;