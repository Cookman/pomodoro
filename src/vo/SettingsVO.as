/**
 * Created by Cookman on 29.11.2014.
 */
package vo {
import models.MindTimerModel;

public class SettingsVO {

    public var playSound:Boolean = false;
    public var showPomodoroStatistic:Boolean = false;
    public var pomodoroLength:int = 25;
    public var useFixedPomodoroLength:Boolean = false;
    public var templates:Array = [1, 5, 10, 25];
    public var useRecommends:Boolean = false;
    public var cycleRecommends:Boolean = false;
    public var recommends:Array = [];
    public var language:String = MindTimerModel.EN_US;
    public var resetDay:Boolean = false;

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
        if (values.hasOwnProperty("templates")) {
            templates = values.templates;
        }
        if (values.hasOwnProperty("useRecommends")) {
            useRecommends = values.useRecommends;
        }
        if (values.hasOwnProperty("recommends")) {
            recommends = values.recommends;
        }
        if (values.hasOwnProperty("cycleRecommends")) {
            cycleRecommends = values.cycleRecommends;
        }
        if (values.hasOwnProperty("language")) {
            language = values.language;
        }
        if (values.hasOwnProperty("resetDay")) {
            resetDay = values.resetDay;
        }
    }
}
}
