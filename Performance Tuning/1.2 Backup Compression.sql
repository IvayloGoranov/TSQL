/*============================================================================
	File:		1.2 Backup Compression 2012.sql

	Summary:	The script demonstrates the diffence between backing up
				a database with compression enabled and disabled. It shows
				how you can easily lower the I/O and perform faster backup
				and restores.

				THIS SCRIPT IS PART OF THE Lecture: 
				"Performance Tuning" for SoftUni, Sofia

	Date:		February 2015

	SQL Server Version: 2012, 2014
------------------------------------------------------------------------------
	Written by Boris Hristov, SQL Server MVP

	This script is intended only as a supplement to demos and lectures
	given by Boris Hristov.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/

-- Backup the database without compression
-- Check the size on the disk

BACKUP DATABASE [Credit] TO  DISK = 
N'E:\2012\CreditBackup.bak' 
WITH NOFORMAT, NOINIT,  
NAME = N'Credit-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

-- Backup the database with compression
-- Check and compare the size on the disk
-- Discuss the difference and what an impact it makes
BACKUP DATABASE [Credit] TO  DISK = 
N'E:\2012\CreditBackup100.bak' 
WITH NOFORMAT, NOINIT,  
NAME = N'Credit-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO
