undo_drop is a set of functions whose purpose is to share the DROP schema changes with all stackholders(DBAs/SREs/Devs) before actually committing it to DB. Also, give them authority to kill it proactively in order to avoid unwanted drops/unaviodable circumstances.
