# Casino

Casino is a DSL which helps you interact with and explore your `Mongoid::Document` collections, and helps you more easily use MongoDB's aggregation framework.

### Casino works like this:

  1. Build a class and include Casino::Collection
    * This gives the class the following macros: `dimension`, `focus`, and `question`
    * The class also gains the following instance methods: `answer`, `intersection`, `projection`, and `query`

  2. Declare the parameters of your Casino class by defining it using the class-level macros.  You must define at least one `focus`, `dimension`, and `question`
    * A `focus` is a class name or a list of class names where Casino can expect to find a Mongoid document API (in other words, a class which includes `Mongoid::Document`)
    * A `dimension` defines an area of interest for the focus by name, then points to a specific `Mongoid::Document` field with a symbol or string.  This is usually something defined in the document model itself, but it can actually be anything, due to the schemaless nature of MongoDB.
      The third argument to a dimension is a symbol which points to an `attr_accessor` or instance method on the class which provides an array of `query` method invocations.  This list represents the different facets of the dimension.
    * Finally, a `question` is a specific action you want to use once you've produced the documents that your `dimension` and `focus` combinations have resulted in.
      In order to tap into the current intersection being queried, Casino provides the `intersection` helper, which is a combination of all the current dimension facets currently being questioned.

  3. Once defined, Casino will handle generation and querying of your generated collection from here on out.

## The Casino API

### Class (macro) methods

#### Dimension
  * **Arguments:**
    * *Label:* A "pretty name" for the dimension for easy display.
    * *Field:* This is a string or symbol which indicates the dimension's target field.
    * *Queries:* This is a symbol which references an instance method or accessor that produces an array of `Casino::Query` objects (built with the `query` instance method).
    * *Approach: (optional)* This is a hash which contains an `:operator` key, in case the dimension should query a field differently than the default (`where`) query plan, for example, `gt`, or `and`, etc.
  * **Returns:** A `Casino::Dimension` object.
  * **What it does:** The `dimension` class method creates a `Casino::Dimension` object and registers it with the `Casino::Collection` the parent class is a part of.  From that point on, the dimension will be used as a factor in building out the following:
    * A generated collection key (`_id`).
    * The generated collection name.
    * The intersections for the aggregation, where Casino will ask any questions it is given.

#### Focus
  * **Arguments:**
    * *Models:* A class which includes the `Mongoid::Document` module.
  * **Returns:** A `Casino::Focus` object.
  * **What it does:** Creates a `Casino::Focus` object and registers it with the `Casino::Collection` of the parent class.  From that point on, the focus object is used in the following way:
    * The generated collection name.
    * The targets for dimensional intersection questions.
    * The subject material for aggregate data.

#### Question
  * **Arguments:**
    * *Name:* The name of the question, this is what the question will be registered under.
    * *Answer:* This is a `:method_name`.
  * **Returns:** A `Casino::Question` object
  * **What it does:** Creates a `Casino::Question` object for the given arguments, and registers it with the `Casino::Collection` of the parent class.

    A `Casino::Question` represents the actual operation which will be performed on a focus at a given dimensional intersection.

    When methods marked with the `question` macro are run, the following instance variables become available:

      * `answer`: An answer to another question at the current intersection.
      * `intersection`: The current intersection criteria.
      * `projection`: A MongoDB aggregation framework wrapper scoped to the current intersection.

### Instance methods

#### Answer (*pending*)
  * **Arguments:**
    * *Method name:* A `:symbol` pointing to another question.  This method returns the results of that question.
  * **Returns:** An answered question key/value pair: `{ question_name: question_answer }`

#### Insert (*pending*)
  * **Arguments:**
    * *Documents:* Any argument passed in will be evaluated as though it were a `Mongoid::Document` of the collection's focus.
  * **Returns:** Any results which were updated with the given documents.
  * **What it does:** `insert` is a trickle-in mechanism, which scopes any matching intersections with a given document's `id`, and then attempts to ask questions of it.  If any questions are answered, then it modifies the intersection's record with the results.

#### Intersection
  * **Arguments:** None
  * **Returns:** `Mongoid::Criteria` - A window into the currently active criteria being questioned.

#### Projection (*pending*)
  * **Arguments:** None
  * **Returns:** A `Casino::Projection` object preloaded with the current intersection selector, which wraps around MongoDB's aggregation framework.

#### Query
  * **Arguments:**
    * *Label:* A string or symbol that indicates a field to store the query's results in
    * *Criterion:* A list of items to use to search within the `question` field
  * **Returns:** A `Casino::Query` instance for use to build outputs as well as to build `Casino::Intersection` objects with.

#### Results
  * **Arguments:** None
  * **Returns:** A list of answer hashes for every intersection.  Casino persists intersection results to a generated MongoDB collection the first time it is used, and afterward will just combine already produced results with new results (in essence, it only queries for new information and remembers the rest).

#### Update (*pending*)
  * **Arguments:** None
  * **Returns:** Re-generates the entire generated collection.
