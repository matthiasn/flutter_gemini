# 3.0.0
* ## new Feature
1. Now you can use this package as a **dart** pkg.
2. prompt
3. promptStream

## 2.0.5
* ## Fixed
* `gemini-pro-vision` is depreciated, changed to `gemini-2.0-flash`

## 2.0.4-dev.1
* ## new feature
* reInitialize
* add mime type from Uint8List

## 2.0.3
* ## new feature
* GeminiException( message , statusCode)

## 2.0.1
* ## new feature
* Decode utf-8
* streamChat

## 2.0.0
* work for lower Dart SDK version

## 2.0.0-dev-1

* ## Add new crucial features
* ##### streamGenerateContent
* The model usually gives a response once it finishes generating the entire output. To speed up interactions, you can opt not to wait for the complete result and instead use streaming to manage partial results.
* ##### batchEmbedContents
* ##### embedContent
* Embedding is a method that transforms information, like text, into a list of floating-point numbers in an array. Gemini enables the representation of text, such as words or sentences, in a vectorized form. This facilitates the comparison of embeddings, allowing for the identification of similarities between texts through mathematical techniques like cosine similarity. For instance, texts with similar subject matter or sentiment should exhibit similar embeddings.
* ## Updates
* #### textAndImage
* Convert the image property to the `images`
```diff
- image: file.readAsBytesSync(), /// image
+ images: [file.readAsBytesSync()] /// list of images
```

## 1.0.1

* update pubspec

## 1.0.0

* first publish
