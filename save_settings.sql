-- -----------------------------------------------------------------------------
-- save_settings.sql
-- sichert sqlplus Variablen in einer externen Datei
-- -----------------------------------------------------------------------------

-- Sicherung der sqlplus-Variablen in einer externen Datei
set termout off
store set c:\temp\sqlplus_settings.sql replace
set termout on