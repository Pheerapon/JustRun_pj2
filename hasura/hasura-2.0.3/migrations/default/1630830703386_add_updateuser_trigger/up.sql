DROP TRIGGER IF EXISTS update_user ON "public"."RunHistory" CASCADE;
DROP FUNCTION IF EXISTS update_user_money() CASCADE;
CREATE FUNCTION update_user_money()
RETURNS trigger AS $BODY$
DECLARE oldMoney INTEGER;
DECLARE oldTotalDistance FLOAT;
DECLARE totalDistances FLOAT;
DECLARE newTotalDistance FLOAT;
DECLARE listBadge int[];
DECLARE listNewBadge int[];
BEGIN
    --Update money,total_distance
    SELECT money,total_distance,badges INTO oldMoney,oldTotalDistance,listBadge FROM "public"."User" WHERE id = NEW.user_id;
    IF oldTotalDistance <= 0 THEN
      SELECT SUM(distance) INTO totalDistances FROM "public"."RunHistory" WHERE user_id = NEW.user_id;
      oldTotalDistance = totalDistances;
    END IF;
    newTotalDistance = (oldTotalDistance + NEW.distance);
    
    --Update badges
    IF newTotalDistance < 1 THEN listNewBadge = listBadge;
    ELSIF (newTotalDistance >= 1 AND newTotalDistance < 5 AND array_position(listBadge,1) IS NULL) 
        THEN listNewBadge = array_append(listBadge,1);
    ELSIF (newTotalDistance >= 5 AND newTotalDistance < 16 AND array_position(listBadge,2) IS NULL) 
        THEN listNewBadge = array_append(listBadge,2);
    ELSIF (newTotalDistance >= 16 AND newTotalDistance < 21 AND array_position(listBadge,3) IS NULL) 
        THEN listNewBadge = array_append(listBadge,3);
    ELSIF (newTotalDistance >= 21 AND newTotalDistance < 40 AND array_position(listBadge,4) IS NULL) 
        THEN listNewBadge = array_append(listBadge,4);
    ELSIF (newTotalDistance >= 40 AND newTotalDistance < 80 AND array_position(listBadge,5) IS NULL) 
        THEN listNewBadge = array_append(listBadge,5);
    ELSIF (newTotalDistance >= 80 AND newTotalDistance < 150 AND array_position(listBadge,10) IS NULL) 
        THEN listNewBadge = array_append(listBadge,10);
    ELSIF (newTotalDistance >= 150 AND array_position(listBadge,11) IS NULL) 
        THEN listNewBadge = array_append(listBadge,11);
    ELSE listNewBadge = listBadge;
    END IF;
    
    UPDATE "User" SET (money,total_distance,badges) = ((oldMoney + New.money),newTotalDistance,listNewBadge)
    WHERE id = NEW.user_id;
    --End Update badges,money,total_distance
    
RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;
    
CREATE TRIGGER update_user
AFTER INSERT OR UPDATE ON "public"."RunHistory" 
FOR EACH ROW EXECUTE PROCEDURE update_user_money();
