//导入框架，所有Cocoa框架都已经封装过了
import Cocoa

//基本变量
func variableTest(){
    //❓在调用变量时，如果 variable?.doSomeThing()中variable为nil,则返回nil，否则展开调用返回调用结果
    //由于这个原因，在swift中应该是没有基本类型了，比如int,bool,char *等等
    var variable:Int? = 2
    variable = nil
    
    var variable2:Bool = true
    variable2 = true
    
    
    enum Rank: Int{
        case Ace = 1
        case Two, Three, Four, Five, Six,
        Seven,
        Eight, Nine, Ten
        case Jack, Queen, King
        
        func description()->String{
            switch self{
            case .Ace:
                return "ace"
            case .Jack:
                return "Jack"
            case .King:
                return "King"
            case .Queen:
                return "Queen"
            default:
                return String (self.toRaw())
            }
        }
    }
    
    let ace = Rank.Ace
    let aceRawValue = ace.toRaw()
    ace.description()
    
    if let convertedRank = Rank.fromRaw(3){
        let threeDescription = convertedRank.description()
    }
}
variableTest();


//自定义类型
func selfDefinitionTypeTest(){
    var str = "Hello, playground"
    var equivalentEmptyArray = Array<Int>()
    equivalentEmptyArray += 4;
    
    struct MyType: Printable {
        var name = "Untitled"
        var description: String {  //默认的描述函数，打印的时候用
        return "MyType: \(name)"
        }
    }
    let value = MyType()
    println("Created a \(value)")
    
    struct MyType2: DebugPrintable {
        var name = "Untitled"
        var debugDescription: String {
        return "MyType: \(name)"
        }
    }
    let value2 = MyType2()
}
selfDefinitionTypeTest();


//元组,C++ 中std::tuple<T>, python内核类型
func tupleTest(){
    func tuple() -> (Double, Double, Double){
        return (5, 2, 7);
    }
    
    var (a,b,c) = tuple()
    a
    b
    c
    
    var ret = tuple()
    ret.0
    ret.1
    ret.2
}
tupleTest();


//模板测试
func templateTest(){
    struct TmpVar<T>{
        var integer = 2
        var string = "let's have a talk"
        init(var integer:Int){
            self.integer = integer
        }
    }
    
    func mySort< T > (var array:Array<TmpVar<T>>) -> Array<TmpVar<T>>{
        for x in 0 .. array.count-1 {
            if array[x].integer > array[x+1].integer {
                swap(&array[x], &array[x+1])
            }
        }
        return array
    }
    
    var myArray = [TmpVar<Int>(integer: 3), TmpVar(integer:102), TmpVar(integer:100)]
    var anotherArray = mySort(myArray)
    for x in anotherArray {
        print(x.integer)
    }
}
templateTest();


func ffpTest(){
    //函数式编程，
    //函数内嵌函数，改变外部值
    func returnFifteen() -> Int{
        var y = 10
        func add5(){
            y += 5
        }
        add5()
        return y
    }
    returnFifteen()
    
    func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
        func stepForward(input: Int) -> Int { return input + 1 }
        func stepBackward(input: Int) -> Int { return input - 1 }
        return backwards ? stepBackward : stepForward
    }
    var currentValue = -4
    let moveNearerToZero = chooseStepFunction(currentValue > 0)
    // moveNearerToZero now refers to the nested stepForward() function
    while currentValue != 0 {
        println("\(currentValue)... ")
        currentValue = moveNearerToZero(currentValue)
    }
    println("zero!")
    //摘录来自: Apple Inc. “The Swift Programming Language”。 iBooks. https://itun.es/us/jEUH0.l
    
    //函数返回函数
    func makeIncrementer() ->
        Double->Int{  //实际上是(Double)->Int,也就是一个函数
        func addOne(number:Double)->Int{
            return 1 + Int(number);
        }
        return addOne;
    }
    
    var increment = makeIncrementer()
    increment(7.0);
    
    func closuerTest(){
        var list:Int[] = [1,2,3]
        func hasAnyMatched(＃list:Int[],  //#符号表示这个表量和外部的变量是同一个变量
            var/*表示函数内部可以改变这个值，没有var相当于const*/
            Condition/*第二参数名*/ condition:Int->Bool) -> Bool{
            for item in list{
                if condition(item){
                    return true;
                }
            }
            return false
        }
        
        var numbers = [20, 19, 7, 12]
        var condition = { number in number < 10}
        var match = hasAnyMatched(numbers, condition)
        match
        
        numbers.map({
            (number:Int)->Int in
            return 3*number
            })
        //闭包的类型已知，不用给出参数类型，返回类型，简化版：
        var mappedValue = numbers.map({number in number+3})
        mappedValue
        numbers
    }
    closuerTest();
}
ffpTest();


//扩展类型
//protocol定义和扩展只能放在全局文件中
protocol Nothing{
}
extension Int{
    var simpleDescription:String{
        return "The number \(self)"
    }
    mutating func adjust(){
        self += 42
    }
}

func extensionTest(){
    var number = 7
    number.adjust()
    number.simpleDescription
}
extensionTest();


//In-Out Parameters
func In_Out_Parameters(){
    func swapTwoInts(inout a: Int, inout b: Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    var someInt = 3
    var anotherInt = 5
    
    swapTwoInts(&someInt, &anotherInt)
    someInt
    anotherInt
}
In_Out_Parameters();


//闭包
/*
Closure expression syntax has the following general form:

{ (parameters) -> return type in
    statements
}
*/
func ClosureTest(){
    var names = ["He", "Qinglong"]
    //传入一个闭包作为排序的条件函数
    var reversed = sort(names,  { (s1: String, s2: String) -> Bool in return s1 > s2 } )
    
    //由于sort的输入参数中，第一个参数的类型可以推导，所以闭包的参数类型也可以被推导出来，因此可以简写为：
    reversed = sort(names, {s1, s2 in return s1 < s2})
    
    //更进一步，隐式的返回类型
    reversed = sort(names, {s1, s2 in s1 < s2})
    
    /*Swift automatically provides shorthand argument names to inline closures,
    which can be used to refer to the values of the closure’s arguments 
    by the names $0, $1, $2, and so on.
    */
    reversed = sort(names, {$0 > $1})
    
    //尾随形式
    reversed = sort(names){ $0 > $1}
    //Here, $0 and $1 refer to the closure’s first and second String arguments
    
    /*Swift’s String type defines its string-specific implementation of the greater-than
    operator (>) as a function that has two parameters of type String,
    and returns a value of type Bool
    */
    reversed = sort(names, >)
    
    
    //尾随形式的解释：
    func someFunctionThatTakesAClosure(closure: () -> ()) {
        // function body goes here
    }
    
    // here's how you call this function without using a trailing closure:
    someFunctionThatTakesAClosure({
        // closure's body goes here
        })
    
    // here's how you call this function with a trailing closure instead:
    someFunctionThatTakesAClosure() {
        // trailing closure's body goes here
    }
    
    let digitNames = [
        0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
        5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine" ]
    let numbers = [16, 58, 510]
    
    let strings = numbers.map {
        (var number) -> String in
        var output = ""
        while number > 0 {
            output = digitNames[number % 10]! + output
            number /= 10
        }
        return output
    }
    strings
    // strings is inferred to be of type String[]
    // its value is ["OneSix", "FiveEight", "FiveOneZero"]
    
    
    //返回函数的函数
    func makeIncrementor(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementor() -> Int {
            runningTotal += amount
            return runningTotal
        }
        return incrementor
    }
}
ClosureTest();


//Type Methods,静态成员函数
func typeMethodsTest(){
    //在类里面使用class声明静态成员方法
    class SomeClass {
        var xx:Int = 0  //目前为止，没有实现类的静态成员变量
        class func someTypeMethod() {
            // type method implementation goes here
        }
    }
    SomeClass.someTypeMethod()
    //在结构体里面使用static声明静态成员方法 和 静态成员变量
    struct LevelTracker {
        static var highestUnlockedLevel = 1
        static func unlockLevel(level: Int) {
            if level > highestUnlockedLevel { highestUnlockedLevel = level }
        }
        static func levelIsUnlocked(level: Int) -> Bool {
            return level <= highestUnlockedLevel
        }
        var currentLevel = 1
        mutating func advanceToLevel(level: Int) -> Bool {
            if LevelTracker.levelIsUnlocked(level) {
                currentLevel = level
                return true
            } else {
                return false
            }
        }
    }
}
typeMethodsTest();


//class inheritance
func inheritance(){
    //Base lcass
    class Vehicle {
        var numberOfWheels: Int
        var maxPassengers: Int
        func description() -> String {
            return "\(numberOfWheels) wheels; up to \(maxPassengers) passengers"
        }
        init() {
            numberOfWheels = 0
            maxPassengers = 1
        }
    }
    
    class Car: Vehicle {
        var speed: Double = 0.0
        init() {
            super.init()
            maxPassengers = 5
            numberOfWheels = 4
        }
        override func description() -> String {
            return super.description() + "; "
                + "traveling at \(speed) mph"
        }
    }
    
    let car = Car()
    println("Car: \(car.description())")
    
    
    class SpeedLimitedCar: Car {
        override var speed: Double  {
            get {
                return super.speed
            }
            set {
                super.speed = min(newValue, 40.0)
            }
        }
        func subClassFunc(){
            println("我的青春我做主")
        }
        
        init(){}  //构造函数/初始器
        deinit{}  //析构函数/析构器
    }
    var normalCar:Car = Car()
    normalCar.speed = 100;
    var limitedCar = SpeedLimitedCar()
    
    normalCar = limitedCar
////    ((SpeedLimitedCar*)normalCar).subClassFunc();  //看来不能强制转换

    
}
inheritance();


//可选类型: ? 与 !
func optionalTest(){
    class Person {
        var residence: Residence?
        init(){}
    }
    
    class Residence {
        var numberOfRooms = 1
    }
    
    let john = Person()
    
    var xx:String?
    // ? 在residence为空的时候不会崩溃，返回的值是nil
    if let roomCount = john.residence?.numberOfRooms {
        xx = "John's residence has \(roomCount) room(s)."
    } else {
        xx = "Unable to retrieve the number of rooms."
    }
    println(xx?)
    
    // ！在residence为空的时候会再这里崩溃
    // this triggers a runtime error
    let roomCount = john.residence!.numberOfRooms
    
}
optionalTest();
