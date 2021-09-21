# centerRemove.swift
This code cancels out the center part of the stereo sound source by inversion processing. 

It only works in the local environment. 
Not for iOSApp.

Locally, the process usually finishes before the sound source starts playing.

For this reason, we use the Sleep function to wait for the processing to finish for the number of seconds of the sound source.

## Issues
Currently, the sound source is processed as stereo, which takes time to process.
If we can separate the stereo sound source into mono and play it back while always multiplying one of the values by -1, we expect to be able to process it in real time.

## Sample sound
The sample sound is a free sound source from a circle I belong to.

[https://youtu.be/IMLdSlLi7Nc](https://youtu.be/IMLdSlLi7Nc)