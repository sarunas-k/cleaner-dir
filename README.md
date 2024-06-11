This CLI script makes your folders cleaner by grouping files by creation year, month or day.

**Steps to run automatically:**

> Prerequisites: Python installed, `python3` command
1.  Open your CLI console
1. `cd` to your desireable directory
1.  Paste in these commands
```
  curl -o cleanerdir.zip -L https://github.com/sarunas-k/cleaner-dir/archive/e4bf331493059b5864fc752c8c8d9ee5701f5f8c.zip
  python3 -m zipfile -e cleanerdir.zip ./
  mv cleaner-dir-e4bf331493059b5864fc752c8c8d9ee5701f5f8c/group_dir_files.sh ./group_dir_files.sh
  rm cleaner-dir-e4bf331493059b5864fc752c8c8d9ee5701f5f8c/*
  rmdir cleaner-dir-e4bf331493059b5864fc752c8c8d9ee5701f5f8c
  bash ./group_dir_files.sh
```
