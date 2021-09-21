import Foundation
import AVFoundation

let url = URL(fileURLWithPath: "sample.mp3")
var audioEngine: AVAudioEngine = AVAudioEngine()
var audioFilePlayer: AVAudioPlayerNode = AVAudioPlayerNode()

doBlock: do {
	//Data reading (32-bit floating)
	let file = try AVAudioFile(forReading: url, commonFormat: .pcmFormatFloat32, interleaved: false)
	let audioFrameCount = UInt32(file.length)
	let format = file.processingFormat
	print(format)
	//Create AVAudioPCMBuffer in the same format as `file.processingFormat`.
	
	guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: audioFrameCount) else {
		print("Failed to create AVAudioPCMBuffer")
		break doBlock
	}

	//Loading into AVAudioPCMBuffer
	try file.read(into: buffer)
	//Convert to UnsafeBufferPointer
	var samples: [UnsafeBufferPointer<Float32>] = []
	let channels = Int(format.channelCount)
	for ch in 0..<channels {
		samples.append(UnsafeBufferPointer(start: buffer.floatChannelData![ch], count: Int(buffer.frameLength)))
	}
	
	//Inversion process (stereo)
	print("start inversion process")
	for num in 0..<Int(buffer.frameLength){
		buffer.floatChannelData![1][num] = buffer.floatChannelData![0][num] + buffer.floatChannelData![1][num]*(-1)
		buffer.floatChannelData![0][num] = buffer.floatChannelData![1][num]
	}
	print("end inversion process")

	let mainMixer = audioEngine.mainMixerNode
	
	audioEngine.attach(audioFilePlayer)
	audioEngine.connect(audioFilePlayer, to: mainMixer, format: buffer.format)
	audioEngine.prepare()
	
	try audioEngine.start()
	print("audioEngine.start")
	
	print("Play Audio")
	audioFilePlayer.play()
	audioFilePlayer.scheduleBuffer(buffer, completionHandler: nil)
	
	//The number of frames divided by the sampling frequency plus one second, 
	//and wait for the process to finish playing the music.
	sleep((buffer.frameLength/44100)+1) 
	print("end")
	
} catch {
	print(error)
}
