/**
 * Created by Cookman on 02.11.14.
 */
package models {
import flash.filesystem.File;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;

import mx.core.SoundAsset;

public class SoundModel {

    private static var _instance:SoundModel = null;


    [Embed(source="/assets/beep.mp3")]
    private static var soundEffect:Class;
    private var ding:SoundAsset = new soundEffect() as SoundAsset;
    private var channel:SoundChannel;

    public static const mp3SoundName:String = "dingdong.mp3"

    private var mp3File:Sound;

    public function playSound(useMp3:Boolean):void {
        if (useMp3) {
            var audiofile:File = File.applicationStorageDirectory.resolvePath(mp3SoundName);
            mp3File = new Sound(new URLRequest(audiofile.nativePath));
            channel = mp3File.play();
        }
        else {
            channel = ding.play();
        }
    }

    public function stopSound():void {
        if (channel) {
            channel.stop();
        }

    }
}
}
