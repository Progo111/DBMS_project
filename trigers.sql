DELIMITER $$

CREATE TRIGGER trg_jewelry_insert_set_pledges_category
AFTER INSERT ON Jewelry
FOR EACH ROW
BEGIN
  UPDATE Pledges
    SET category = 'Jewelry'
  WHERE pledge_id = NEW.pledge_id;
END$$

CREATE TRIGGER trg_ha_insert_set_pledges_category
AFTER INSERT ON HomeAppliances
FOR EACH ROW
BEGIN
  UPDATE Pledges
    SET category = 'HomeAppliances'
  WHERE pledge_id = NEW.pledge_id;
END$$

DELIMITER ;