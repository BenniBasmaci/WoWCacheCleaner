# WoWCacheCleaner
Apparently WoW is really bad at deleting unnecessarily huge amounts of cache data that can accumulate up to **hundreds of GB** for no good reason.
After finding that it was **33GB** on my machine, I decided to create some automatic mechanism to clean it for me.
This is a simple quick and dirty solution to do an automated monthly cleanup on those folders. 
Maybe this helps :)

#### Sites discussing the topic
https://www.icy-veins.com/wow/news/clear-out-these-wow-folders-and-instantly-free-up-to-50-gb-of-space/
https://www.reddit.com/r/wow/comments/1k45lic/reminder_to_clean_up_wasteful_files_in_your_world/

## Usage
Just run the WoWCacheCleanerInstaller.bat as administrator on your Windows machine.
You can run it from any folder. (e.g. Desktop or Download folder)

The batch script...
- locates your World of Warcraft folder
- creates a WoWCacheCleaner.bat in your ProgramData directory which deletes the cache
- creates a scheduled task that runs that generated script on startup

The generated WoWCacheCleaner.bat (not to be confused with the installer) has a check that only runs the deletion once a month.
Once the cache folders are deleted, a tiny part of them will be newly downloaded/generated the next time you launch the game. 
But instead of taking up half your hard drive, these folers will only take up around 250MB.
