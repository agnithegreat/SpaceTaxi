/**
 * Created by agnither on 02.02.17.
 */
package com.holypanda.kosmos.tasks.server.vo
{
    import com.playfab.ClientModels.UserDataRecord;

    public class UserDataVO
    {
        public var money: String;
        public var noAds: String;
        public var levels: Object = {};
        public var episodes: Object = {};

        public function exportData():Object
        {
            var data: Object = {};
            data.Money = money;
            data.NoAds = noAds;
            data.Levels = JSON.stringify(levels);
            data.Episodes = JSON.stringify(episodes);
            return data;
        }

        public function importData(data: Object):void
        {
            for (var key: String in data)
            {
                var record: UserDataRecord = data[key];
                if (key == "Money")
                {
                    money = record.Value;
                } else if (key == "NoAds")
                {
                    noAds = record.Value;
                }else if (key == "Levels")
                {
                    levels = JSON.parse(record.Value);
                } else if (key == "Episodes")
                {
                    episodes = JSON.parse(record.Value);
                }
            }
        }
    }
}
