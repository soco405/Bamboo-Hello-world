######
#Don't use these, they are for reference
#######

#Dending on the size of the file you want to create, you can swap out varibles
$twoMBfile=2048576
$oneGBfile=1024288000
$twoGBfile=2048576000

#Creates a large file with plan and build identifiers.
$out = new-object byte[] $twoMBfile; 
(new-object Random).NextBytes($out); 
[IO.File]::WriteAllBytes('app\res\${bamboo.LargeFile}', $out)

# Show Java version
if ($JAVA_VERSION -gt 1)
{
Write-Output "$JAVA_VERSION"
}
else
{
exit 0
}
#Building Class Definitio
Write-Output 'Generating class definitions'
Set-Location -Path '.\app\src' -PassThru
javac -d "..\bin\classes\" ".\com\thalesgroup\App.java"

# Build the jar
Write-Output 'Packaging jar file'
Set-Location -Path '.\app\bin\classes' -PassThru
jar cfe "..\jar\App.jar" com.thalesgroup.App "com\thalesgroup\App.class" 

#need to add large file
Write-Output 'add large file'
Set-Location -Path '.\app' -PassThru
jar -uf .\bin\jar\App.jar res\${bamboo.LargeFile}
#show contents of Jar
jar tf ".\bin\jar\App.jar"
Write-Output 'Running jar file'
java -jar ".\bin\jar\App.jar"
