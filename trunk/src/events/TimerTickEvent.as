package events
{
import flash.events.Event;

public class TimerTickEvent extends Event
	{
		public static const TIMER_TICK:String="timerTick";
		public static const TIMER_COMPLETE:String="timerComplete";
		public function TimerTickEvent(event:String,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(event, bubbles, cancelable);
		}
	}
}