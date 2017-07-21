    USE [master]
    BACKUP LOG [ServerCalculator] TO DISK = N'ServerCalculator_LogBackup_2017-06-13T14-55-48.bak' WITH NOFORMAT, NOINT, NAME =N'ServerCalculator_LogBackup_2017-06-13T14-55-48', NOSKIP, NOREWIND, NORECOVERY, STATS = 5
    RESTORE DATABASE [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_11_000001_8224959.bak' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
    RESTORE DATABASE [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_11_000001_8224959.bak' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
    RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_003503_2339840.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_010503_6765548.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_013502_3065093.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_020503_7280165.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_023502_9843860.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_030503_0062444.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_033502_2413938.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_040502_7449690.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_043503_3084707.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_050502_8154144.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_053503_6265434.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_060503_8300415.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_063503_1664887.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_070502_0072314.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_073502_3968055.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_080503_7734231.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_083503_3609537.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_090502_6947324.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_093502_3829218.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_100502_8319852.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_103501_9938034.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_110503_4075622.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_113503_0500207.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_120503_5161720.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_123503_0230865.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_130503_9026847.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_133503_1530531.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_140503_9616729.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5
 RESTORE LOG [ServerCalculator] FROM  DISK = N'\\DB-R620-2\B$\SERVER_CALCULATOR\ServerCalculator_backup_2017_06_13_143502_3932285.trn' WITH  FILE = 1, NORECOVERY,  NOUNLOAD,  STATS = 5


    GO
