# GitHub-API-Swift
An app that downloads and displays list of latest Github commits for the apple/swift repository.

![](https://media.giphy.com/media/pjr0DjuecJhJN8IogC/giphy.gif)

## How this was achieved

The collection of data was done using the following steps:

The reference object (of the master branch) was first fetched.
Using the object.url from the response, the commit object was then retrieved.
The tree.url of the response from the commit object was then collected.

This lists all the files and folders within the respository. For folders a recursive fetch needs to be done to get all the files within.

Alternatively, you can add recursive=1 as a parameter to get all files in one large step. However, since theres an API request limit, this could not be done.

Once you retrieve the commit object, you have all the data you need for your model.

I avoided using any external libraries for the creation of this app.
