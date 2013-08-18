sql_scripts
===========

Some sql*plus scripts to analyze and manage Oracle databases.
My personal preference is to use these scripts in the 
Windows cmd-shell on my PC - and so my path settings for
temporary OS files are Windows-style.

Most of the scripts use the scripts save_settings.sql and
restore_settings.sql to save the initial sqlplus settings
in a temporary file in c:\temp and restore them after the
script execution. 

Of course all scripts are given without any warranty and 
should be checked carefully before they are used in a 
database (and especially in a production database).
