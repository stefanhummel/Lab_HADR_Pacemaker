-- db2 -td@ -vf app2.sql
connect to sample@
-- simulate some activity to generate log volume
-- periodically performing a COMMIT
BEGIN
  DECLARE MESSAGE  VARCHAR(100);
  DECLARE STATUS   INTEGER;
  DELETE FROM status;
  WHILE app2_count < 5000 DO
    INSERT INTO app2 ( SELECT * FROM SYSCAT.COLUMNS );
    DELETE FROM app2;
    INSERT INTO status VALUES ( app2_count );
    COMMIT;
    -- sleep for 1 seconds between packages 
    -- to allow ALSM log extraction to kick in
    -- CALL DBMS_ALERT.WAITONE('SLEEP_BY_SECONDS_NOT_REAL_ALERT',STATUS,MESSAGE,1);       
    SET app2_count = app2_count + 1;
  END WHILE; 
END @
-- display how many packages have been successfully processed
values( app2_count )@
