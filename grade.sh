
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission

rm -rf grading-area

mkdir grading-area

git clone $1 student-submission 
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# List-Examples-Grader/grading-area/student-submission and we are in grading-area
#where am I? is the grading-area inside list-examples-grader

# Then, add here code to compile and run, and do any post-processing of the
# tests
exist=`find ./student-submission -name "ListExamples.java"`
if [[ ! $exist == "./student-submission/ListExamples.java" ]]; then
        echo ListExamples.java not there
        exit 1
fi

cp student-submission/ListExamples.java grading-area/
cp GradeServer.java grading-area/
cp Server.java grading-area/
cp TestListExamples.java grading-area/
cp lib/hamcrest-core-1.3.jar grading-area/
cp lib/junit-4.13.2.jar grading-area/

cd grading-area

javac -cp .:hamcrest-core-1.3.jar:junit-4.13.2.jar *.java 2>compile.txt

if grep -q "error" "compile.txt"; then 
    cat compile.txt
    exit 1
fi

if [[ $? -ne 0 ]]; then
    echo Cannot compile java files
    exit 1
fi

java -cp .:hamcrest-core-1.3.jar:junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > output.txt

if grep -q "OK" "output.txt"; then
    echo Grade 100
    exit 0
fi

numberRun=$(grep -o 'run: [0-9]*' output.txt | grep -o '[0-9]*')


failure=$(grep -o 'Failures: [0-9]*' output.txt | grep -o '[0-9]*')


grep 'Tests run' output.txt

grade=$(($numberRun-$failure))

echo $grade
#echo $failure

#grep -o 'run: [0-9]*' output.txt





