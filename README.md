#  Result Type Demonstration

This contains a basic usage of the Result type, contained within `PizzaViewController.swift`.

A discussion of the Result-type can be found below:


## Table of Contents
1. Definition
2. A Simple Problem Example
3. Solution without Result
4. Solution with Result
5. Result with Exceptions
6. Future


## 1. Definition

Result is a new datatype, introduced in Swift 5, allowing you define success/failure as well as better define results from exception-throwing functions.

It is a monad, a concept from Functional Programming

>In functional programming, a monad is a design pattern that allows structuring programs generically while automating away boilerplate code needed by the program logic.
>
> Wikipedia, retrieved February 28, 2020

It is a generic datatype, whose definition can be simplified to the following:

```swift
enum Result<Success, Failure> where Failure : Error {
    case success(Success)
    case failure(Failure)
}
```


## 2. A Simple Problem Example

Consider a simple downloading task:

```swift
func fetch(_ completion: (_ data: Data?, _ error: Error?) -> Void) {
	// some downloading here        
}
```

In which the following cases want to be considered:

1. the request is successful and data is returned
2. the request is successful but the result is empty
3. the result failed from some network problem
4. the result failed from some server error

The latter three, of course, should give some special message to the user, while the first will populate some UI.


## 3. Solution without Result

Working with plain types, we could describe cases 1 and 2 together as an Optional.

But there lies an ambiguity problem when handling this:

```swift
fetch { (data, error) in
    if let data = data {
        // handle empty case here?
        
        // also handle data-case here?
    }
    if data == nil && error == nil {
        // or is empty case handled here?
    }
    else if let error = error {
        // determine the error and do something on error
    }
    // so what goes here?
}
```

Well, alright. We can redescribe it as a switch statement, instead:

```swift
fetch { (data, error) in
    switch (data, error) {
        case (let data):
        // handle empty case here?
        // also handle data-case here?
        case (let error):
        // determine the error and do something on error
        default:
        // so what goes here?
    }
}
```

Also not helping. We can describe each case as an enum, though

```swift
enum NetworkingResult<DataType> {
	case data(DataType)
	case emptyResponse
	case networkError
	case serverError
}
```

So now we have:

```swift

func fetch(_ completion: (_ result: NetworkingResult<Data>)-> Void) {
    // do some networking here
}
fetch { (result) in
    switch result {
        case .data(let data):
            /* ... */
        case .emptyResponse:
            /* ... */
        case .networkError:
            /* ... */
        case .serverError:
            /* ... */
    }
}
```

Okay, but, recall our previous requirement:

>The latter three, of course, should give some special message to the user

Each requirement is more readable and easy-to-use now, but we're not grouping the like-cases. It'll become more troublesome as we have larger sets of cases.


## 4. Solution with Result

You can probably already imagine where this is going. We can define the data-available result as successful, and the others as a failing case.

```swift
enum NetworkingError: Error {
    case emptyResponse
    case networkError
    case serverError
}

func fetch(_ completion: (_ result: Result<Data, NetworkingError>)-> Void) {
    // do some networking here
}

fetch { (result) in
    func handleFailure(_ error: NetworkingError) {
        switch error {
            case .emptyResponse:
            /* ... */
            case .networkError:
            /* ... */
            case .serverError:
            /* ... */
        }
    }
    switch result {
        case .success(let data):
        /* ... */
        case .failure(let error):
            handleFailure(error)
    }
}

```

Great. We're able to separate the successful case from the unsuccessfull cases.


## 5. Result with Exceptions

Result can also be used for methods that throw exceptions.

Here's another example: let's load some JSON file a file and then parse it.

```swift
struct Pizza: Decodable {
    let name: String
    let price: Float
}

func loadPizzas(from file: URL) throws -> [Pizza]  {
    let data = try Data(contentsOf: file)
    let decoder = JSONDecoder()
    let pizzas = try decoder.decode([Pizza].self, from: data)
    return pizzas
}
```

And we can load the pizzas like so

```swift
let pResult: Result<[Pizza], Error> = Result(catching: loadPizzas(from: myFileURL))
switch pResult {
    case .success(let pizzas):
    	// do something with pizzas
    case .failure(let error):
    	// handle error
}
```

The error now could be either the data-loading error or the decoding error.


## 6. Future

There is presently one pain-point when working with the Result type, however. Xcode is presently incapable of inferring your custom Error-types when working with it.

Maybe someday we'll have that level of auto-completion.






