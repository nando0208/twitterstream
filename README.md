# Twitter Stream

The idea of this project is make a continuos stream of tweets filtered by a keyword.

### references:
* [Consuming Streaming Data](https://developer.twitter.com/en/docs/tutorials/consuming-streaming-data)
* [POST statuses/filter](https://developer.twitter.com/en/docs/tweets/filter-realtime/api-reference/post-statuses-filter.html)
* [Twitter Kit](https://github.com/twitter/twitter-kit-ios)

## Solution

### Stream Client

I made a StreamManager to be my streamlayer, it responsable to received data and erros.

We can use any stream request to start a new stream.

### Viper

Made using viper to be more testable and to divide responsabilities.

Using [SOLID](https://www.youtube.com/watch?v=TMuno5RZNeE) like reference.

### Tests

* Unit test to test my business layer.
* Snapshot to test my view states.

## Built With

* [SwiftLint](https://github.com/realm/SwiftLint)
* [Unbox](https://github.com/JohnSundell/Unbox)
* [TwitterKit](https://github.com/twitter/twitter-kit-ios)
* [Cartography](https://github.com/robb/Cartography)
* [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
* [Nimble-Snapshots](https://github.com/ashfurrow/Nimble-Snapshots)
* [Quick](https://github.com/Quick/Quick)
* [Nimble](https://github.com/Quick/Nimble)

## Next steps

* UITest end to end.
* Save data using a database local making offline experience more interesting;
* Redesign, I didn't spend time to make a beatiful layout. The ideia is make the view states more representative and we have more info to show in each tweet;
* Improve the experience with a grather limit. Now it works to receive and show more then five tweets, but the updates on TableView make the experience after scroll not good.

## Author

* **Fernando Ferreira** - [linkedin](https://www.linkedin.com/in/fernando01ferreira/)

## Questions?

Be confortable to send any question about the project:

*fernando01ferreira@gmail.com*
