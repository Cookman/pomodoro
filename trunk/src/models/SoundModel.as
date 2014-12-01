/**
 * Created by Cookman on 02.11.14.
 */
package models {
import flash.media.SoundChannel;

import mx.core.SoundAsset;

public class SoundModel {

    private static var _instance:SoundModel = null;

    [Embed(source="/assets/beep.mp3")]
    private static var soundEffect:Class;
    private var ding:SoundAsset = new soundEffect() as SoundAsset;
    private var channel:SoundChannel;

    public function playSound():void {
        channel = ding.play();
    }

    public function stopSound():void {
        if (channel) {
            channel.stop();
        }
    }
}
}
