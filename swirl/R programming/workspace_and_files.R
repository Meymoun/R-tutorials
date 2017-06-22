# get working directory
getwd()

# list all objects in local workspace
ls()

# assign 9 to x
x <- 9

# again list objects in local workspace
ls()

# list all the files in working directory
list.files()

# or: dir()

# go to help page for list files
?list.files

# determine the arguments to list.files()
args(list.files)

# assign the value of the current working directory a variable called "old.dir"
old.dir <- getwd()

# create a directory in the current working directory
dir.create('testdir')

# set your working directory to testdir
setwd('testdir')

# create file
file.create(mytest.R)

# list files in current directory
dir()

# check if file exists in wd
file.exists('mytest.R')

# get info about file
file.info('mytest.R')

# rename file, file.rename(from, to)
file.rename('mytest.R', 'mytest2.R')

# copy file
file.copy('mytest2.R', 'mytest3.R')

# provide relative path to file
file.path('mytest3.R')

# create a platform-independent pathname
# seems like it is useful if you work in several systems (eg UNIX and windows) with different ways to seperate the directories
# might be useful to set a shortcut for a relative path, 
# eg. A <- file.path('~', 'folder1', 'folder2')
# setwd(A)

file.path('folder1', 'folder2')
# output: [1] "folder1/folder2"

# create a directory in current wd and a subdirectory for it
# recursive = TRUE, if elements of the path other than the last should be created
dir.create(file.path('testdir2', 'testdir3'), recursive = TRUE)

# go back to original wd (saved as old.dir)
setwd(old.dir)

# remove folder and its content
unlink('testdir', recursive = TRUE)
