#! /usr/bin/env bash

MY_PWD=$(pwd);
PACKAGE_DIR="com/thalesgroup";
PACKAGE_NAME="com.thalesgroup";
CLASS_NAME="App";
FULL_PACKAGE_NAME="${PACKAGE_NAME}.${CLASS_NAME}";
BUILD_DIR="app/bin";
SRC_DIR="app/src";
RES_DIR="app/res";
LARGE_FILE="bigfile.bin";

# Show Java version
java -version;
JAVA_RETURN_CODE=$?;
echo ""

# Java was able to execute?
if [ $JAVA_RETURN_CODE -gt 0 ]; then
    # Exit with failure
    echo "Unable to run 'java -version'";
    exit $JAVA_RETURN_CODE;
fi

# Make the large file here
echo 'Generating large file';
dd if=/dev/urandom of="${MY_PWD}/${RES_DIR}/${LARGE_FILE}" bs=64M count=32 iflag=fullblock;
echo ""

# Build the class definition
echo 'Generating class definitions';
cd "${MY_PWD}/$SRC_DIR";
javac -d "${MY_PWD}/${BUILD_DIR}/classes" "${PACKAGE_DIR}/${CLASS_NAME}.java";
echo ""

# Build the jar
echo 'Packaging jar file'
cd "${MY_PWD}/${BUILD_DIR}/classes";
jar cfe "${MY_PWD}/${BUILD_DIR}/jar/${CLASS_NAME}.jar" ${FULL_PACKAGE_NAME} "${PACKAGE_DIR}/${CLASS_NAME}.class" "../../res/${LARGE_FILE}";
echo ""

# Show contents of jar
echo 'Contents of jar:';
jar tf "${MY_PWD}/${BUILD_DIR}/jar/${CLASS_NAME}.jar";
echo ""

# Run the jar
echo 'Running of jar:';
echo ""
cd "${MY_PWD}";
java -jar "${MY_PWD}/${BUILD_DIR}/jar/${CLASS_NAME}.jar";
