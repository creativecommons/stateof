jQuery(function(){


var options = {
  useEasing : setting.easing,
  useGrouping : setting.grouping,
  separator : setting.separator,
  decimal : setting.decimal,
  prefix : setting.prefix,
  suffix : setting.suffix
};
var demo = new CountUp("counterupJSElement", setting.start, setting.end, setting.decimals, setting.duration, options);
demo.start();
});
