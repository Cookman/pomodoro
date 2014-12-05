/**
 * Created by Cookman on 29.11.2014.
 */
package vo {
public class SettingsVO {

    public var playSound:Boolean;
    public var showPomodoroStatistic:Boolean;
    public var pomodoroLength:int;
    public var useFixedPomodoroLength:Boolean;


    public function SettingsVO(values:Object) {
        if (values.hasOwnProperty("playSound")) {
            playSound = values.playSound;
        }
        if (values.hasOwnProperty("showPomodoroStatistic")) {
            showPomodoroStatistic = values.showPomodoroStatistic;
        }
        if (values.hasOwnProperty("useFixedPomodoroLength")) {
            useFixedPomodoroLength = values.useFixedPomodoroLength;
        }
        if (values.hasOwnProperty("pomodoroLength")) {
            pomodoroLength = values.pomodoroLength;
        }
    }
}
}
