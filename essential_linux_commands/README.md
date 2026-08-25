# Essential Linux Commands

Linux has GUI (Graphical User Interface) environments, but it is also widely used through the command line interface (CLI). The command line allows users to interact with the operating system by typing commands into a terminal. This method can be more efficient for certain tasks, especially for system administration, scripting, and automation.

This document provides a list of essential Linux commands that are commonly used in various scenarios. These commands cover file management, system monitoring, networking, and more. Understanding and mastering these commands can significantly enhance your productivity and effectiveness when working with Linux systems.

Creating and Navigating Directories:

- `pwd`: Print the current working directory.
- `ls`: List the contents of a directory.
- `ls -la`: List all files, including hidden files, with detailed information.
- `cd <directory>`: Change the current directory to the specified one.
- `mkdir <directory>`: Create a new directory.
- `rmdir <directory>`: Remove an empty directory.
- `rm -rf <directory>`: Remove a directory and all its contents.
- `tree`: Display the directory structure in a tree-like format. (Note: You may need to install the `tree` command using your package manager, e.g., `sudo apt install tree` on Debian-based systems, `sudo dnf install tree` on Red Hat-based systems, `sudo pacman -S tree` on Arch-based systems.)
- `touch`: Create a new empty file or update the timestamp of an existing file.
- `cp <source> <destination>`: Copy files or directories from source to destination. For example, `cp ~/Documents/shortcuts.md ~/Desktop/Private/` will copy the `shortcuts.md` from the `Documents` directory to the `Private` directory on the Desktop.
- `mv <source> <destination>`: Move or rename files or directories. For example, `mv ~/Documents/shortcuts.md ~/Desktop/Private/` will move the `shortcuts.md` from the `Documents` directory to the `Private` directory on the Desktop. It can also be used to rename files, e.g., `mv oldname.txt newname.txt` will rename `oldname.txt` to `newname.txt`.


# Permissions and Ownership:

The permissions in Linux determine who can read, write, or execute a file or directory. Understanding and managing permissions is crucial for system security and proper access control. 

The permissions are represented by a combination of letters and symbols, indicating the access rights for the owner, group, and others. The basic permissions are:
- `r` (read): Allows reading the file or listing the directory.
- `w` (write): Allows writing to the file or creating/deleting files in the directory.
- `x` (execute): Allows executing the file or accessing the directory.
- `-` (no permission): Indicates that the corresponding permission is not granted.
- The permissions are displayed in a string of 10 characters, where the first character indicates the file type (e.g., `-` for regular files, `d` for directories), and the next nine characters represent the permissions for the owner, group, and others.


Let's take the following example of a file with permissions `-rwxrwxrwx`:

- The first character `-` indicates that it is a regular file. 

The next 9 characters are divided into three groups based on the index: 

- The first group (index 1-3) represents the owner's permissions: `rwx` means the owner has read, write, and execute permissions.
- The second group (index 4-6) represents the group's permissions: `rwx` means the group has read, write, and execute permissions.
- The third group (index 7-9) represents others' permissions: `rwx` means others have read, write, and execute permissions.

Let's take another example of a file with permissions `-rw-r--r--`:

- The first character `-` indicates that it is a regular file.
- Now take the next 3 characters which represent the owner's permissions: `rw-` means the owner has read and write permissions, but not execute permission. 
- The next 3 characters represent the group's permissions: `r--` means the group has read permission only, but not write or execute permissions.
- The last 3 characters represent others' permissions: `r--` means others have read permission only, but not write or execute permissions.

We can change the permissions of a file or directory using the `chmod` command. The `chmod` command allows us to modify the permissions for the owner, group, and others based on the following numeric values:
- `4`: Read permission
- `2`: Write permission
- `1`: Execute permission
- `0`: No permission

Let's assume that you want to change the permissions of a file named `example.txt` to allow the owner to read and write, the group to read only, and others to have no permissions. You can use the following command:

```bash
chmod 640 example.txt
```

The important part is `640` which has 3 digits. 
- The first digit `6` represents the owner's permissions. It is calculated by adding the values for read (4) and write (2), resulting in 6.
- The second digit `4` represents the group's permissions. It is calculated by adding the value for read (4), resulting in 4.
- The third digit `0` represents others' permissions. It indicates that others have no permissions, resulting in 0.

Let's think another scenario, where you have a directory with permissions `drwxr-xr--`. You want to change the permissions of this directory to allow the owner to read, write, and execute, the group to read and write, and others to have no permissions. Here is the algorithm: 

- Owner permissions must be set to *read, write, execute*: `rwx` = 4 (read) + 2 (write) + 1 (execute) = 7
- Group permissions must be set to *read, write*: `r-x` = 4 (read) + 2 (write) = 6
- Others permissions must be set to *no permissions*: `0--` = 0 (no permissions) = 0

So, the command to change the permissions of the directory would be:

```bash
chmod 760 directory_name
```

Briefly, the following numbers represent the permissions for the owner, group, and others:
- `7`: Read, write, and execute permissions (rwx)
- `6`: Read and write permissions (rw-)
- `5`: Read and execute permissions (r-x)
- `4`: Read permission only (r--)
- `3`: Write and execute permissions (wx)   
- `2`: Write permission only (w--)
- `1`: Execute permission only (x--)
- `0`: No permissions (---)


# Mounting and Unmounting Drives:

Firstly, you should identify the partitions and drives: 

```bash
lsblk
```

You will see the following, for example:

```text
❯ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 931,5G  0 disk
├─sda1   8:1    0     1G  0 part /boot/efi
├─sda2   8:2    0   280G  0 part /run/media/vasif/Storage
├─sda3   8:3    0   450G  0 part /
├─sda4   8:4    0    16M  0 part
└─sda5   8:5    0 200,5G  0 part
zram0  253:0    0  11,6G  0 disk [SWAP]
```

If you want to mount for example sda1, you should assign a mount point for it. You can create a directory for this purpose, for example:

```bash
sudo mkdir /mnt/mydrive
```

Then, you can mount the drive using the following command:

```bash
sudo mount /dev/sda1  /mnt/mydrive
```

After you are done with the drive, you can unmount it using the following command:

```bash
sudo umount /mnt/mydrive
```

Let's think the following scenario. You have dual boot on your system: Linux CachyOS and Windows 11. You want to mount your Windows partition to access your files and copy your Documents folder contents to your Linux home directory. You can follow these steps:

1. Identify the Windows partition using `lsblk`. It is usually formatted as NTFS. Let's assume it is `/dev/sda3`
2. Create a mount point for the Windows partition:

```bash
sudo mkdir /mnt/windows
```


1. Mount the Windows partition:

```bash
sudo mount /dev/sda3 /mnt/windows
```


After that command executed succesfully, in that directory you will see your files, documents and so on which are stored in your Windows partition. In reality, your Windows files are not physically copied to that mount point, but it is a virtual representation of the files on that partition. You can access and manipulate the files as if they were located in that directory. However, any changes you make to the files in that mount point will directly affect the files on the Windows partition. If you want to physically copy the files from that mount point to your Linux home directory, apply the following step.



4. Copy the contents of your Documents folder to your Linux home directory:

```bash
cp -r /mnt/windows/Users/YourUsername/Documents/* ~/Documents/
```

5. Unmount the Windows partition when you are done:

```bash
sudo umount /mnt/windows
```

This is the fastest way to access your Windows files from Linux and copy them to your home directory.


Let's think another scenario. There is a Storage partition that in /sda2. You want to have access to it from the file manager (nautilus, dolphin, thunar, etc.) and you want it to be mounted automatically on boot. This happens because the ext4 partition assigns ownership to the root user by default, and you need to change it to your user. You can follow these steps:

1. Identify the partition using `lsblk`. Let's assume it is `/dev/sda2` Make sure that it is mounted. If it is not mounted, you can mount it using the following command:

```bash
sudo mount /dev/sda2 /run/media/vasif/Storage
```

After mounting, it will appear in your file manager with the arrow icon and property of root. You can check the ownership using the following command:

```bash
ls -l /run/media/vasif/Storage
```

2. Change the ownership of the partition to your user. You can use the `chown` command to change the ownership recursively:

```bash
sudo chown -R $USER:$USER /run/media/vasif/Storage
```

- `-R`: Recursively change ownership for all files and directories within the specified path.
- `$USER`: This is an environment variable that represents the current logged-in user. It will automatically be replaced with your username when you run the command.
- `$USER:$USER`: This specifies the new ownership for both the user and group. The first `$USER` sets the owner to your username, and the second `$USER` sets the group to your username as well.
- `/run/media/vasif/Storage`: This is the path to the partition that you want to change ownership for. Make sure to replace it with the actual path of your mounted partition.

Now you have access to the Storage partition from your file manager, and it will be mounted automatically on boot. You can also check the ownership again using the `ls -l` command to confirm that it has been changed to your user.

In order to copy files from that mount into your home directory, you can use the following command:

```bash
cp -r /run/media/vasif/Storage/* ~/Documents/
```

# Search and Find Files

To search and find the files in Linux system, `find` command is used. It allows you to search for files and directories based on various criteria such as name, type, size, modification time, and more. The basic syntax of the `find` command is as follows:

- `find <path> <criteria>` : this command searches for files and directories starting from the specified `<path>` and applies the given `<criteria>` to filter the results. For example, to search for a file named `example.txt` in the current directory and its subdirectories, you can use the following command:

```bash
find . -name "example.txt"
```

To search for files with a specific extension, you can use the `-name` option with a wildcard. For example, to find all `.txt` files in the `/home/user/Documents` directory, you can use the following command:

```bash
find /home/user/Documents -name "*.txt"
``` 

To search for files based on their size, you can use the `-size` option. For example, to find all files larger than 100MB in the `/home/user/Downloads` directory, you can use the following command:

```bash
find /home/user/Downloads -size +100M
```

You can combine multiple criteria using logical operators. For example, to find all `.txt` files larger than 100MB in the `/home/user/Documents` directory, you can use the following command:

```bash
find /home/user/Documents -name "*.txt" -size +100M
``` 

To search directories (not files), you can use the `-type` option with the value `d`. For example, to find all directories named `backup` in the `/home/user` directory, you can use the following command:

```bash
find /home/user -type d -name "backup"
```

If you know the name of the file but not as case sensitive, you can use the `-iname` option instead of `-name`. For example, to find a file named `example.txt` regardless of case in the `/home/user/Documents` directory, you can use the following command:

```bash
find /home/user/Documents -iname "example.txt"
``` 

You can search for files based on their modification time using the `-mtime` option. For example, to find all files modified in the last 7 days in the `/home/user/Documents` directory, you can use the following command:

```bash
find /home/user/Documents -mtime -7
```

If you want to search for files based on their access time, you can use the `-atime` option. For example, to find all files accessed in the last 30 days in the `/home/user/Documents` directory, you can use the following command:

```bash
find /home/user/Documents -atime -30
```

You can also search for files based on their creation time using the `-ctime` option. For example, to find all files created in the last 15 days in the `/home/user/Documents` directory, you can use the following command:

```bash
find /home/user/Documents -ctime -15
```


# Search inside files

You can search for specific text or patterns inside files using the `grep` command without opening the file. The basic syntax of the `grep` command is as follows:

```bash
grep [options] "pattern" <file>
```

For example, to search for the word "password" in a file named `config.txt`, you can use the following command:

```bash
grep "password" config.txt
```

If you want to search case-insensitively, you can use the `-i` option. For example, to search for the word "password" in a case-insensitive manner in the `config.txt` file, you can use the following command:

```bash
grep -i "password" config.txt
```

You can search the pattern from all the files in a directory and its subdirectories using the `-r` option. For example, to search for the word "password" in all files within the `/home/user/Documents` directory, you can use the following command:

```bash
grep -r "password" /home/user/Documents
``` 

You can also search for a specific pattern in files with a certain extension using the `--include` option. For example, to search for the word "password" in all `.txt` files within the `/home/user/Documents` directory, you can use the following command:

```bash
grep -r --include="*.txt" "password" /home/user/Documents
```

You can search for multiple patterns using the `-e` option. For example, to search for the words "password" and "username" in a file named `config.txt`, you can use the following command:

```bash
grep -e "password" -e "username" config.txt
```


You can also use `awk` command to search for specific text or patterns inside files. The basic syntax of the `awk` command is as follows:

```bash
awk '/pattern/ {print}' <file>
```

For example, to search for the word "password" in a file named `config.txt`, you can use the following command:

```bash
awk '/password/ {print}' config.txt
``` 

- `/pattern/`: This is the search pattern you want to look for. In this case, it is "password". You can replace it with any other word or regular expression you want to search for.
- `{print}`: This action tells `awk` to print the entire line that matches the specified pattern. You can modify this action to perform other operations, such as printing specific fields or performing calculations. These actions are too advanced for this document, but you can learn more about them in the `awk` manual or online resources.s
- `<file>`: This is the name of the file you want to search in. You can replace it with the actual file name or path to the file you want to search.    


# Redirecting Output and Piping

You can write the output of a command to a file instead of displaying it on the terminal using the `>` operator. For example, to save the output of the `ls` command to a file named `file_list.txt`, you can use the following command:

```bash
ls > file_list.txt
```

This command will create a new file named `file_list.txt` (or overwrite it if it already exists) and write the output of the `ls` command to that file. If you want to append the output to an existing file instead of overwriting it, you can use the `>>` operator. For example:

```bash
echo "Line 2" >> notes.txt
```

- `echo` command is used to print the specified text to the terminal. In this case, it prints "Line 2".
- `>>` operator appends the output to the specified file (`notes.txt`) instead of overwriting it. If the file does not exist, it will be created.
- `notes.txt` is the name of the file where the output will be appended. You can replace it with any other file name or path as needed.


You can redirect the errors of a command to a file using the `2>` operator. For example, to save the errors of the `ls` command to a file named `error_log.txt`, you can use the following command:

```bash
ls /nonexistent_directory 2> error_log.txt
```

Or if you want to open application inside the terminal and log the errors to the log file then use the following command:

```bash
firefox 2> error_log.txt
```

- why `2`?: here 
  - `1` represents standard output (stdout)
  - `2` represents standard error (stderr)
  - `>` is the redirection operator that directs the output to a file. In this case, it redirects the standard error (stderr) to the specified file (`error_log.txt`).  


If you want to redirect both the standard output and standard error to the same file, you can use the `&>` operator. For example:

```bash
firefox &> output_log.txt
``` 



# Compressing and Archiving Files

In Linux, you will mainly deal with the following types of compressed files: `.tar`, `.gz`, `.bz2`, `.xz`, and `.zip`. 

To create `.tar.gz` archive, you can use the following command:

```bash
tar -czvf backup.tar.gz /path/to/folder
```

- `-c`: Create a new archive.
- `-z`: Compress the archive using gzip.
- `-v`: Verbose mode, which displays the progress of the archiving process.
- `-f`: Specify the name of the archive file (`backup.tar.gz`).

To extract a `.tar.gz` archive, you can use the following command:

```bash
tar -xzvf backup.tar.gz
```

- `-x`: Extract the contents of the archive.
- `-z`: Decompress the archive using gzip.
- `-v`: Verbose mode, which displays the progress of the extraction process.
- `-f`: Specify the name of the archive file (`backup.tar.gz`).



To create a `.zip` archive, you can use the following command:

```bash
zip -r backup.zip /path/to/folder
```

- `-r`: Recursively include all files and directories within the specified folder.

To extract a `.zip` archive, you can use the following command:

```bash
unzip backup.zip
```

To unzip a `.zip` archive to a specific directory, you can use the following command:

```bash
unzip backup.zip -d /path/to/destination
```

# Conclusion 

These are some of the essential Linux commands that can help you navigate and manage your system effectively. By mastering these commands, you can perform various tasks more efficiently and gain a deeper understanding of how Linux works.

There are many more commands available in Linux, and learning them can greatly enhance your productivity and capabilities as a user. I will continue to add new documentations to this repository, so keep updated with the latest changes. If you have any suggestions or requests for specific commands or topics, feel free to reach out and let me know.


















































