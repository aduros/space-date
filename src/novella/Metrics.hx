//
// Space Date - A short visual novel
// https://github.com/aduros/space-date/blob/master/LICENSE.txt

package novella;

import flambe.System;

class Metrics
{
    inline public static function trackEvent (
        category :String, name :String, ?label :String, ?value :Int)
    {
        call([ TRACKER_PREFIX + "_trackEvent", category, name, label, value ]);
    }

    inline public static function setCustomVar (index :Int, name :String, value :String)
    {
        call([ TRACKER_PREFIX + "_setCustomVar", index, name, value, 1 ]);
    }

    private static function call (command :Array<Dynamic>)
    {
#if !debug
        System.callNative("analyticsCommand", [ command ]);
#end
    }

    inline public static function trackError (name :String, label :String, ?value :Int)
    {
        trackEvent("Errors", name, label, value);
    }

    private static inline var TRACKER_PREFIX = "novella.";
}
