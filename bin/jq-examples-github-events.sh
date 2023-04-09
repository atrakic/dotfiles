# https://www.fabian-keller.de/blog/5-useful-jq-commands-parse-json-cli/

## The GitHub Events API as Example

curl https://api.github.com/events > events.json

# Look at the third array element
cat events.json | jq '.[2]'


## 2) Extract a Specific Key for All Elements

# extract the repository name for each event
cat events.json | jq 'map(.repo.name)'

# extract the type and repository name for all events
cat events.json | jq 'map({type: .type, reponame:.repo.name})'


## 3) Filter By Specific Value

# first, apply the filter to select all elements that have the `type` property equal to `PushEvent`
cat events.json | jq '.[] | select(.type=="PushEvent")'

# then limit the output to the event type and the numbrer of commits
cat events.json | jq '.[] | select(.type=="PushEvent") | {type:.type, commits:(.payload.commits|length)}'



## 4) Extracting All JSON Paths

# first, in case the root element is an object and not an array, turn it into an array (so future commands work)
cat events.json | jq 'select(objects)|=[.]'

# get all paths to all scalar attributes (i.e. the leaf nodes of the JSON tree structure)
cat events.json | jq 'select(objects)|=[.] | map( paths(scalars) )'

# as we're not interested in array element indices, let's replace all numeric path elements with `[]`
cat events.json | jq 'select(objects)|=[.] | map( paths(scalars) ) | map( map(select(numbers)="[]"))'

# finally, join the paths to a single string and find all unique values
cat events.json | jq 'select(objects)|=[.] | map( paths(scalars) ) | map( map(select(numbers)="[]") | join(".")) | unique'


## 5) Deep Text Search

# finally, join the paths to a single string and find all unique values
cat events.json | jq 'select(objects)|=[.] | map( paths(scalars) ) | map( map(select(numbers)="[]") | join(".")) | unique'

# first store a reference to the complete data set - we'll need this later 
cat events.json | jq '. as $data | .'

# now with `..` traverse the whole tree applying the path() function to retrieve the location 
cat events.json | jq '. as $data | [path(..)]'

# we want to select only paths that are scalars (i.e. leaf nodes) and that match the regexp "merge"
cat events.json | jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ]'

# now that we have all the paths with matches, lets map them to an object with the key being a string representation of the key
cat events.json | jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ] | map({ (.|join(".")): "static" })'

# using the getpath function we can pop in the original value at the path (i.e. the scalar containing the match)
cat events.json | jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) })'

# finally reduce all key-value matches to a single object
cat events.json | jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) }) | reduce .[] as $item ({}; . * $item)'

# ?
cat events.json | jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) }) | reduce .[] as $item ({}; . * $item)'

