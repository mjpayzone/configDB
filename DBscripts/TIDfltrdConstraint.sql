USE [TerminalConfigs_dev_new]
GO

CREATE UNIQUE NONCLUSTERED INDEX idx_unq_TID
ON Terminal(TERMINAL_ID)
WHERE (TERMINAL_ID IS NOT NULL and TERMINAL_ID > 0)





