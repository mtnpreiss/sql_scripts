-- -----------------------------------------------------------------------------
-- restore_settings.sql
-- stellt sqlplus Variablen aus einer externen Datei wieder her
-- -----------------------------------------------------------------------------

-- Rückspielen der sqlplus-Variablen
@ c:\temp\sqlplus_settings.sql
set termout on