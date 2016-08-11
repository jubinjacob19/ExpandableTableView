[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# ExpandableTableView

Generic View Controller which can be used to show expandable sections in apps like FAQs. Accepts json data in the form [{"Question":"Question 1","Answer":"Answer 1"] and loads it in tableview with expandable/collapsible cells

# Installation with Carthage

To integrate ExpandableTableView into your Xcode project using Carthage, specify it in your Cartfile:
```carthage
github "jubinjacob19/ExpandableTableView"
```

# Usage

Initialize ExpandableTableViewController with an array of ItemModel objects

```swift
let faqs : [ItemModel] = // fetch ItemModel from your app
let expandableTableVC = ExpandableTableViewController(faqs: fetchQuestions())
```

Creating Item model
```swift
let item = ItemModel(question: "question", answer: "answer")
```
