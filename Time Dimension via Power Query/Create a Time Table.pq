let
    SecList = {0..86399},
    SecTable = Table.FromList(SecList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    SecType = Table.TransformColumnTypes(SecTable,{{"Column1", Int64.Type}}),
    SecName = Table.RenameColumns(SecType,{{"Column1", "Second"}}),
    TimeDurCol = Table.AddColumn(SecName,"TimeDuration", each #duration(0,0,0,[Second]), type duration),
    TimeCol = Table.AddColumn(TimeDurCol, "Time", each #time(Duration.Hours([TimeDuration]),Duration.Minutes([TimeDuration]),Duration.Seconds([TimeDuration])), type time),
    HourCol = Table.AddColumn(TimeCol, "Hour Number", each Time.Hour([Time]), Int64.Type),
    MinuteCol = Table.AddColumn(HourCol, "Minute Number", each Time.Minute([Time]), Int64.Type),
    SecondCol = Table.AddColumn(MinuteCol, "Second Number", each Time.Second([Time]), Int64.Type),
    HourMinuteCol = Table.AddColumn(SecondCol, "Hour Minute", each #time([Hour Number],[Minute Number],0), type time),
    AMPMCol = Table.AddColumn(HourMinuteCol,"AMPM", each if [Second] < 43200 then "AM" else "PM", type text),
    HourNmCol = Table.AddColumn(AMPMCol, "Hour", each 
        if [Hour Number] = 0 then "12 AM"
        else if [Hour Number] >= 1 and [Hour Number] <= 11 then Number.ToText([Hour Number]) & " AM" 
        else if [Hour Number] = 12 then "12 PM"
        else if [Hour Number] >= 13 then Number.ToText([Hour Number] - 12) & " PM"  
        else "Unknown", type text),
    HourlyQuartileCol = 
        Table.AddColumn(HourNmCol, "Hourly Quartile", each 
            if        [Hour Number] >= 0 and [Hour Number] <= 5 then "12AM to 6AM"
            else if   [Hour Number] >= 6 and [Hour Number] <= 11 then "6AM to 12PM"
            else if   [Hour Number] >= 12 and [Hour Number] <= 17  then "12PM to 6PM"
            else if   [Hour Number] >= 18 and [Hour Number] <= 23 then "6PM to 12AM"
            else "Unknown", type text
            ),
    HourlyQuartileSortCol = 
        Table.AddColumn(HourlyQuartileCol, "Hourly Quartile Sort", each 
            if        [Hour Number] >= 0 and [Hour Number] <= 5 then 1
            else if   [Hour Number] >= 6 and [Hour Number] <= 11 then 2
            else if   [Hour Number] >= 12 and [Hour Number] <= 17  then 3
            else if   [Hour Number] >= 18 and [Hour Number] <= 23 then 4
            else 5, Int64.Type
        ),
    RemoveTimeDurationCol = Table.RemoveColumns(HourlyQuartileSortCol,{"TimeDuration"})  
in
    RemoveTimeDurationCol