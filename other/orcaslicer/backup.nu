#!/usr/bin/env nu

# backups files with blacklist in case something changes
glob ~/.config/OrcaSlicer/* --exclude [ system log cache user_backup-* printers ota ] | each { |e|
    echo $e;
    cp -r $e ./
}

# save backup date
date now | save -f ./last_save
