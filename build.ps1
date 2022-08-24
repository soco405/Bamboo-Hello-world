#! /usr/bin/env bash

$JAVA_VERSION='(Get-Command java | Select-Object -ExpandProperty Version).tostring()'
$PACKAGE_DIR="com/thalesgroup"
$PACKAGE_NAME="com.thalesgroup"
$CLASS_NAME="App"
$FULL_PACKAGE_NAME="${PACKAGE_NAME}.${CLASS_NAME}"
$BUILD_DIR="app/bin"
$SRC_DIR="app/src"
$RES_DIR="app/res"
$LARGE_FILE="${bamboo.shortPlanName}-build-${bamboo.buildNumber}.file"
$FILE_SIZE=2048; #2MB file
#$FILE_SIZE=2048000; #Uncomment for 2GB file

#Dending on the size of the file you want to create, you can swap out varibles
$twoMBfile=2048576
$oneGBfile=1024288000
$twoGBfile=2048576000

#Creates a large file with plan and build identifiers.
$out = new-object byte[] $twoMBfile; 
(new-object Random).NextBytes($out); 
[IO.File]::WriteAllBytes("$RES_DIR\${LARGE_FILE}", $out)
Write-Output ""



# Show Java version
if ($JAVA_VERSION -gt 1)
{
Write-Output "$JAVA_VERSION"
}
else
{
exit 0
}
Write-Output ""

# Build the class definition
Write-Output 'Generating class definitions'
set-location "$SRC_DIR"
javac -d "${MY_PWD}\${BUILD_DIR}/classes' '${PACKAGE_DIR}\${CLASS_NAME}.java"
Write-Output ""

# Build the jar
Write-Output 'Packaging jar file'
set-location "${BUILD_DIR}\classes";
jar cfe "${BUILD_DIR}\jar\${CLASS_NAME}.jar" ${FULL_PACKAGE_NAME} "${PACKAGE_DIR}\${CLASS_NAME}.class" "..\../res\${LARGE_FILE}";
Write-Output ""

# Show contents of jar
Write-Output 'Contents of jar:';
jar tf "${BUILD_DIR}\jar/${CLASS_NAME}.jar"
Write-Output ""

# Run the jar
Write-Output 'Running of jar:'
Write-Output ""
java -jar "${BUILD_DIR}\jar\${CLASS_NAME}.jar"
