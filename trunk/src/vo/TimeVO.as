package vo {
[Bindable]
public class TimeVO {
    private var _hours:int;
    private var _minutes:int;
    private var _seconds:int;
    private var _secondsString:String = '00';
    private var _minutesString:String = '00';
    private var _hoursString:String = '00';
    public static const timeMin:int = 0;
    public static const timeMax:int = 59;

    public function TimeVO(hours:int = 0, minutes:int = 0, seconds:int = 0):void {
        this.hours = hours;
        this.minutes = minutes;
        this.seconds = seconds;
    }

    public function set secondsString(value:String):void {
        _secondsString = timeFormat(value);
    }

    public function get secondsString():String {
        return _secondsString;
    }

    public function get minutesString():String {
        return _minutesString;
    }

    public function set minutesString(value:String):void {
        _minutesString = value;
    }

    public function get hoursString():String {
        return _hoursString;
    }

    public function set hoursString(value:String):void {
        _hoursString = value;
    }

    public function get seconds():int {
        return _seconds;
    }

    public function set seconds(value:int):void {
        _seconds = checkValue(value);
        _secondsString = timeFormat(value.toString());
    }

    public function get minutes():int {
        return _minutes;
    }

    public function set minutes(value:int):void {

        _minutes = checkValue(value);
        _minutesString = timeFormat(value.toString());
    }

    public function get hours():int {
        return _hours;
    }

    public function set hours(value:int):void {
        _hours = value;
        _hoursString = timeFormat(value.toString());
    }

    private function checkValue(value:int):int {
        if (value > TimeVO.timeMax) value = TimeVO.timeMax;
        if (value < TimeVO.timeMin) value = TimeVO.timeMin;

        return value;
    }

    public function get notNull():Boolean {
        if (_hours == 0 && _minutes == 0 && _seconds == 0) return false

        return true;
    }

    private function timeFormat(value:String):String {
        var tValue:String = value;
        if (tValue.length < 2)
            tValue = '0' + tValue;
        return tValue;
    }

    public function updateTime(h:int, m:int, s:int):void {
        this.hoursString = timeFormat(h.toString());
        this.minutesString = timeFormat(m.toString());
        this.secondsString = timeFormat(s.toString());
        this.hours = h;
        this.minutes = m;
        this.seconds = s;
    }

    public function toString():String {
        return hoursString + ":" + minutesString + ":" + secondsString;
    }
}
}