package models {
import flash.data.EncryptedLocalStore;
import flash.utils.ByteArray;

import vo.SettingsVO;

/**
 * Created by Cookman on 29.11.2014.
 */
public class LocalStorage {

    public static const SETTINGS:String = "Settings";

    public static function savePomodoro(pomodoroTime:String) {
        var jsonData:Object = getStorageObject(getDateString())
        jsonData[getTimeString()] = pomodoroTime;
        saveStorageObject(getDateString(), jsonData);
    }

    public static function getTodaysCount():int {
        var jsonData:Object = getStorageObject(getDateString())
        var count:int = 0;
        for each(var key:Object in jsonData) {
            count += 1;
        }
        return count;
    }

    private static function getStorageObject(key:String):Object {
        var storedValue:ByteArray = EncryptedLocalStore.getItem(key);
        var jsonData:Object;
        if (!storedValue) {
            jsonData = {};
        }
        else {
            var stringData = storedValue.readUTFBytes(storedValue.length)
            jsonData = JSON.parse(stringData);
        }
        return jsonData;
    }

    private static function saveStorageObject(key:String, object:Object):void {
        var bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(JSON.stringify(object));
        EncryptedLocalStore.setItem(key, bytes);
    }

    public static function saveSettings(settings:Object):void {
        saveStorageObject(SETTINGS, settings);
    }

    public static function loadSettings():SettingsVO {
        return new SettingsVO(getStorageObject(SETTINGS));
    }

    private static function getDateString():String {
        var d:Date = new Date();
        return d.toDateString();
    }

    private static function getTimeString():String {
        var d:Date = new Date();
        return d.toTimeString();
    }
}
}