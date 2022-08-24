#! /usr/bin/env bash

$MY_PWD=$(get-location)
$PACKAGE_DIR="com/thalesgroup"
$PACKAGE_NAME="com.thalesgroup"
$CLASS_NAME="App"
$FULL_PACKAGE_NAME="${PACKAGE_NAME}.${CLASS_NAME}"
$BUILD_DIR="app/bin"
$SRC_DIR="app/src"
$RES_DIR="app/res"
$LARGE_FILE="bigfile.bin"
$FILE_SIZE=2048; #2MB file
#$FILE_SIZE=2048000; #Uncomment for 2GB file

# Show Java version
java -version;
JAVA_RETURN_CODE=$?
Write-Output ""

# Java was able to execute?
if ($JAVA_RETURN_CODE -gt 0)
    # Exit with failure
{ Write-Output "Unable to run 'java -version'"
    exit $JAVA_RETURN_CODE
}

# Make the large file here
Write-Output 'Generating large file'
#dd if=/dev/urandom of="${MY_PWD}\${RES_DIR}\${LARGE_FILE}" bs=1024 count=${FILE_SIZE} iflag=fullblock
$out = new-object byte[] $twoMBfile; 
(new-object Random).NextBytes($out); 
[IO.File]::WriteAllBytes('${MY_PWD}\${RES_DIR}\${LARGE_FILE}', $out)
Write-Output ""

# Build the class definition
Write-Output 'Generating class definitions'
set-location '${MY_PWD}\$SRC_DIR'
javac -d '${MY_PWD}\${BUILD_DIR}/classes' '${PACKAGE_DIR}\${CLASS_NAME}.java'
Write-Output ""

# Build the jar
Write-Output 'Packaging jar file'
set-location "${MY_PWD}\${BUILD_DIR}\classes";
jar cfe "${MY_PWD}\${BUILD_DIR}\jar\${CLASS_NAME}.jar" ${FULL_PACKAGE_NAME} "${PACKAGE_DIR}\${CLASS_NAME}.class" "..\../res\${LARGE_FILE}";
Write-Output ""

# Show contents of jar
Write-Output 'Contents of jar:';
jar tf "${MY_PWD}\${BUILD_DIR}\jar/${CLASS_NAME}.jar";
Write-Output ""

# Run the jar
Write-Output 'Running of jar:';
Write-Output ""
set-location "${MY_PWD}";
java -jar "${MY_PWD}\${BUILD_DIR}\jar\${CLASS_NAME}.jar";
