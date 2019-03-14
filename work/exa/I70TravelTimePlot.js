//
// Date picker code (one for TO one for From)
var startDate = new Date(2010,4,1);
var today = new Date();


TimeConv = function(totalMinutes) {
	this.hours = Math.floor(totalMinutes / 60);
	this.minutes = totalMinutes % 60;
	return this;
}
TimeConv.prototype.constructor = TimeConv;
TimeConv.prototype.getString = function()
{
	var str = '';
	if (this.hours > 0 ) {
		str += this.hours + "h";
	}

	if ( this.minutes > 0 ) {
		str += " " + this.minutes + "min";
	}
	return str;
}


function fetchI70Data()
{
	$('#trafficPlotLoadingDiv').show();

	var jsStart = jstimeToYYYYMMDD( $('#from').datepicker("getDate") );
	var jsEnd = jstimeToYYYYMMDD( $('#to').datepicker("getDate") );

	if ( jsStart == undefined ) {
		jsStart = today;
	}
	if ( jsEnd == undefined ) {
		jsEnd = today;
	}

	var days = (jsEnd - jsStart)+1;
	var timestring = "%m/%d %h%p";
	if ( days <= 1 ) {
	   timestring = "%h%p";
	}

	var options = {
		//global series attributes
		series: {
			lines: {
				lineWidth: 1
			},
			points: {
				radius: 1
			}
		},
		colors: [ "#750000", "#001075"],
		lines: {
			show: true
		},
		points: {
			show: true
		},
		grid: {
			hoverable: true
		},
		legend: {
			show: true,
			position: 'nw'
		},
		xaxis: {
			mode: "time",
			timeformat: timestring
		},
		yaxis: {
			tickFormatter: function (val, axis)
			{
				return (formatHourString(val/60));
			}
		}
	};



	// then fetch the data with jQuery
	function onDataReceived(json) {
		$(document).ready(function() {
			console.log("data loaded");
			// Wait until the document is ready....in most cases, this should be immediate
			$.plot(placeholder, json.data.series, options);

			$('#trafficPlotLoadingDiv').hide();

			var statsText = "";
			var currentText = "";
			var startTime = 0;
			var endTime = 0;

			for (var direction in json.data.stats) {
  				if (json.data.stats.hasOwnProperty(direction)) {
					var x = json.data.stats[direction];
					var driveTime = new TimeConv(x.max);
					var timeVal = new Date(x.maxtime);

					if ( startTime == 0 || x.first_data_point.time < startTime ) {
						startTime = x.first_data_point.time;
					}

					if ( endTime == 0 || x.most_recent.time > endTime ) {
						endTime = x.most_recent.time;
					}

         			statsText += "Longest drive time " + direction + "bound: " +driveTime.getString() + " at " +
						timeVal.getNiceDateString() + "<br>";

					var current_driveTime = new TimeConv(x.most_recent.value);
					var current_timeVal = new Date(x.most_recent.time);
					var now_time = new Date();

					var normal_time = 58; // minutes
					var traffic_icon = 'traffic_icon_green';
					if ( x.most_recent.value > (normal_time * 1.7) ) {
					   traffic_icon = 'traffic_icon_red';
					} else if ( x.most_recent.value > (normal_time * 1.2) ) {
				       traffic_icon = 'traffic_icon_yellow';
					}


					// Check to see if the current_timeVal is not today...if so, then just drop this string
					if ( Math.abs(now_time - current_timeVal) < 86400000 )
					{
						currentText += "Current time " + direction +
						"bound: <div class='traffic_icon' id='" + traffic_icon + "'></div> " + current_driveTime.getString() + " at " +
							current_timeVal.getNiceDateString() + "<br>";
					}
				}
  			}

			var startTimeDateObj = new Date(startTime);
			var endTimeDateObj = new Date(endTime);

			var headerText =
	        "<h2>I-70 Travel Statistics between C-470 and Frisco (Colorado) between<br> " + startTimeDateObj.getNiceDateString() +
			" and " + endTimeDateObj.getNiceDateString()  + "</h2>";

			$('#stats').html(headerText + statsText + "<br>" + currentText);
		});




			/*

         print "Longest drive time: <b>$maxTime{hrs}h $maxTime{min}m</b> on " .
               prettyjsTime ( $stats->{$direction}->{maxtime} )
               . "<br>";
#         my $sign = $stats->{max}{$dir}{sign};
#         if ( $sign ne "" ) {
#            print "Sign message: $sign<br>";
#         }
         my %avgTime = hrs_min($stats->{$direction}->{cumtime} / $stats->{$direction}->{count});
         print "Average drive time: <b>$avgTime{hrs}h $avgTime{min}m</b> <br>";
{
west: {
count: 25,
most_recent: {
time: 1327851750000,
value: 59
},

         			statsText += "Longest drive time: " +driveTime.getString() + " at " +
						timeVal.getNiceDateString() + "<br>";
				}
  			}
			$('#stats').html(statsText);
		});




			/*

         print "Longest drive time: <b>$maxTime{hrs}h $maxTime{min}m</b> on " .
               prettyjsTime ( $stats->{$direction}->{maxtime} )
               . "<br>";
#         my $sign = $stats->{max}{$dir}{sign};
#         if ( $sign ne "" ) {
#            print "Sign message: $sign<br>";
#         }
         my %avgTime = hrs_min($stats->{$direction}->{cumtime} / $stats->{$direction}->{count});
         print "Average drive time: <b>$avgTime{hrs}h $avgTime{min}m</b> <br>";
{
west: {
count: 25,
most_recent: {
time: 1327851750000,
value: 59
},
cumtime: 1496,
max: 63,
maxtime: 1327795950000
},
east: {
count: 25,
most_recent: {
time: 1327851750000,
value: 147
},
cumtime: 2010,
max: 151,
maxtime: 1327849950000
}
},
*/

		};

	// Fire off the AJAX request to get the data
	$.ajax({
		type: "POST",
		url: '/info/i70_travel_backend.cgi',
		data: {
			start: jsStart,
			end: jsEnd
		},
		dataType: "json",
		cache: false,
		success: onDataReceived
	});
}

function initI70Traffic()
{
	// Initialize the date pickers
	var date_from = $('#from').datepicker({
		showOn: 'both',
		buttonImage: '/images/calendar.gif',
		buttonImageOnly: true,

		defaultDate: 0,
		changeMonth: true,
		numberOfMonths: 3,
		minDate: startDate,  //May 2, 2010
		maxDate: 0,
		onSelect: function(selectedDate) {
			datePicker_select(selectedDate, 'from', this);
		}
	});


	var date_to = $('#to').datepicker({
		showOn: 'both',
		buttonImage: '/images/calendar.gif',
		buttonImageOnly: true,

		defaultDate: 0,
		changeMonth: true,
		numberOfMonths: 3,
		minDate: startDate,  //May 2, 2010
		maxDate: 0,
		onSelect: function(selectedDate) {
			datePicker_select(selectedDate, 'to', this);
		}
	});

	//set the default date for the date pickers to today
	$('#to').datepicker("setDate", today);
	//$('#to').text(today);

	$('#from').datepicker("setDate", today);
	//$('#from').text(today);

	// bind the "fetch" button to the above fetchData routine
	$('#fetch').bind('click', function() {
		fetchI70Data();
	} );
}

// Set selectedDate, and whether this is 'to' or 'from'
function datePicker_select(selectedDate, mode, instance)
{

	var option = instance.id == "to" ? "minDate" : "maxDate";
	var instance_data = $(instance).data("datepicker");
	var date = $.datepicker.parseDate(instance_data.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance_data.settings);
	//instance.not(this).datepicker("option", option, date);

	if ( mode == 'to')
	{
		if ( $('#from').datepicker("getDate") > date  ) {
			$('#from').datepicker("setDate", date);
		}

	} else if ( mode == 'from') {
		// Determine if the to date is before this newly selected date - if so, shift it
		if ( $('#to').datepicker("getDate") < date  ) {
			$('#to').datepicker("setDate", date);
		}
	}
}

// FLOT plot class
$(function () {


	var placeholder = $("#placeholder");

	//Tooltip fcn
	function showTooltip(x, y, contents) {
		$('<div id="tooltip">' + contents + '</div>').css( {
			position: 'absolute',
			display: 'none',
			top: y + 5,
			left: x + 5,
			border: '1px solid #fdd',
			padding: '2px',
			'background-color': '#fee',
			opacity: 0.80
		}).appendTo("body").fadeIn(200);
	}

	// Mouseover tooltip event trigger
	var previousPoint = null;
	$("#placeholder").bind("plothover", function (event, pos, item) {
		$("#x").text(pos.x.toFixed(2));
		$("#y").text(pos.y.toFixed(2));

		if (item) {
			if (previousPoint != item.datapoint) {
				previousPoint = item.datapoint;

				$("#tooltip").remove();

				var tooltip = item.series.label + "bound at " +
				jstimeToMMDDHHMM(item.datapoint[0]) + ": " +formatHourString(item.datapoint[1]/60);
				showTooltip(item.pageX, item.pageY,
					tooltip);
			}
		}
		else {
			$("#tooltip").remove();
			previousPoint = null;
		}
	});





});


// Time formatting functions
function formatHourString( origTime )
{
	var hours = Math.floor(origTime);
	var mins = Math.round( (origTime - hours) * 60 );
	var string = hours + "h"
	if ( mins > 0 ) {
		string += " " + mins +"m";
	}
	return string;
}

var d_names = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
function jstimeToMMDDHHMM( jsTime )
{
	var returnStr;
	// http://www.webdevelopersnotes.com/tips/html/formatting_time_using_javascript.php3
	var a_p = "pm";
	var d = new Date(jsTime);

	var curr_day = d.getUTCDay();
	var curr_date = d.getUTCDate();
	var curr_month = d.getUTCMonth() + 1;
	var curr_hour = d.getUTCHours();
	var curr_min = d.getUTCMinutes();

	if (curr_hour < 12) {
		a_p = "am";
	}
	if (curr_hour == 0)    {
		curr_hour = 12;
	}
	if (curr_hour > 12){
		curr_hour = curr_hour - 12;
	}

	//	curr_min = curr_min + "";
	//	if (curr_min.length == 1){
	//	   curr_min = "0" + curr_min;
	//	}
	curr_min = zeroPad(curr_min, 2);

	returnStr = d_names[curr_day] + " " + curr_month + "/" + curr_date + "  " + curr_hour + ":" + curr_min + "" + a_p;

	return (returnStr);
}


//Take a javascript time object and output a date YYYYMMDD, use local time, not UTC
function jstimeToYYYYMMDD( jsTimeObj )
{
	var returnStr;

	// if no time passed in, return now
	if ( jsTimeObj == null ) {
		jsTimeObj = new Date();
	}

	var curr_date = jsTimeObj.getDate();
	var curr_month = jsTimeObj.getMonth() + 1;

	curr_month = zeroPad(curr_month, 2);
	curr_date = zeroPad(curr_date, 2);

	returnStr = jsTimeObj.getFullYear() + curr_month + curr_date;

	return (returnStr);
};

function zeroPad( arg, size )
{
	// Take a number and zero pad
	arg += "";
	while ( arg.length < size ) {
		arg = "0" + arg;
	}
	return arg;
};


// Tack on a new method to Date
var DAYS = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
var MON = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
Date.prototype.getNiceDateString = function() {
	// All of the times we use here are in UTC so they don't get muddled by local timezones
	var timeStr;

	var ampm = "am";
	var hours = this.getUTCHours();
	if ( this.getUTCHours() > 12 ) {
		ampm = "pm";
		hours -= 12;
	}
	if ( hours == 0 ) {
		hours = 12;
	}

	var minutes = zeroPad( this.getUTCMinutes(), 2 );
	timeStr = hours + ":" + minutes + " " + ampm + " ";
	timeStr += DAYS[ this.getUTCDay() ] + ", " + MON[ this.getUTCMonth() ] + " " + this.getUTCDate() + " ";
	return timeStr;
};

