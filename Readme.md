# File Restore and Versioning

This application is an add on to SyncBack Pro to aid in the location and restoration of backups made with SyncBack Pro on Windows PCs.  To this end, 2 context (right click) entries are made in Windows Explorer called Find Backup and Versions.



![2025-12-30-16-28-12-image.png](D:\Documents\AutoIT\Images\2025-12-30-16-28-12-image.png)

The "Find Backup" selection takes you to your backup directory consistent with the folder structure setup intitially.  This selection is valid for selected files and folders.

The "Versions" selection is valid if versioning is turned on in SyncBack and versioning folders ($SBV folders) are present in each download directory (rather than having one version folder).  So a backup folder may look like this:

![2025-12-30-16-33-12-image.png](D:\Documents\AutoIT\Images\2025-12-30-16-33-12-image.png)



## Prerequisites

There are a few items that need to be installed:

- You first must install **SyncBack Pro** (or the paid SyncBack SE).  This program makes the necessary backup file structure. (Minorly, the icon in these context menu items come from the SyncBack Pro program)

- This application is written in **AutoIT**, but you do not absolutely need it.  You may download AutoIT (Open source) at https://www.autoitscript.com.  You may want to take tutorials on AutoIT before making changes to the app.  You do NOT need AutoIT to run this application "as is".

## Installation

To install this application follow thse setps.

1. Copy the files to a folder on your PC.  It makes no difference where the folder is but it should be on a local, lettered drive.

2. Click each of the following to run to setup
   
   "FindBackup.exe"
   
   "Version.exe"
   
   You will need to allow these programs to have administrator access to update your registry.  The registry is updated so that the programs will either make entries to allow them to run on a context menu (or if the entry is there, they will delete the entry).
   
   ### Mirror.ini
   
   You will be prompted to make a file called "Mirror.ini".  This file is placed in the root directory of the current drive.  This file needs to exist at the root of each drive that is backed up.  This is a text file with the path prefix to the backup directory for this drive.  For example, the backup location for the D: drive might be in "G:\Backups\D-Drive" (this string would go in the ini file).
   
    

## Usage

Once the installation is complete, the context menu entries are ready to use.  Simply right click!

### Find Backup

Right-clicking Find Backup will take you to the appropriate backup directory for the starting source directory in a new window.  From there, you can do whatever is needed with your backup files with Windows Explorer

### Version

If you have versions turned on with SyncBack, this will launch a GUI that simplifies what file versions are available and allows you to restore (default is to the Desktop).  Version is only available of Files since Folders are not versioned per se.

So, right-clicking on a file might take you to a screen that looks like this:

![2025-12-30-16-55-11-image.png](D:\Documents\AutoIT\Images\2025-12-30-16-55-11-image.png)

This is a list of all versions that SyncBack made of the given input file in descending order of modification date.  Other dates are provided for reference as is the file name of the backup or version.  Just click on a row and push "Restore This Version" and you will be presented with a "Save" dialog that defaults to the desktop.  Once the file is restored, you are free to replace or restore the source file.

## Deinstalling

Deinstalling is very simple:

1. Go to the installation directoy you selected, above

2. Click "FileBackup.exe" and answer yes to running in admin mode.

3. Click Yes to allow program to delete this registry entry.

4. Clock "Versions.exe" and answer yes to running in admin mode.

5. Click Yes to allow program to delete this registry entry.

6. Delete any "Mirror.ini" files in the drive root folders.

7. Delete the installation directory and files.
